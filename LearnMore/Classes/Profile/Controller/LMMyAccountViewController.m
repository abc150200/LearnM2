//
//  LMMyAccountViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMAccountDocPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#import "LMMyAccountViewController.h"
#import "LMchangePwdViewController.h"
#import "LMLoginViewController.h"
#import "LMAccount.h"
#import "LMAccountInfo.h"


@interface LMMyAccountViewController ()

@end

@implementation LMMyAccountViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
}


-  (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"我的账号";
    
    self.groups = nil;
    
    //初始化数据
    [self setupItems];
    
    //设置退出登录按钮
    [self setupFooterView];

}

- (void)setupItems
{
    //设置第0组
    [self setupGroup0];
}

- (void)setupGroup0
{
    LMCommonItemLabel *accountInfo = [LMCommonItemLabel itemWithTitle:@"账号信息"];
    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    if (account) {
        accountInfo.text = account.userPhone;
    }

    
//    LMCommonItemArrow *changePwd = [LMCommonItemArrow itemWithTitle:@"修改密码"];
//    changePwd.destVc = [LMchangePwdViewController class];
  
    LMCommonGroup *group0 = [self addGroup];
    group0.items = @[accountInfo];
}


- (void)setupFooterView
{

    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(15, 400, 290, 40);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    

    [btn addTarget:self action:@selector(logoutBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
  
}


- (void)logoutBtn
{
    [LMAccountInfo sharedAccountInfo].account = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:LMAccountDocPath error:nil];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
