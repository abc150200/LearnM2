//
//  LMAppDelegate.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define _IPHONE80_ 80000

#import "LMAppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "LMControllerTool.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "MTA.h"
#import "LMAccountTool.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AFNetworking.h"

#import "NSString+encrypto.h"

#import "GTMBase64.h"
#import "AESenAndDe.h"
#import "AESenAndDe.h"

#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

#import <CoreLocation/CoreLocation.h>

@interface LMAppDelegate ()<CLLocationManagerDelegate,CLLocationManagerDelegate>

/** 获得的sid */
@property (copy, nonatomic) NSString *sid;
@property (copy, nonatomic) NSString *salt;

@property(nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLLocationManager  *locationManager;

@end


@implementation LMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 1.创建wiondw
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //获取设备信息
    //获取沙盒中的版本号
    NSString *key = (__bridge_transfer NSString *)kCFBundleVersionKey;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [defaults objectForKey:key];
    
    //获得plist中的版本号
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = dict[key];
    if ([currentVersion compare:localVersion] == NSOrderedDescending) {
        //当前版本号比本地版本号高
        
        //存储当前系统版本号
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }
    
    UIDevice *device=[[UIDevice alloc] init];
    NSString *deviceName = device.name;//设备所有者的名称
    NSString *deviceModel = device.model;//设备的类别
    NSString *deviceLocalizedModel= device.localizedModel;//设备的的本地化版本
    NSString *devicesyStemVersion = device.systemVersion; //当前系统的版本
    NSString *deviceUUID = device.identifierForVendor.UUIDString;//设备识别码
    
    NSString *deviceAll = [NSString stringWithFormat:@"%@#%@#%@#%@#%@#%@",deviceName,deviceModel,deviceLocalizedModel,devicesyStemVersion,deviceUUID,currentVersion];
    [[NSUserDefaults standardUserDefaults] setObject:deviceAll forKey:@"deviceInfo"];
    [[NSUserDefaults standardUserDefaults] setObject:localVersion forKey:@"version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MyLog(@"deviceAll===%@",deviceAll);
    
    
    // 3.显示wiondw
    [self.window makeKeyAndVisible];
    
    
    
    
    
    [LMControllerTool chooseViewController];
    
    
    //判断是不是第一次运行
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    /** 读取账号 */
    LMAccount *account = [LMAccountTool account];
//   [LMAccountInfo sharedAccountInfo].account = account;
    
    /** 自动登录 */
    if (account && account.pwd) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"user/salt.json"];
        
        //参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = account.userPhone;
        
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LogObj(responseObject);
            
            self.salt = responseObject[@"salt"];
            self.sid = responseObject[@"sid"];
            
            /** 登录 */
            AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
            
            //url地址
            NSString *url2 = [NSString stringWithFormat:@"%@%@",RequestURL,@"user/login.json"];
            
            //参数
            NSMutableDictionary *parameters2 = [NSMutableDictionary dictionary];
            parameters2[@"mobile"] = account.userPhone;
            parameters2[@"sid"] = self.sid;
            
            NSMutableDictionary *arr = [NSMutableDictionary dictionary];
            
            arr[@"time"] = [NSString timeNow];
            NSString *pwdResult = [account.pwd stringByAppendingString:self.salt];
            arr[@"password"] = [pwdResult sha1];
            
            
            NSString *jsonStr = [arr JSONString];
            MyLog(@"%@",jsonStr);
            
            //通讯密钥
            NSString *result = [account.pwd stringByAppendingString:self.salt];
            MyLog(@"%@==拼接之后",result);
            //        NSString *key = [[self getSha1String:result]  substringToIndex:16];
            NSString *key = [[[result sha1]  substringToIndex:16] lowercaseString];
            MyLog(@"%@==全部密钥",[[result sha1] lowercaseString] );
            MyLog(@"%@==密钥",key);
            
            
            //        parameters2[@"data"] = [AESCrypt encrypt:jsonStr password:key];
            parameters2[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:key];
            
            MyLog(@"%@===请求参数",parameters2);
            
            [manager2 POST:url2 parameters:parameters2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                LogObj(responseObject);
                
                NSString *dataStr = responseObject[@"data"];
                
                NSString *dataJson = [AESenAndDe De_Base64andAESDeToString:dataStr keyValue:key];
                NSDictionary *dict = [dataJson objectFromJSONString];
                
                LogObj(dict);
                
                MyLog(@"name===%@",responseObject);
                
                
                NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
                dictM[@"userPhone"] = account.userPhone;
                dictM[@"pwd"] = account.pwd;
                
                MyLog(@"name===%@",dictM);
                
                
                //字典转对象
                LMAccount *account  = [LMAccount accountWithDict:dictM];
                [LMAccountTool saveAccount:account];
                
              
                [[LMAccountInfo sharedAccountInfo] setAccount:account];
                LogObj([LMAccountInfo sharedAccountInfo].account);
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LogObj(error.localizedDescription);
                
            }];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
            
        }];
        

    }
    
    
    //定位
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 500.0f;
    
    if (iOS8) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];

    
    
    //云分析
    [MTA startWithAppkey:@"IN8FWR1U74WS"];
    
    
    
    // 注册友盟的appKey
    [UMSocialData setAppKey:UMAppKey];
    
#warning appKey要改,url也要改(plist),这下面也要改(sina)
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    
    [UMSocialWechatHandler setWXAppId:@"wx328a2bd54f56402e" appSecret:@"747fc1d271da52c510f05779a5c72c13" url:@"http://www.learnmore.com.cn/"];
    
    /** qq空间 */
    [UMSocialQQHandler setQQWithAppId:@"1103416062" appKey:@"GHLaR9rGAtMDqLMm" url:@"http://www.learnmore.com.cn/"];
    [UMSocialQQHandler setSupportWebView:YES];

    self.window.backgroundColor = [UIColor whiteColor];
    

    
    
   [XGPush startApp:2200063367 appKey:@"I16I24SLIT1F"];
   
    
    
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
     [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];

    
    //首次打开app统计
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"commons/open.json"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(currentVersion)
    {
        parameters[@"version"] = currentVersion;
    }
    parameters[@"device"] = deviceAll;
  
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        MyLog(@"responseObject===%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
    
    
    
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
     NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
     [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    
     MyLog(@"deviceTokenStr is %@",deviceTokenStr);
    
    
    // Required
//    [APService registerDeviceToken:deviceToken];
}


//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    
    
    // Required
//    [APService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (void)registerPush
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

#pragma mark -实现CLLocationManagerDelegate的代理方法

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    NSLog(@" 纬度=%f 经度=%f ", currLocation.coordinate.latitude, currLocation.coordinate.longitude);
    NSString *localGps = [NSString stringWithFormat:@"%@,%@",@(currLocation.coordinate.latitude),@(currLocation.coordinate.longitude)];
    
    //存起来
    [[NSUserDefaults standardUserDefaults] setObject:localGps forKey:@"localGps"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    
}

#pragma mark 获取用户位置数据失败的回调方法，在此通知用户
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        MyLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        MyLog(@"无法获取位置信息");
    }
}


@end
