//
//  WYSlideUpView.h
//  02-抖音评论滚动
//
//  Created by 王俨 on 2019/10/16.
//  Copyright © 2019 https://github.com/wangyansnow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYSlideUpView : UIView

- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView;

- (void)showInView:(UIView *)view completion:(nullable dispatch_block_t)completion;
- (void)dismiss:(nullable dispatch_block_t)completion;

@end

NS_ASSUME_NONNULL_END
