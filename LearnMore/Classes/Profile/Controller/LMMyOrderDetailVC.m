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
#import "LMRefundVC.h"

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
@property (weak, nonatomic) IBOutlet UILabel *protectDes;
@property (weak, nonatomic) IBOutlet UIView *protectView;

@property (weak, nonatomic) IBOutlet UIView *footView;

@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (weak, nonatomic) IBOutlet UIButton *payToSchBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuslabeltitle;

@property (copy, nonatomic) NSString *orderCourseName;
@property (nonatomic, assign) NSInteger discountPrice;



@end

@implementation LMMyOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"订单详情";
    
    self.protectDes.textColor= UIColorFromRGB(0xd8cb00);
    
    LMMyOrderCourseVC *cl = [[LMMyOrderCourseVC alloc] init];
    self.cl = cl;
    [self.courseView addSubview:cl.view];
    [self addChildViewController:cl];
    cl.view.frame = CGRectMake(0, 0, 320, 98);
    
    self.protectView.hidden = YES;
    self.footView.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        
        self.courseNameLabel.text = dataDic[@"productName"];
        self.orderIdLabel.text = dataDic[@"id"];
        self.orderTime.text = [NSString oderTimeWithLong:[dataDic[@"createTime"] longLongValue]];
        self.orderCountLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"productCount"]];
        
        self.discountPrice = [dataDic[@"discountPrice"] longValue];
        
        long long result = [dataDic[@"discountPrice"] longValue] * [dataDic[@"productCount"]longValue];
        self.orderTotalLabel.text = [NSString stringWithFormat:@"%lli元",result];
        self.contactLabel.text = dataDic[@"contactName"];
        self.phoneLabel.text = dataDic[@"contactPhone"];
        
        //状态判断
        NSString *statusStr = dataDic[@"orderStatusDes"];
        if ([statusStr isEqualToString:@"资金保护期"]) {
            self.protectView.hidden = NO;
            self.footView.hidden = NO;
            self.statuslabeltitle.hidden = YES;
        }else
        {
            self.statuslabeltitle.hidden = NO;
            self.statusLabel.text = statusStr;
            self.protectView.hidden = YES;
            self.footView.hidden = YES;
        }
       
        
        //订单详情页头部
        LMCourseList *courseList = [LMCourseList objectWithKeyValues:dataDic[@"course"]];
        NSArray *courseListArr = @[courseList];
        
        //订单课程名
        self.orderCourseName = dataDic[@"course"][@"courseName"];
        
        self.cl.courseLists = courseListArr;
        
        [self.cl.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];

}

//付款给机构
- (IBAction)payTo:(id)sender {
    
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"确定结账付款给学校吗?" message:@"结账给学校之后,资金将脱离学校的保护期,如遇退款只能与学校进行协商" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.delegate = self;
    alert.tag = 100;
    [alert show];
    
}


- (void)payToSchool
{
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"pay/payOrder.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"orderId"] = self.orderId;
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
        
        long code = [responseObject[@"code"] longValue];
        
        if (code == 10001) {
            self.statusLabel.text = @"交易成功";
            self.protectView.hidden = YES;
            self.footView.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];

}


//申请退款
- (IBAction)callBack:(id)sender {
    
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"确定要申请退款吗?" message:@"申请退款后,你讲无法在学校报名成功,如果已经在学习,申请退款后将无法继续学习" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.delegate = self;
     alert.tag = 101;
    [alert show];

}

- (void)payBack
{
    LMRefundVC *rv = [[LMRefundVC alloc] init];
    rv.orderId = self.orderId;
    rv.productName = self.courseNameLabel.text;
    rv.productCount = self.orderCountLabel.text.intValue;
    rv.discountPrice = self.discountPrice;
    rv.courseName = self.orderCourseName;
    
    [self.navigationController pushViewController:rv animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100){
            if (buttonIndex == 1) {
                [self payToSchool];
            }
    }else if (alertView.tag == 101){
        if (buttonIndex == 1) {
            [self payBack];
        }
    }
        
    
}

@end
