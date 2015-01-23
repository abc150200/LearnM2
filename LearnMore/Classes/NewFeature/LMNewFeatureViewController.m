//
//  LMNewFeatureViewController.m
//  LearnMore
//
//  Created by study on 14-11-17.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMNewFeatureImageCount  3

#import "LMNewFeatureViewController.h"
#import "MJTabBarController.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "MTA.h"

@interface LMNewFeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation LMNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.添加scrollerview
    [self setupScrollerView];
    
    // 2.添加pageControl
    [self setupPageControl];
    
}

/**
 *  添加scrollerview
 */
- (void)setupScrollerView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    scrollView.delegate = self;
    
    CGFloat width = scrollView.width;
    CGFloat height = scrollView.height;
    
    for (int i = 0; i < LMNewFeatureImageCount; i++) {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.width = self.view.width;
        iv.height = self.view.height;
        iv.y = 0;
        iv.x = i * width;
        
        NSString *name = [NSString stringWithFormat:@"intro%d",i + 1];
        
        //设置UIImageView的image
        iv.image = [UIImage imageNamed:name];
        
        [scrollView addSubview:iv];
        
        if (i == (LMNewFeatureImageCount -1)) {
            // 设置imageview可以和用户交互
            iv.userInteractionEnabled = YES;
            
            // 2.添加开始按钮
            [self setupStartBtn:iv];
        }
   
    }
    
     // 设置scrollerView其它属性
    
    scrollView.contentSize = CGSizeMake(LMNewFeatureImageCount * width, height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    
}

/**
 *  添加开始按钮
 */
- (void)setupStartBtn:(UIImageView *)imageView
{
    // 1.创建按钮
    UIButton *startBtn = [[UIButton alloc] init];
    startBtn.backgroundColor = [UIColor clearColor];
    
    //按钮frame
    startBtn.size = CGSizeMake(150, 100);
    startBtn.centerX = self.view.width * 0.5;
    startBtn.centerY = self.view.height * 0.5;
    
    // 监听开始按钮点击事件
    [startBtn addTarget:self action:@selector(startBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 4.添加按钮到imageView
    [imageView addSubview:startBtn];
}

/**
 *   监听开始按钮点击
 */
- (void)startBtnOnClick
{
    
    //#import "MTA.h"
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];

    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    NSDictionary *dict = nil;
    if (account) {
        NSString *userPhone = account.userPhone;
        dict = @{@"phone":userPhone,@"device":deviceInfo};
    }else
    {
        dict = @{@"device":deviceInfo};
    }
    
    [MTA trackCustomKeyValueEvent:@"event_guiding_start" props:dict];
    
    
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarHidden = NO;
    
    // 跳转到首页
    // 1.创建首页控制器
    MJTabBarController *tabBarVc = [[MJTabBarController alloc] init];
    
    // 2.切换控制器
    app.keyWindow.rootViewController = tabBarVc;
}


/**
 *  添加pageControl
 */
- (void)setupPageControl 
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = LMNewFeatureImageCount;
    
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    pageControl.centerX = self.view.width * 0.5;
    pageControl.y = self.view.height - 30;
    
    // 4.设置页码的颜色
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    // 1.计算页码
    double ratio = scrollView.contentOffset.x / self.view.width;
    int page = (int)(ratio + 0.5);
    // 2.设置页码
    self.pageControl.currentPage = page;
}


@end
