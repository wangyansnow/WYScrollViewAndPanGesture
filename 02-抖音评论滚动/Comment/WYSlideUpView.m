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

@end

@implementation WYSlideUpView

+ (instancetype)slideUpWithFrame:(CGRect)frame contentView:(UIView *)contentView {
    return [[self alloc] initWithFrame:frame contentView:contentView];
}
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

- (void)showInView:(UIView *)view completion:(dispatch_block_t)completion {
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
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:gesture.view];
    NSLog(@"location = %@", NSStringFromCGPoint(location));
    if (CGRectContainsPoint(self.contentView.frame, location)) {
        NSLog(@"点击了contentView");
    } else {
        NSLog(@"点击了空白区域");
        [self dismiss:nil];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:gesture.view];
    NSLog(@"translation = %@", NSStringFromCGPoint(translation));
    
    UIGestureRecognizerState state = gesture.state;
    if (state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始");
    } else if (state == UIGestureRecognizerStateChanged) {
        CGFloat y = translation.y; // 正数 --> 向下移动
        [self addY:y];
        
    } else if (state == UIGestureRecognizerStateEnded) {
        NSLog(@"结束");
        
        CGRect contentFrame = self.contentView.frame;
        CGFloat h = CGRectGetHeight(contentFrame);
        CGFloat minY = CGRectGetHeight(self.bounds) - h;
        CGFloat y = self.contentView.frame.origin.y;
        
        if (y - minY > h * 0.5) { // dismiss
            [self dismiss:nil];
        } else { // 恢复
            [self restoreContentView:nil];
        }
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

@end
