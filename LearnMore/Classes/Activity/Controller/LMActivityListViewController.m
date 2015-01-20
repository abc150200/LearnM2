//
//  LMActivityListViewController.m
//  LearnMore
//
//  Created by study on 14-12-24.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMActivityListViewController.h"
#import "LMActivityViewCell.h"
#import "LMActivityDetailViewController.h"
#import "AFNetworking.h"
#import "LMActList.h"
#import "MJRefresh.h"
#import "LMAccount.h"
#import "LMAccountInfo.h"

@interface LMActivityListViewController ()
@property (nonatomic, strong) NSMutableArray *actLists;
@property (nonatomic, assign) int tCount;
@end

@implementation LMActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 185;
    
   
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


//下拉刷新
- (void)setupRefresh
{
    //添加下拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    
    //主动显示菊花
    [self.tableView headerBeginRefreshing];
    
    //添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}


- (void)loadNewData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"activity/list.json"];
    
    self.arr[@"startindex"] = @"0";
    NSString *jsonStr = [self.arr JSONString];
    MyLog(@"jsonStr=下拉刷新==========%@",jsonStr);
    

    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    //设备信息
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    if(account)
    {
        parameters[@"sid"] = account.sid;
    }
    
    MyLog(@"parameters=下拉刷新==========%@",parameters);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MyLog(@"responseObject=下拉刷新===========%@",responseObject);
        
        NSDictionary *actListDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"data=下拉刷新==========%@",actListDic);
        
        NSArray *actList = actListDic[@"list"];
        
        
        self.actLists = (NSMutableArray *)[LMActList objectArrayWithKeyValuesArray:actList];
        
        int count = [actListDic[@"tcount"] intValue];
        self.tCount = count;
        
        if(self.actLists.count == 0)
        {
            UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
            UILabel *label  = [[UILabel alloc] init];
            label.width = 100;
            label.height = 40;
            label.centerX = self.view.centerX;
            label.y = 0;
            label.text = @"暂无数据";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
            moreView.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
            [moreView addSubview:label];
            self.tableView.tableFooterView = moreView;
            [self.tableView reloadData];
            
        }else
        {
            [self.tableView reloadData];
        }
        
        
        
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"activity/list.json"];
    
    if(self.actLists.count < 5 || self.actLists.count == self.tCount )
    {
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
        return;
        
    }
    
    int count = self.actLists.count + 1;
    
    self.arr[@"startindex"] = [NSString stringWithFormat:@"%d",count];
    self.arr[@"time"] = [NSString timeNow];
    
    NSString *jsonStr = [self.arr JSONString];
    MyLog(@"jsonStr=上拉刷新=============%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    
    //设备信息
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    
    MyLog(@"parameters=上拉刷新==============%@",parameters);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MyLog(@"responseObject=上拉刷新==============%@",responseObject);
        
        NSDictionary *actListDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"data=上拉刷新==============%@",actListDic);
        
        NSArray *actList = actListDic[@"list"];
        
         NSArray *newListArr = [LMActList objectArrayWithKeyValuesArray:actList];
        
        [self.actLists addObjectsFromArray:newListArr];

        [self.tableView reloadData];

     
     // 3.关闭菊花
     [self.tableView footerEndRefreshing];
     
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         LogObj(error.localizedDescription);
         
         // 3.关闭菊花
         [self.tableView footerEndRefreshing];
         
     }];
    
    
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
