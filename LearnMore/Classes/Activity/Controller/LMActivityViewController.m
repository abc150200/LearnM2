//
//  LMListenActivityViewController.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMActivityViewController.h"
#import "LMActivityViewCell.h"
#import "LMActivityDetailViewController.h"
#import "AFNetworking.h"
#import "LMActList.h"
#import "MJRefresh.h"


@interface LMActivityViewController ()
@property (nonatomic, strong) NSMutableArray *actLists;


@end

@implementation LMActivityViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"亲子活动";
    
    self.tableView.rowHeight = 185;
    
    //下拉刷新控件
    [self setupRefresh];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

//下拉刷新
- (void)setupRefresh
{
    //添加下拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(loadData)];
    
    //主动显示菊花
    [self.tableView headerBeginRefreshing];
    
    //添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

- (void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"activity/list.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"area"] = @"0_0";
    arr[@"count"] = @"20";
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    //设备信息
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MyLog(@"%@",responseObject);
        MyLog(@"==========================================");
        
        NSDictionary *actListDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"%@",actListDic);
        
        NSArray *actList = actListDic[@"list"];
        LogObj(actList);
        
        
        self.actLists = [LMActList objectArrayWithKeyValuesArray:actList];
        
        [self.tableView reloadData];
    
        // 3.关闭菊花
        [self.tableView headerEndRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
        // 3.关闭菊花
        [self.tableView headerEndRefreshing];
    }];
    
}

//上拉刷新
- (void)loadMoreData
{
    // 3.关闭菊花
    [self.tableView footerEndRefreshing];
    
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMActivityViewCell *cell = [LMActivityViewCell cellWithTableView:tableView];
    
    cell.actlist = self.actLists[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LMActivityViewCell *cell = (LMActivityViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //跳转详情页面
    LMActivityDetailViewController *ad = [[LMActivityDetailViewController alloc] init];
    ad.id = cell.id;
    
    ad.actName = cell.actlist.actTitle;
    MyLog(@"actName===%@",cell.actlist.actTitle);
    [self.navigationController pushViewController:ad animated:YES];
}


/** 懒加载 */

- (NSMutableArray *)actLists
{
    if (_actLists == nil) {
        _actLists = [NSMutableArray array];
    }
    return _actLists;
}
@end
