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
#import "LMTestViewController.h"
#import "LMRegisterViewController.h"
#import "LMMyAwardVC.h"
#import "LMMyOrderVC.h"


@interface LMSettingViewController ()<UIAlertViewDelegate>

//nav背景颜色
@property (nonatomic, strong) UIImage *savedNavBarImage;
@property (strong, nonatomic) IBOutlet UIView *logBeforeView;
@property (strong, nonatomic) IBOutlet UIView *afterView;
@property (weak, nonatomic) IBOutlet UILabel *accountNum;

@end

@implementation LMSettingViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = titleView;
    UILabel *label = [[UILabel alloc] init];
    label.text  = @"我的";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, 100, 40);
    [titleView addSubview:label];
    
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    _savedNavBarImage = [navBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_nav@2x.png"] forBarMetrics:UIBarMetricsDefault];
    
    //判断用户是否登录
    LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    if (account) {
        self.tableView.tableHeaderView = self.afterView;
        self.accountNum.text = account.userPhone;
        self.afterView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 135, self.view.width, 0.5)];
        underLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
        [self.afterView addSubview:underLine];
        
        UIView *midLine = [[UIView alloc] initWithFrame:CGRectMake(160, 80, 0.5, 55)];
        midLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
        [self.afterView addSubview:midLine];
        
    }else
    {
        self.tableView.tableHeaderView = self.logBeforeView;
        
        self.logBeforeView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 135, self.view.width, 0.5)];
        underLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
        [self.logBeforeView addSubview:underLine];
        
        UIView *midLine = [[UIView alloc] initWithFrame:CGRectMake(160, 80, 0.5, 55)];
        midLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
        [self.logBeforeView addSubview:midLine];
    }
    
    
    /** 每次进来清空 */
    self.groups = nil;
    
    //初始化数据
    [self setupItems];
    
    [self.tableView reloadData];
    
    //重写返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"public_nav_black_white" target:self sel:@selector(goBack)];
    
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UINavigationController *navController = self.navigationController;
    //hack:ios5及之前版本在非动画方式pop时self.navigationController为nil,通过其他途径获取导航控制器
    if (!navController) {
        UIViewController *parentController = self.presentingViewController;
        if ([parentController isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController*)parentController;
        }
    }
    
    NSUInteger index = [navController.viewControllers indexOfObject:self];
    if (index == NSNotFound || index == self.navigationController.viewControllers.count-2) {//pop 或者push
        [navController.navigationBar setBackgroundImage:_savedNavBarImage forBarMetrics:UIBarMetricsDefault];
    }
    
}



- (void)setupItems
{
//    //设置第0组
//    [self setupGroup0];
    
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
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"])
        {
            accountInfo.destVc = [LMLoginViewController class];
        }else
        {
            accountInfo.destVc = [LMRegisterViewController class];
        }
        
    }
    
    LMCommonGroup *group0 = [self addGroup];
    group0.items = @[accountInfo];
    
}


//1组
- (void)setupGroup1
{
    //判断用户是否登录
    LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    
//    LMCommonItemArrow *myCollection = [LMCommonItemArrow itemWithIcon:@"me_collect" Title:@"我的收藏"];
//    if(account)
//    {
//        myCollection.destVc =[LMMyCollectionViewController class];
//    }else
//    {
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"])
//        {
//            myCollection.destVc = [LMLoginViewController class];
//        }else
//        {
//            myCollection.destVc = [LMRegisterViewController class];
//        }
//    }
//    
    
  
    

    
    LMCommonItemArrow *myReview = [LMCommonItemArrow itemWithIcon:@"me_review" Title:@"我的点评"];
    if(account)
    {
        myReview.destVc =[LMMyRecViewController class];
    }else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"])
        {
            myReview.destVc = [LMLoginViewController class];
        }else
        {
            myReview.destVc = [LMRegisterViewController class];
        }
        
    }
    
    
    LMCommonItemArrow *myOrder = [LMCommonItemArrow itemWithIcon:@"me_order" Title:@"我购买的课程"];
    if(account)
    {
        myOrder.destVc =[LMMyOrderVC class];
    }else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"])
        {
            myOrder.destVc = [LMLoginViewController class];
        }else
        {
            myOrder.destVc = [LMRegisterViewController class];
        }
        
    }
    
    LMCommonItemArrow *freeReserve = [LMCommonItemArrow itemWithIcon:@"me_listening" Title:@"免费预约试听"];
    if(account)
    {
        freeReserve.destVc =[LMMyReserveViewController class];
    }else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"])
        {
            freeReserve.destVc = [LMLoginViewController class];
        }else
        {
            freeReserve.destVc = [LMRegisterViewController class];
        }
        
    }
    
    LMCommonItemArrow *signActivity = [LMCommonItemArrow itemWithIcon:@"me_activity" Title:@"报名活动"];
    if(account)
    {
        signActivity.destVc =[LMMyActivityViewController class];
    }else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"])
        {
            signActivity.destVc = [LMLoginViewController class];
        }else
        {
            signActivity.destVc = [LMRegisterViewController class];
        }
    }
    
    
    LMCommonItemArrow *myAward = [LMCommonItemArrow itemWithIcon:@"me_gift" Title:@"我的奖品"];
    if(account)
    {
        myAward.destVc =[LMMyAwardVC class];
    }else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"])
        {
            myAward.destVc = [LMLoginViewController class];
        }else
        {
            myAward.destVc = [LMRegisterViewController class];
        }
        
    }
    
    
    LMCommonGroup *group1 = [self addGroup];
    group1.items = @[myOrder,freeReserve,signActivity,myAward];
    
}


