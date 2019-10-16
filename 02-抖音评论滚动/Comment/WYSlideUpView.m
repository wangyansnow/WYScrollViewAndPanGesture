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
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(contentFrame);
        self.contentView.frame = contentFrame;
    } completion:^(BOOL finished) {
        !completion ?: completion();
    }];
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

#pragma mark - UIGestureRecognizerDelegate

@end
