//
//  LMSettingViewController.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMSettingViewController.h"
#import "LMCommonItemArrow.h"
#import "LMCommonItemLabel.h"
#import "LMCommonGroup.h"
#import "LMCommonCell.h"
#import "LMMyAccountViewController.h"
#import "LMAppRecommendViewController.h"
#import "MBProgressHUD+NJ.h"
#import "LMLoginViewController.h"
#import "LMMyCollectionViewController.h"
#import "LMAboutUsViewController.h"
#import "LMMyReserveViewController.h"
#import "LMMyActivityViewController.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "LMMyRecViewController.h"

@interface LMSettingViewController ()<UIAlertViewDelegate>

@end

@implementation LMSettingViewController


- (void)viewDidLoad
{

    [super viewDidLoad];
    
    self.title = @"我的";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /** 每次进来清空 */
    self.groups = nil;
    
    //初始化数据
    [self setupItems];

    [self.tableView reloadData];
    
    
}


- (void)setupItems
{
    //设置第0组
    [self setupGroup0];
    
    //设置第1组
    [self setupGroup1];
    
    //设置第2组
    [self setupGroup2];
}

//0组
- (void)setupGroup0
{
    LMCommonItemArrow *accountInfo = [LMCommonItemArrow itemWithIcon:@"me_account" Title:@"账号信息"];
    
//判断用户是否登录
     LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    if(account)
    {
        accountInfo.subtitle = account.userPhone;
        MyLog(@"%@=====账号==",account.userPhone);
        
        accountInfo.destVc = [LMMyAccountViewController class];
    }else
    {
        accountInfo.subtitle = @"未登录";
        accountInfo.destVc = [LMLoginViewController class];
    }
    


    LMCommonGroup *group0 = [self addGroup];
    group0.items = @[accountInfo];
    
}


//1组
- (void)setupGroup1
{
    //判断用户是否登录
    LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    
    LMCommonItemArrow *myCollection = [LMCommonItemArrow itemWithIcon:@"me_collect" Title:@"我的收藏"];
//    myCollection.subtitle = @"12门课程";
//    if(account)
//    {
//        myCollection.destVc =[LMMyCollectionViewController class];
//    }else
//    {
//        myCollection.destVc = [LMLoginViewController class];
//    }
//    
    
    LMCommonItemArrow *freeReserve = [LMCommonItemArrow itemWithIcon:@"me_listening" Title:@"免费预约试听"];
//    freeReserve.subtitle = @"12个预约";
    if(account)
    {
        freeReserve.destVc =[LMMyReserveViewController class];
    }else
    {
        freeReserve.destVc = [LMLoginViewController class];
    }
    
    
    LMCommonItemArrow *signActivity = [LMCommonItemArrow itemWithIcon:@"me_activity" Title:@"报名活动"];
//    signActivity.subtitle = @"12个活动";
    if(account)
    {
        signActivity.destVc =[LMMyActivityViewController class];
    }else
    {
        signActivity.destVc = [LMLoginViewController class];
    }
    
    
    LMCommonItemArrow *myReview = [LMCommonItemArrow itemWithIcon:@"me_review" Title:@"我的点评"];
    if(account)
    {
        myReview.destVc =[LMMyRecViewController class];
    }else
    {
        myReview.destVc = [LMLoginViewController class];
    }
    
#warning 点评增加入口
    LMCommonGroup *group1 = [self addGroup];
    group1.items = @[freeReserve,signActivity];
  
}


//2组
- (void)setupGroup2
{
    LMCommonItemArrow *myCheck = [LMCommonItemArrow itemWithIcon:@"me_grade" Title:@"为我们打分"];
    myCheck.option = ^{
        

         NSString* m_appleID = LMAppID;    //tinyray 此处的appID是在iTunes Connect创建应用程序时生成的Apple ID
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/app/id%@",m_appleID ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
   
    };
    
    
    /** 暂时不做 */
//    LMCommonItemArrow *appInfo = [LMCommonItemArrow itemWithIcon:@"me_app" Title:@"应用推荐"];
//    appInfo.destVc = [LMAppRecommendViewController class];
    
  
    
    LMCommonItemArrow *versionUpdate = [LMCommonItemArrow itemWithIcon:@"me_update" Title:@"版本更新"];;
    versionUpdate.option = ^{
        
        [MBProgressHUD showMessage:@"检测中...,"];
        
        //获取沙盒中的版本号
        NSString *key = (__bridge_transfer NSString *)kCFBundleVersionKey;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *localVersion = [defaults objectForKey:key];
        
        MyLog(@"localVersion===%@",localVersion);
        
        NSString *url = @"http://itunes.apple.com/lookup?id=941536677";
        NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        
       [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           
            NSArray *result = dic[@"results"];
            
            [MBProgressHUD hideHUD];
            
            if (result.count) {
                
                NSDictionary *dic2= result[0];
                NSString *latestVersion = [dic2 objectForKey:@"version"];//应用商店当前版本
                MyLog(@"version===%@",latestVersion);
                NSString *trackViewUrl = [dic2 objectForKey:@"trackViewUrl"];
                MyLog(@"trackViewUrl===%@",trackViewUrl);
                
                if ([latestVersion compare:localVersion] == NSOrderedDescending) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新", nil];
                    alert.tag = 10000;
                    [alert show];
                    
                }else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"已经是最新版本了!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 10001;
                    [alert show];
                    
                }
                
            }
           
       }];
        
        };
        
            
 
//    if ([currentVersion compare:localVersion] == NSOrderedDescending) {
//        //当前版本号比本地版本号高
//        
//        //存储当前系统版本号
//        [defaults setObject:currentVersion forKey:key];
//        [defaults synchronize];
//        
//        versionUpdate = [LMCommonItemArrow itemWithIcon:@"me_update" Title:@"版本更新"];
//        versionUpdate.subtitle = @"发现新版本";
//        versionUpdate.option = ^{
//            [MBProgressHUD showSuccess:@"有新版本"];
//        };
//    }
//    else
//    {
//#warning 这里判断之后,箭头如何去掉
//        versionUpdate = [LMCommonItemArrow itemWithIcon:@"me_update" Title:@"版本更新"];
//        versionUpdate.subtitle = @"已是最新版";
//        versionUpdate.option = ^{
//            [MBProgressHUD showError:@"已是最新版"];
//        };
//    }
    
    
    LMCommonItemArrow *aboutUS = [LMCommonItemArrow itemWithIcon:@"me_about" Title:@"关于我们"];
    aboutUS.destVc = [LMAboutUsViewController class];
    
    LMCommonGroup *group2 = [self addGroup];
    group2.items = @[myCheck,versionUpdate,aboutUS];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            NSString* m_appleID = LMAppID;    //tinyray 此处的appID是在iTunes Connect创建应用程序时生成的Apple ID
            NSString *str = [NSString stringWithFormat:
                             @"itms-apps://itunes.apple.com/app/id%@",m_appleID ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}



@end
