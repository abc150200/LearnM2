//
//  LMListenActivityViewController.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMTableHeight ([UIScreen mainScreen].bounds.size.height - 64 - 10 - self.segm.height - 49)

#import "LMActivityViewController.h"
//#import "LMActivityViewCell.h"
//#import "LMActivityDetailViewController.h"
//#import "AFNetworking.h"
//#import "LMActList.h"
//#import "MJRefresh.h"
#import "LMActivityListViewController.h"


@interface LMActivityViewController ()
//@property (nonatomic, strong) NSMutableArray *actLists;

@property (nonatomic, weak) UISegmentedControl *segm;
@property (nonatomic, weak) LMActivityListViewController *clv;

@end

@implementation LMActivityViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"亲子活动";
    
    
    //创建课程切换标签
    NSArray *btnName = @[@"最新",@"热门",@"附近"];
    
    UISegmentedControl *segm = [[UISegmentedControl alloc] initWithItems:btnName];
    self.segm = segm;
    segm.tintColor= UIColorFromRGB(0x9ac72c);
    
    segm.frame = CGRectMake(10, 69, self.view.width - 20, 35);
    [segm setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    segm.selectedSegmentIndex = 0;
    [self.view addSubview:segm];
    //添加事件
    [segm addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self segmentAction:self.segm];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    MyLog(@"Seg.selectedSegmentIndex:%d",Index);
    
    if (Index == 0){
        
        //创建tableView
        LMActivityListViewController *clv = [[LMActivityListViewController alloc] init];

        clv.view.frame = CGRectMake(0, CGRectGetMaxY(self.segm.frame) + 5, self.view.width, LMTableHeight);
        
        self.clv = clv;
        [self addChildViewController:clv];
        [self.view addSubview:self.clv.view];
        [self loadParam];
        
    } else if (Index == 1)
    {
        [self loadParam];
    }else
    {
        [self loadParam];
    }
    
}

/** 参数 */
- (void)loadParam
{
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"area"] = @"0_0";
    arr[@"count"] = @"5";
    
    NSString *gpsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"localGps"];
    if (gpsStr) {
        arr[@"gps"] = gpsStr;
    }
    
    self.clv.arr = arr;
    
    if (self.segm.selectedSegmentIndex == 0) {
        
        arr[@"order"] = @"1";
        self.clv.arr = arr;
        [self.clv setupRefresh];
    } else if ((self.segm.selectedSegmentIndex == 1))
    {
        arr[@"order"] = @"2";
        self.clv.arr = arr;
        [self.clv setupRefresh];
    }else
    {
        arr[@"order"] = @"3";
        self.clv.arr = arr;
        [self.clv setupRefresh];
    }
}

@end
