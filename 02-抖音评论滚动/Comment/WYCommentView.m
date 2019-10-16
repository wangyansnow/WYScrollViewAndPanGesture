//
//  WYCommentView.m
//  02-抖音评论滚动
//
//  Created by 王俨 on 2019/10/16.
//  Copyright © 2019 https://github.com/wangyansnow. All rights reserved.
//

#import "WYCommentView.h"
#import "CommonMacro.h"

@interface WYCommentView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation WYCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self fetchData];
    }
    return self;
}

- (void)setupUI {
    CGFloat titleH = 40;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, titleH)];
    titleView.backgroundColor = [UIColor redColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleH, SCREEN_W, CGRectGetHeight(self.bounds) - titleH) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self addSubview:titleView];
    [self addSubview:tableView];
}

- (void)fetchData {
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i < 20; i++) {
        [arrM addObject:@(i)];
    }
    
    self.dataSource = arrM;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"Wing";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", @(indexPath.row));
}

@end
