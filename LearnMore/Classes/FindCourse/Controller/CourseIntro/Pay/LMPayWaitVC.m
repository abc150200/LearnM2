//
//  LMPayWaitVC.m
//  LearnMore
//
//  Created by study on 15-1-21.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMPayWaitVC.h"
#import "LMCourseIntroViewController.h"
#import "LMMyOrderDetailVC.h"


@interface LMPayWaitVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@end

@implementation LMPayWaitVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //重写返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"public_nav_black" target:self sel:@selector(goBack)];
    
}

- (void)goBack
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LMCourseIntroViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买成功";
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds = YES;
    
    
    self.courseNameLabel.text = self.courseName;
    self.contactLabel.text = self.contact;
    self.phoneLabel.text = self.phone;
    
}

- (IBAction)commit:(id)sender {
    
    LMMyOrderDetailVC *od = [[LMMyOrderDetailVC alloc] init];
    od.orderId = self.orderId;
    [self.navigationController pushViewController:od animated:YES];
    
}


@end
