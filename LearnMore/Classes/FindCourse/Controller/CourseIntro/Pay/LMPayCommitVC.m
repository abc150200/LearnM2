//
//  LMPayCommitVC.m
//  LearnMore
//
//  Created by study on 15-1-7.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMPayCommitVC.h"
#import "LMActBookVC.h"
#import "LMPaySuccessViewController.h"
#import "AFNetworking.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AESenAndDe.h"
#import "LMLoginViewController.h"
#import "LMRegisterViewController.h"

@interface LMPayCommitVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *orderInfoView;
@property (weak, nonatomic) IBOutlet UIView *payToolView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;//课程名
@property (weak, nonatomic) IBOutlet UILabel *singlePriceLabel;//单一课价
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;//总课价
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;//联系人
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;//手机号
@property (weak, nonatomic) IBOutlet UILabel *payTitle;//支付标题
@property (weak, nonatomic) IBOutlet UILabel *tuikuan;//退款
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation LMPayCommitVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

   
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"支付订单";
    
    self.orderInfoView.layer.cornerRadius = 5;
    self.orderInfoView.clipsToBounds = YES;
    
    self.payToolView.layer.cornerRadius = 5;
    self.payToolView.clipsToBounds = YES;
    
    self.allPriceLabel.textColor = UIColorFromRGB(0xc92900);
    self.payTitle.textColor = UIColorFromRGB(0x222222);
    self.tuikuan.textColor = UIColorFromRGB(0x76a600);
    
    //内容
    self.courseNameLabel.text = self.courseName;
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.count];
    self.singlePriceLabel.text = self.singlePrice;
    self.allPriceLabel.text = self.totalPrice;
    self.contactLabel.text = self.contact;
    self.phoneNumLabel.text  = self.phone;

}


- (IBAction)commitBtn:(id)sender {

    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    
#warning 需要更改
    //url
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"pay/courseOrder.json"];
    
    //参数
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"courseId"] = [NSString stringWithFormat:@"%li",self.productTypeId];
    arr[@"productId"] = [NSString stringWithFormat:@"%d",self.productId];
    arr[@"contactName"] = self.contact;
    arr[@"contactPhone"] = self.phone;
    arr[@"time"] = [NSString timeNow];
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sid"] = account.sid;
    parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
    
    //设备信息
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            MyLog(@"responseObject===============%@",responseObject);
            
            long long code = [responseObject[@"code"] longLongValue];
            
            NSString *collectStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
            
            NSDictionary *dict = [collectStr objectFromJSONString];
            
            MyLog(@"dict===%@",dict);
            
            //订单ID
            NSString *orderId = dict[@"orderId"];
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
        }];
    
        
        
    } else
    {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"]) {
            LMLoginViewController *lg = [[LMLoginViewController alloc] init];
            [self.navigationController pushViewController:lg animated:YES];
        }else
        {
            LMRegisterViewController *rv = [[LMRegisterViewController alloc] init];
            [self.navigationController pushViewController:rv animated:YES];
        }

        //    LMPaySuccessViewController *ps = [[LMPaySuccessViewController alloc] init];
        //    [self.navigationController pushViewController:ps animated:YES];
    }
    
}

@end