//2组
- (void)setupGroup2
{
    //判断用户是否登录
    LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    
    LMCommonItemArrow *myCheck = [LMCommonItemArrow itemWithIcon:@"me_grade" Title:@"为我们打分"];
    myCheck.option = ^{
        
        
        NSString* m_appleID = LMAppID;    //此处的appID是在iTunes Connect创建应用程序时生成的Apple ID
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/app/id%@",m_appleID ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    };
    
    
    /** 暂时不做 */
    //    LMCommonItemArrow *appInfo = [LMCommonItemArrow itemWithIcon:@"me_app" Title:@"应用推荐"];
    //    appInfo.destVc = [LMAppRecommendViewController class];
    
    
    
    LMCommonItemArrow *versionUpdate = [LMCommonItemArrow itemWithIcon:@"me_update" Title:@"版本更新"];;
    versionUpdate.option = ^{
        
        [MBProgressHUD showMessage:@"检测中..."];
        
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
    
    
    
    LMCommonItemArrow *aboutUS = [LMCommonItemArrow itemWithIcon:@"me_about" Title:@"关于我们"];
    aboutUS.destVc = [LMAboutUsViewController class];
    
   
    
    LMCommonItemArrow *act = [LMCommonItemArrow itemWithIcon:@"me_about" Title:@"活动测试"];
    act.destVc = [LMTestViewController class];
    
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

#warning 以下以后可能要判断是否是第一次登录
- (IBAction)loginBtn:(id)sender {
    LMLoginViewController *lg = [[LMLoginViewController alloc] init];
    [self.navigationController pushViewController:lg animated:YES];
}

- (IBAction)myRecBtn:(id)sender {
    
    //判断用户是否登录
    LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    if (account) {
        LMMyRecViewController *myRec = [[LMMyRecViewController alloc] init];
        [self.navigationController pushViewController:myRec animated:YES];
    }else
    {
        LMLoginViewController *lg = [[LMLoginViewController alloc] init];
        [self.navigationController pushViewController:lg animated:YES];
    }
}

- (IBAction)myCollectBtn:(id)sender {
    
    //判断用户是否登录
    LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    if (account) {
        LMMyCollectionViewController *myCol = [[LMMyCollectionViewController alloc] init];
        [self.navigationController pushViewController:myCol animated:YES];
    }else
    {
        LMLoginViewController *lg = [[LMLoginViewController alloc] init];
        [self.navigationController pushViewController:lg animated:YES];
    }
}

- (IBAction)afterRec:(id)sender {
    LMMyRecViewController *myRec = [[LMMyRecViewController alloc] init];
    [self.navigationController pushViewController:myRec animated:YES];
}


- (IBAction)afterCollect:(id)sender {
    LMMyCollectionViewController *myCol = [[LMMyCollectionViewController alloc] init];
    [self.navigationController pushViewController:myCol animated:YES];
}

- (IBAction)afterAccount:(id)sender {
    LMMyAccountViewController *av = [[LMMyAccountViewController alloc] init];
    [self.navigationController pushViewController:av animated:YES];
}


@end
