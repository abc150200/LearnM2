//
//  LMAppRecommendViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMAppRecommendViewController.h"
#import "LMLoginViewController.h"

@interface LMAppRecommendViewController ()

@end

@implementation LMAppRecommendViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    //设置尾部标题
    [self setupFooterView];
    
    self.tableView.rowHeight = 60;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"avatar_default"];
    cell.textLabel.text = @"狐狸电台";
    cell.detailTextLabel.text = @"描述信息";
    
    return cell;
}

- (void)setupFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    btn.frame = CGRectMake(60, 10, 200, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [footView addSubview:btn];
    
    self.tableView.tableFooterView = footView;
    
    
    [btn addTarget:self action:@selector(logoutBtn) forControlEvents:UIControlEventTouchUpInside];
}


- (void)logoutBtn
{
    LMLoginViewController *li = [[LMLoginViewController alloc] init];
    [self.navigationController pushViewController:li animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning 需要判断.下载?打开
    
}


@end
