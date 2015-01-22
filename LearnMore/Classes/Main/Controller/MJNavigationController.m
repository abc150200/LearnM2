//
//  MJNavigationController.m
//  00-ItcastLottery
//
//  Created by apple on 14-4-14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJNavigationController.h"

@interface MJNavigationController ()

@end

@implementation MJNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

/**
 *  系统在第一次使用这个类的时候调用(1个类只会调用一次)
 */
+ (void)initialize
{
    
    // 1.设置导航条的主题
    [self setupNavTheme];
    
    // 2.设置导航条按钮的主题
    [self setupItemTheme];
    
}

/**
 *设置导航条按钮的主题
 */
+ (void)setupItemTheme
{
    // 2.1设置默认状态的按钮颜色
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemMd = [NSMutableDictionary dictionary];
    // 设置字体的颜色
    itemMd[NSForegroundColorAttributeName] = UIColorFromRGB(0x9ac72c);
    // 设置字体的大小
    itemMd[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    // 去掉阴影
//    itemMd[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [item setTitleTextAttributes:itemMd forState:UIControlStateNormal];

   
}

/**
 *设置导航条的主题
 */
+ (void)setupNavTheme
{
    // 1.设置导航栏主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    navBar.tintColor = UIColorFromRGB(0x9ac72c);
    
    [navBar setBackgroundImage:[UIImage resizableImageWithName:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    // 1.1.3设置标题颜色
    NSMutableDictionary *titleMd = [NSMutableDictionary dictionary];
    // 设置字体颜色
    titleMd[NSForegroundColorAttributeName] = UIColorFromRGB(0x333333);
    // 去掉阴影
//    titleMd[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    // 设置字体大小
    titleMd[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [navBar setTitleTextAttributes:titleMd];
    
}


/**
 *  重写这个方法,能拦截所有的push操作
 *
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    MyLog(@"%lu ==== 控制器个数",(unsigned long)self.childViewControllers.count);
    if(self.childViewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"public_nav_black" target:self sel:@selector(back)];
        
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    // 移除栈顶控制器
    [self popViewControllerAnimated:YES];
}



@end
