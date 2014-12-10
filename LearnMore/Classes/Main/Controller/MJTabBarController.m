//
//  MJTabBarController.m
//  00-ItcastLottery
//
//  Created by apple on 14-4-14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJTabBarController.h"
#import "MJTabBar.h"
#import "MJTabBarButton.h"
#import "LMFindCourseViewController.h"
#import "LMActivityViewController.h"
#import "LMSettingViewController.h"
#import "MJNavigationController.h"


@interface MJTabBarController () <MJTabBarDelegate,UINavigationControllerDelegate>


@end

@implementation MJTabBarController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        MJNavigationController *nav1 = [[MJNavigationController alloc] init];
        LMFindCourseViewController *fv = [[LMFindCourseViewController alloc] init];
        [nav1 addChildViewController:fv];
        [self addChildViewController:nav1];
        
        
        MJNavigationController *nav2 = [[MJNavigationController alloc] init];
        LMActivityViewController *av = [[LMActivityViewController alloc] init];
        [nav2 addChildViewController:av];
        [self addChildViewController:nav2];
        
        
        MJNavigationController *nav3 = [[MJNavigationController alloc] init];
        LMSettingViewController *sv = [[LMSettingViewController alloc] init];
        [nav3 addChildViewController:sv];
        [self addChildViewController:nav3];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.添加自己的tabbar
    MJTabBar *myTabBar = [[MJTabBar alloc] init];
    myTabBar.backgroundColor = UIColorFromRGB(0xfcfcfc);
    myTabBar.delegate = self;
    myTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:myTabBar];
    LogFrame(self.tabBar);
    
    // 2.添加对应个数的按钮
    [myTabBar addTabButtonWithName:@"public_tabbar_search_normal" selName:@"public_tabbar_search_pressed" title:@"精彩课程"];
    
    [myTabBar addTabButtonWithName:@"public_tabbar_activity_normal" selName:@"public_tabbar_activity_pressed" title:@"亲子活动"];
    
    [myTabBar addTabButtonWithName:@"public_tabbar_me_normal" selName:@"public_tabbar_me_pressed" title:@"我的"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *subView in self.tabBar.subviews) {
        if ([subView isKindOfClass:[UIControl class]]) {
            [subView removeFromSuperview];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (UIView *subView in self.tabBar.subviews) {
        if ([subView isKindOfClass:[UIControl class]]) {
            [subView removeFromSuperview];
        }
    }
}


#pragma mark - MJTabBar的代理方法
- (void)tabBar:(MJTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to
{
    // 选中最新的控制器
    self.selectedIndex = to;
}
@end