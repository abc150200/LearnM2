//
//  LMMyOrderVC.m
//  LearnMore
//
//  Created by study on 15-1-9.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMMyOrderVC.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AFNetworking.h"
#import "AESenAndDe.h"
#import "LMMyOrderViewCell.h"
#import "LMRefundVC.h"
#import "LMMyOrder.h"
#import "LMOrderCourse.h"
#import "LMMyOrderDetailVC.h"
#import "MJRefresh.h"
#import "LMCourseListMainViewController.h"


@interface LMMyOrderVC ()
@property (nonatomic, strong) NSMutableArray *orderArr;
@property (nonatomic, assign) int tCount;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@end

@implementation LMMyOrderVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //添加下拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    
    //主动显示菊花
    [self.tableView headerBeginRefreshing];
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
    UILabel *label  = [[UILabel alloc] init];
    label.width = 100;
    label.height = 40;
    label.centerX = self.view.centerX;
    label.y = 0;
    //            label.text = @"已加载全部";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [moreView addSubview:label];
    self.tableView.tableFooterView = moreView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 102;
   
    
    self.title = @"我购买的课程";
    
    self.firstView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    //添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
  
}


- (void)loadNewData
{
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"pay/orderList.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"startIndex"] = @"0";
    arr[@"count"] = @"5";
    arr[@"time"] = [NSString timeNow];
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"jsonStr=============%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sid"] = account.sid;
    parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
    
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    MyLog(@"parameters==============%@",parameters);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MyLog(@"responseObject===============%@",responseObject);
        
        NSString *collectStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
        
        MyLog(@"collectStr===============%@",collectStr);
        
        NSDictionary *dict = [collectStr objectFromJSONString];
        MyLog(@"dict===%@",dict);
        
        NSArray *orderArr = [LMMyOrder objectArrayWithKeyValuesArray:dict[@"dtsList"]];
        self.orderArr = (NSMutableArray *)orderArr;
        
        int count = [dict[@"tcount"] intValue];
        self.tCount = count;
        
        if (self.orderArr.count == 0) {
            [self.tableView addSubview:self.firstView];
            self.firstView.frame = CGRectMake(0, 0, MainViewWidth, MainViewHeight);
            MyLog(@"self.firstView.frame===%@",NSStringFromCGRect(self.firstView.frame));
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        } else
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


- (void)loadMoreData
{
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"pay/orderList.json"];
    
    if(self.orderArr.count < 5 || self.orderArr.count == self.tCount )
    {
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
        return;
        
    }
    
    int count = self.orderArr.count + 1;
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"count"] = @"5";
    arr[@"time"] = [NSString timeNow];
    arr[@"startIndex"] = [NSString stringWithFormat:@"%d",count];
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"jsonStr=============%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sid"] = account.sid;
    parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
    
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    MyLog(@"parameters==============%@",parameters);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MyLog(@"responseObject===============%@",responseObject);
        
        NSString *collectStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
        
        MyLog(@"collectStr===============%@",collectStr);
        
        NSDictionary *dict = [collectStr objectFromJSONString];
        MyLog(@"dict===%@",dict);
        
        NSArray *newOrderArr = [LMMyOrder objectArrayWithKeyValuesArray:dict[@"dtsList"]];
        [self.orderArr addObjectsFromArray:newOrderArr];
        
       
        [self.tableView reloadData];
        
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
    }];
    
}


- (IBAction)findBtn:(id)sender {
    
    LMCourseListMainViewController *mv = [[LMCourseListMainViewController alloc] init];
    
    [self.navigationController pushViewController:mv animated:YES];
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    LMMyOrderViewCell  *cell = [LMMyOrderViewCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    cell.myOrder = self.orderArr[indexPath.row];
    
    // 3.返回cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMMyOrder *myOrder = self.orderArr[indexPath.row];
    
    LMMyOrderDetailVC *mv = [[LMMyOrderDetailVC alloc] init];
    mv.orderId = myOrder.id;
    [self.navigationController pushViewController:mv animated:YES];
}



- (NSMutableArray *)orderArr
{
    if (_orderArr == nil) {
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}

@end
