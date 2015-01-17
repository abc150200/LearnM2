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

@interface LMMyOrderVC ()
@property (nonatomic, strong) NSMutableArray *orderArr;
@end

@implementation LMMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.rowHeight = 102;
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"我的订单";
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"pay/orderList.json"];
        
        
        //参数
        NSMutableDictionary *arr = [NSMutableDictionary dictionary];
        arr[@"startIndex"] = @"1";
        arr[@"count"] = @"5";
        arr[@"time"] = [NSString timeNow];
        
        NSString *jsonStr = [arr JSONString];
        MyLog(@"jsonStr=============%@",jsonStr);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"sid"] = account.sid;
        parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
        
        MyLog(@"parameters==============%@",parameters);
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            MyLog(@"responseObject===============%@",responseObject);
            
            NSString *collectStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
            
            MyLog(@"collectStr===============%@",collectStr);
            
            NSDictionary *dict = [collectStr objectFromJSONString];
            
            NSArray *orderArr = [LMMyOrder objectArrayWithKeyValuesArray:dict[@"dtsList"]];
            self.orderArr = (NSMutableArray *)orderArr;
            
            [self.tableView reloadData];
            
            MyLog(@"dict===%@",dict);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
        }];
    }
    
    
    
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
    
    LMRefundVC *rv = [[LMRefundVC alloc] init];
    rv.orderId = myOrder.id;
    rv.productName = myOrder.productName;
    rv.productCount = myOrder.productCount;
    rv.discountPrice = myOrder.discountPrice;
    
    LMOrderCourse *course = myOrder.course;
    rv.courseName = course.courseName;
    
    [self.navigationController pushViewController:rv animated:YES];
}



- (NSMutableArray *)orderArr
{
    if (_orderArr == nil) {
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}

@end
