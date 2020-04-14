//
//  WYSlideUpView.m
//  02-抖音评论滚动
//
//  Created by 王俨 on 2019/10/16.
//  Copyright © 2019 https://github.com/wangyansnow. All rights reserved.
//

#import "WYSlideUpView.h"
#import "CommonMacro.h"

@interface WYSlideUpView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation WYSlideUpView

- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView {
    if (self = [super initWithFrame:frame]) {
        CGRect contentFrame = contentView.frame;
        contentFrame.origin.y = CGRectGetHeight(frame);
        contentView.frame = contentFrame;
        
        self.contentView = contentView;
        [self addSubview:contentView];
        
        [self addGesture];
    }
    return self;
}

- (void)showInView:(UIView *)view completion:(nullable dispatch_block_t)completion {
    [view addSubview:self];
    [self restoreContentView:completion];
}
- (void)dismiss:(nullable dispatch_block_t)completion {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.y = CGRectGetHeight(self.bounds);
        self.contentView.frame = contentFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        !completion ?: completion();
    }];
}

#pragma mark - private
- (void)addGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    self.tapGesture = tapGesture;
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    self.panGesture = panGesture;
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:gesture.view];
//    NSLog(@"location = %@", NSStringFromCGPoint(location));
    if (!CGRectContainsPoint(self.contentView.frame, location)) {
        [self dismiss:nil];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:gesture.view];
    
    UIGestureRecognizerState state = gesture.state;
    if (state == UIGestureRecognizerStateBegan) {
    } else if (state == UIGestureRecognizerStateChanged) {
        
        if (self.scrollView) { // 手势落在scrollView上
            CGFloat offsetY = self.scrollView.contentOffset.y; // 负数向下滑动
//            NSLog(@"scrollY = %@", @(offsetY));
            if (offsetY <= 0 && translation.y > 0) {
                self.scrollView.contentOffset = CGPointZero;
                [UIView animateWithDuration:0.25 animations:^{
                    self.scrollView.panGestureRecognizer.enabled = NO;
                }];
                [self addY:translation.y];
            } else if(translation.y < 0) {
                [self addY:translation.y];
            }
        } else {
            CGFloat y = translation.y; // 正数 --> 向下移动
            [self addY:y];
        }
    } else if (state == UIGestureRecognizerStateEnded) {
        
        CGRect contentFrame = self.contentView.frame;
        CGFloat h = CGRectGetHeight(contentFrame);
        CGFloat minY = CGRectGetHeight(self.bounds) - h;
        CGFloat y = self.contentView.frame.origin.y;
        
        CGPoint velocity = [gesture velocityInView:gesture.view];
//        NSLog(@"velocity = %@", NSStringFromCGPoint(velocity));
        
        if (y - minY > h * 0.5 || ((self.scrollView && self.scrollView.contentOffset.y == 0) && velocity.y > CGRectGetHeight(self.bounds) * 0.5)) { // dismiss
            [self dismiss:nil];
        } else { // 恢复
            [self restoreContentView:nil];
        }
        
        self.scrollView.panGestureRecognizer.enabled = YES;
        self.scrollView = nil;
    }
    
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (void)addY:(CGFloat)changeY {
    
    CGRect contentFrame = self.contentView.frame;
    CGFloat minY = CGRectGetHeight(self.bounds) - CGRectGetHeight(contentFrame);
    CGFloat y = contentFrame.origin.y + changeY;
    if (y < minY) return;
    contentFrame.origin.y = y;
    self.contentView.frame = contentFrame;
}

- (void)restoreContentView:(nullable dispatch_block_t)completion {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(contentFrame);
        self.contentView.frame = contentFrame;
    } completion:^(BOOL finished) {
        !completion ?: completion();
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        return CGRectContainsPoint(self.contentView.frame, [gestureRecognizer locationInView:gestureRecognizer.view]);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer != self.panGesture) return YES;
    
    Class cls = NSClassFromString(@"UITableViewWrapperView");
    UIView *touchView = touch.view;
    while (touchView) {
        if (![touchView isKindOfClass:cls] && [touchView isKindOfClass:[UIScrollView class]]) {
            self.scrollView = (UIScrollView *)touchView;
            break;
        }
        
        touchView = (UIView *)[touchView nextResponder];
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.panGesture == gestureRecognizer && [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    return NO;
}

@end
