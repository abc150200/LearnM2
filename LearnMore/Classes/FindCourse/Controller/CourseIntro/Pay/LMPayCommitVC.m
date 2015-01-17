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
#import "MBProgressHUD+NJ.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"

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
@property (copy, nonatomic) NSString *orderId;//产品ID

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
    self.singlePriceLabel.text = [NSString stringWithFormat:@"%d元",self.singlePrice];
    self.allPriceLabel.text = [NSString stringWithFormat:@"%d元",self.totalPrice];
    self.contactLabel.text = self.contact;
    self.phoneNumLabel.text  = self.phone;
    
    
//    [[NSUserDefaults standardUserDefaults] setObject:self.contact forKey:@"contact"];
//    [[NSUserDefaults standardUserDefaults] setObject:self.phone forKey:@"phone"];
//    [[NSUserDefaults standardUserDefaults] setObject:self.courseName forKey:@"courseName"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appPayResultWithDic:) name:@"payResultNotification" object:nil];
    
}

- (void)appPayResultWithDic:(NSNotification *)notifi
{
    NSDictionary *userInfo = notifi.userInfo;
    [self payResultWithDic:userInfo];
}


- (IBAction)commitBtn:(id)sender {

    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
    [MBProgressHUD showMessage:@"正在支付,请稍等..."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    
#warning 需要更改
    //url
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"pay/courseOrder.json"];
    
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
            
            NSString *collectStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
            
            NSDictionary *dict = [collectStr objectFromJSONString];
            
            MyLog(@"dict===%@",dict);
            
            //订单ID
            NSString *orderId = dict[@"orderId"];
            self.orderId = orderId;
            
            //支付宝
            [self alixPayWithOrderId:self.orderId];
    
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

        
    }
    
}


//alixPay
-(void)alixPayWithOrderId:(NSString *)orderId
{
    
    //获取ID
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    
    // 1.创建订单模型
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner; // 商户ID
    order.seller = seller; // 账号ID
    order.tradeNO = orderId; // 订单号 (一般跟时间有关)
//    order.amount = [NSString stringWithFormat:@"%d",self.totalPrice]; // 金额
     order.amount = @"0.01"; // 金额
    order.productName = self.courseName; // 商品名称
    order.productDescription = @"多学课程"; // 商品描述
    
    order.notifyURL =  @"http://api.learnmore.com.cn/back/backUrl.json"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle]
                                                 objectForInfoDictionaryKey:@"RSA private key"]);
    NSString *signedString = [signer signString:orderSpec];

    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [MBProgressHUD hideHUD];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            [self payResultWithDic:resultDic];
    
        }];
        
    }
}


- (void)payResultWithDic:(NSDictionary *)resultDic
{
    
    if([resultDic[@"resultStatus"] isEqualToString:@"9000"])
    {
        LMPaySuccessViewController *ps = [[LMPaySuccessViewController alloc] init];
        ps.courseName = self.courseName;
        ps.phone = self.phone;
        ps.contact =  self.contact;
        [self.navigationController pushViewController:ps animated:YES];
    }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
    {
        [MBProgressHUD showError:@"支付失败,请到我的订单中查看"];
    }else
    {
        [MBProgressHUD showError:@"服务器异常,请稍后再试!"];
  
    }
}




@end
