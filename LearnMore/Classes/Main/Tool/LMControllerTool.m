//
//  LMControllerTool.m
//  LearnMore
//
//  Created by study on 14-11-17.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMControllerTool.h"
//#import "MJTabBarController.h"
#import "LMNewFeatureViewController.h"
#import "LMFindCourseViewController.h"
#import "MJBlueNavigationController.h"
#import "MJNavigationController.h"

@implementation LMControllerTool
+ (void)chooseViewController
{
    //判断是否是第一次使用
    //获取沙盒中的版本号
    NSString *key = (__bridge_transfer NSString *)kCFBundleVersionKey;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [defaults objectForKey:key];
    
    //获得plist中的版本号
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = dict[key];
    
    MyLog(@"本地%@----系统%@",localVersion,currentVersion);
    
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    if ([currentVersion compare:localVersion] == NSOrderedDescending) {
        //当前版本号比本地版本号高
        
        //存储当前系统版本号
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        
        LMNewFeatureViewController  *nv = [[LMNewFeatureViewController alloc] init];
        window.rootViewController = nv;
 
    }else
    {
        // 2.1创建根控制器
        // 显示TabBarController
        MJNavigationController *nav = [[MJNavigationController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] init];
        LMFindCourseViewController  *fVc = [[LMFindCourseViewController alloc] init];
        [nav addChildViewController:fVc];
        window.rootViewController = nav;
    }
}
@end
