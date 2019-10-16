//
//  ViewController.m
//  02-抖音评论滚动
//
//  Created by 王俨 on 2019/10/16.
//  Copyright © 2019 https://github.com/wangyansnow. All rights reserved.
//

#import "ViewController.h"
#import "WYCommentView.h"
#import "CommonMacro.h"
#import "WYSlideUpView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI {
//    CGFloat h = 400;
//    WYCommentView *commentView = [[WYCommentView alloc] initWithFrame:CGRectMake(0, SCREEN_H - h, SCREEN_W, h)];
//    [self.view addSubview:commentView];
}
- (IBAction)showBtnClick:(UIButton *)sender {
    CGFloat h = 400;
    WYCommentView *commentView = [[WYCommentView alloc] initWithFrame:CGRectMake(0, SCREEN_H - h, SCREEN_W, h)];
    WYSlideUpView *slideUpView = [[WYSlideUpView alloc] initWithFrame:self.view.bounds contentView:commentView];
    
    [slideUpView showInView:self.view completion:^{
        NSLog(@"%s", __func__);
    }];
}


@end
