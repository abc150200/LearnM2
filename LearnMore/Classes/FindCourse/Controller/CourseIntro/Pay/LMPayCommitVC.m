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
//    LMActBookVC *av = [[LMActBookVC alloc] init];
//    [self.navigationController pushViewController:av animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    
#warning 需要更改
    //url
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"course/info.json"];
    
    //参数
    
    
    
    
    
    
    
    LMPaySuccessViewController *ps = [[LMPaySuccessViewController alloc] init];
    [self.navigationController pushViewController:ps animated:YES];
    
}

@end
