//
//  LMMyOrderDetailVC.m
//  LearnMore
//
//  Created by study on 15-1-17.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMMyOrderDetailVC.h"
#import "AFNetworking.h"
#import "LMAccount.h"
#import "LMAccountInfo.h"
#import "AESenAndDe.h"
#import "LMMyOrderCourseVC.h"
#import "LMCourseList.h"

@interface LMMyOrderDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *courseView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) LMMyOrderCourseVC *cl;
@end

@implementation LMMyOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"订单详情";
    
    LMMyOrderCourseVC *cl = [[LMMyOrderCourseVC alloc] init];
    self.cl = cl;
    [self.courseView addSubview:cl.view];
    [self addChildViewController:cl];
    cl.view.frame = CGRectMake(0, 0, 320, 98);
    
    
    [self loadData];
}


- (void)loadData
{
    
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"pay/orderInfo.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = self.orderId;
    arr[@"startIndex"] = @"1";
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
        
        //数据
        NSDictionary *dataDic = dict[@"dts"];

        LMCourseList *courseList = [LMCourseList objectWithKeyValues:dataDic[@"course"]];
        NSArray *courseListArr = @[courseList];
        
        self.cl.courseLists = courseListArr;
        
        [self.cl.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];

}


@end
