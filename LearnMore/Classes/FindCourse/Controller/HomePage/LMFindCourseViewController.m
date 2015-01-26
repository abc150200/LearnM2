//
//  LMViewController.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define NavH (([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)? 64 : 64)

#define LMAdsDocPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ads.plist"]

#define LMAreasPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"smallAreas.plist"]

#define AdScrollViewH 136

#import "LMFindCourseViewController.h"
#import "IWSearchBar.h"
#import "IWCityButton.h"
#import "CityListViewController.h"
#import "LMCourseCollectionViewController.h"
#import "LMCourseListMainViewController.h"
#import "LMSearchViewController.h"
#import "AFNetworking.h"
#import "LMCourseType.h"
#import "MBProgressHUD+NJ.h"
#import "LMAdverce.h"
#import "LMActivityDetailViewController.h"
#import "LMCourseList.h"
#import "LMCourseRecommendViewController.h"
#import "LMCourseIntroViewController.h"
#import "LMTeacherIntroViewController.h"
#import "LMSchoolIntroViewController.h"
#import "LMAdOtherViewController.h"
#import "LMLoginViewController.h"
#import "LMRegisterViewController.h"

#import "CLProgressHUD.h"
#import "DejalActivityView.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "MTA.h"
#import "MJBlueNavigationController.h"
#import "LMSettingViewController.h"



@interface LMFindCourseViewController ()<CityListViewControllerDelegate,LMCourseCollectionViewControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,LMCourseRecommendViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) IWCityButton *cityButton;

@property (nonatomic, strong) CityListViewController *ctv;

@property (nonatomic, strong) LMCourseCollectionViewController *cv;

@property (nonatomic, strong)   UIImageView *searchBar;

@property (nonatomic, strong) UIScrollView *conScrollView;

/** 广告 */
@property (nonatomic, weak) UIScrollView  *adScrollView;
/** 类型数组 */
@property (nonatomic, strong) NSArray *typrArr;
/** 广告数组 */
@property (nonatomic, strong) NSArray *adArr;

@property (nonatomic, weak) UIPageControl *pageControl;

//定时器
@property (nonatomic, strong) NSTimer *timer;

//推荐数组
@property (nonatomic, strong) NSArray *recommendCourseLists;

@property (nonatomic, strong) LMCourseRecommendViewController *cr;

//广告路径
@property (nonatomic, copy) NSString *adsPath;


@property (nonatomic, copy) NSString *gps;

//引导页
@property (nonatomic, weak) UIButton *alertViewBtn;
@property (nonatomic, weak) UIView *alertView;

@property (nonatomic, strong) UIView *failView;

//nav背景颜色
@property (nonatomic, strong) UIImage *savedNavBarImage;

//colloctionView下边线
@property (nonatomic, weak) UIView *space;
@property (nonatomic, weak) UIView *selectView;
@property (nonatomic, weak) UIView *otherView;
@property (nonatomic, weak) UIView *viewAll;


@end

@implementation LMFindCourseViewController

- (void)viewDidLoad
{
   
    
    [super viewDidLoad];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    _savedNavBarImage = [navBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    MyLog(@"%@=====",identifier);

    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.width - 20,44)];
    navView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = navView;
    
    MyLog(@"navView.frame===%@",NSStringFromCGRect(navView.frame));
    

    
    //创建城市按钮
    IWCityButton *cityButton = [[IWCityButton alloc] init];
    cityButton.frame = CGRectMake(10, 0, 65, 44);
    // 设置标题
    [cityButton setTitle:@"北京" forState:UIControlStateNormal];
    [cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [cityButton setImage:[UIImage imageNamed:@"btn_home_arrow"] forState:UIControlStateNormal];
    [navView addSubview:cityButton];
    self.cityButton = cityButton;
    // 2.1监听标题按钮的点击事件
    [cityButton addTarget:self action:@selector(titleBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
 
    

    //覆盖一个透明的按钮
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(navView.width - 2 *(44 + 10) + 10, 0, 44, 44)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    [navView addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    MyLog(@"searchBtn===%@",NSStringFromCGRect(searchBtn.frame));
    
    //覆盖一个透明的按钮
    UIButton *meBtn = [[UIButton alloc] initWithFrame:CGRectMake(navView.width - (44 + 10)+ 10, 0, 44, 44)];
    [meBtn setBackgroundImage:[UIImage imageNamed:@"home_me"] forState:UIControlStateNormal];
    [navView addSubview:meBtn];
    [meBtn addTarget:self action:@selector(meBtnClick) forControlEvents:UIControlEventTouchUpInside];
    MyLog(@"meBtn===%@",NSStringFromCGRect(meBtn.frame));
    
    //创建内容scrollView
    UIScrollView *conScrollView  = [[UIScrollView alloc] init];
    conScrollView.tag = 1001;
    conScrollView.delegate =self;
    conScrollView.x = 0;
    conScrollView.y = 0;
    conScrollView.width = self.view.width;
    conScrollView.height = self.view.height;
    [self.view addSubview:conScrollView];
    self.conScrollView = conScrollView;
//    conScrollView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    //创建广告adScrollView
    UIScrollView *adScrollView  = [[UIScrollView alloc] init];
    adScrollView.tag = 1002;
    adScrollView.delegate = self;
    adScrollView.x = 0;
    adScrollView.size = CGSizeMake(self.view.width, AdScrollViewH );
    adScrollView.y = 0;

    [conScrollView addSubview:adScrollView];
    self.adScrollView = adScrollView;
    
    [self setupAdScrollView];
    

    [self addTimer];
    
    
    //创建九宫格
    LMCourseCollectionViewController *cv = [[LMCourseCollectionViewController alloc] init];
    cv.delegate = self;
    cv.collectionView.backgroundColor = [UIColor whiteColor];

    cv.collectionView.frame = CGRectMake(0, self.adScrollView.height, self.view.width, 150);
    
    [self.conScrollView addSubview:cv.collectionView];

	self.cv = cv;
    
    //间隔条
    UIView *space = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cv.collectionView.frame), self.view.width, 11)];
    self.space = space;
    [self.conScrollView addSubview:space];
    space.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
    [self.space addSubview:upLine];
    upLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, space.height - 0.5, self.view.width, 0.5)];
    [self.space addSubview:downLine];
    downLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
    
#warning 暂时隐藏
    //智能选课
//    //View
//    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cv.collectionView.frame), self.view.width, 85)];
//    selectView.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    [self.conScrollView addSubview:selectView];
//    
//    //上边线
//    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
//    [selectView addSubview:upLine];
//    upLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
//    
//    //下边线
//    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0,  selectView.height - 0.5, self.view.width, 0.5)];
//    [selectView addSubview:downLine];
//    downLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
//    
//    //中间图
//    UIImageView *midIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10.5, self.view.width, 64)];
//    midIv.image = [UIImage imageNamed:@"home_banner"];
//    [selectView addSubview:midIv];
//    
//    //按钮
//    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 44 - 13, 10.5 + 10, 44, 44)];
//    [goBtn setBackgroundImage:[UIImage imageNamed:@"btn_home_banner"] forState:UIControlStateNormal];
//    [goBtn addTarget:self action:@selector(btnMoreClick) forControlEvents:UIControlEventTouchUpInside];
//    [selectView addSubview: goBtn];
    

    
    //其他孩子都在学
  
    UIView *otherView= [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(space.frame), self.view.width, 44)];
    self.otherView = otherView;
    [self.conScrollView addSubview:otherView];
    
    UIImageView *fontIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14.5, 3, 15)];
    fontIv.image = [UIImage imageNamed:@"home_study"];
    [otherView addSubview:fontIv];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20 + 3, 15, 200, 14)];
    label1.text = @"别人家的孩子都在学";
    label1.textColor = [UIColor darkGrayColor];
    label1.font = [UIFont systemFontOfSize:14];
    [otherView addSubview:label1];
    
//    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(10,otherView.height - 0.5, self.view.width - 10,  0.5)];
//    [otherView addSubview:underLine];
//    underLine.backgroundColor = UIColorFromRGB(0xe1e1e1);
    
    
    
    //加载推荐课程
    LMCourseRecommendViewController *cr = [[LMCourseRecommendViewController alloc] init];
    self.cr = cr;
    cr.delegate = self;
    cr.tableView.rowHeight = 98;
    CGFloat CrHeight = cr.tableView.rowHeight * 10;
    cr.tableView.frame = CGRectMake(0,CGRectGetMaxY(otherView.frame), self.view.width, CrHeight);
    [self.conScrollView addSubview:cr.tableView];
    
    
    //查看全部课程
    UIView *viewAll= [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cr.tableView.frame), self.view.width, 50)];
    self.viewAll = viewAll;
    viewAll.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.conScrollView addSubview:viewAll];
    
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width,  0.5)];
    [viewAll addSubview:underLine];
    underLine.backgroundColor = UIColorFromRGB(0xe1e1e1);
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, self.view.width - 20, 35)];
    [moreBtn setTitle:@"查看全部课程" forState:UIControlStateNormal];
    [moreBtn setTitleColor:UIColorFromRGB(0x51aa25) forState:UIControlStateNormal];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [moreBtn addTarget:self action:@selector(btnMoreClick) forControlEvents:UIControlEventTouchUpInside];
//    moreBtn.layer.cornerRadius = 2.5;
//    moreBtn.clipsToBounds = YES;
//    [moreBtn.layer setBorderWidth:0.5];
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref =  CGColorCreate(colorSpace,(CGFloat []){255, 255, 255, 1 });
//    [moreBtn.layer setBorderColor:colorref];
    [viewAll addSubview:moreBtn];
    
    
    //设置contentSize
    self.conScrollView.contentSize = CGSizeMake(self.view.width,CGRectGetMaxY(viewAll.frame) + NavH);
    
    if ([[NSString deviceString] isEqualToString: @"iPhone 4S"]) {
        self.conScrollView.contentSize = CGSizeMake(self.view.width,CGRectGetMaxY(viewAll.frame) + 64);
    }
    
    self.conScrollView.bounces = NO;
    
    
    [self loadImage];
 
    //请求数据
    [self loadCourseType];
    
    //请求城市数据
    [self loadCity];
    
    [self loadData];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_nav@2x.png"] forBarMetrics:UIBarMetricsDefault];
    
    //首页访问分析
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
    [MTA trackCustomKeyValueEvent:@"event_home_start" props:dict];
    
    //设置浏览判断语句
    NSString *lastTime =[[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime"];
    if(lastTime != nil)
    {
        NSString *nowTime = [NSString timeNow];
        MyLog(@"name===%i",([nowTime longLongValue] - [lastTime longLongValue]) >= 48*60*60*1000);
        if(([nowTime longLongValue] - [lastTime longLongValue]) >= 48*60*60*1000)
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"lookLater"];
        }
    }
    
     //判断语句
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"reject"]) {
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"lookLater"]){
        
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"look"])
            {
                [self addAlertView];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"look"];
            }
            
        }
    }
 
    
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



- (void)setupAdScrollView
{
    CGFloat wide = self.view.width;
    CGFloat height = AdScrollViewH;
    
    //图片轮播器
    for (int i = 0; i < self.adArr.count; i++) {
        
        UIImageView *iv= [[UIImageView alloc] init];
        iv.x = i * wide;
        iv.y = 0;
        iv.size = CGSizeMake(wide, height);
        NSDictionary *dic = self.adArr[i];
        [iv sd_setImageWithURL:[NSURL URLWithString:dic[@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"common"]];
        iv.backgroundColor = [UIColor redColor];
        [self.adScrollView addSubview:iv];
        iv.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClickTap:)];
        [iv addGestureRecognizer:tap];
        iv.userInteractionEnabled = YES;
    }
    self.adScrollView.contentSize = CGSizeMake(wide * self.adArr.count, height);
    self.adScrollView.pagingEnabled = YES;
    // 隐藏滚动条
    self.adScrollView.showsHorizontalScrollIndicator = NO;
    // 关闭弹簧效果
    self.adScrollView.bounces = NO;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.adArr.count;
    
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    pageControl.centerX = self.view.centerX;
    pageControl.y = AdScrollViewH - 8;
    
    pageControl.pageIndicatorTintColor = UIColorFromRGBWithAlpha(0xffffff, 0.5);
    pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x51aa25);
    
}

- (void)btnMoreClick
{
    LMCourseListMainViewController *lm = [[LMCourseListMainViewController alloc] init];
    lm.from = FromHome;
    [self.navigationController pushViewController:lm animated:YES];
}


#pragma mark -LMCourseRecommendViewControllerDelegate
- (void)courseRecommendViewController:(LMCourseRecommendViewController *)courseRecommendViewController id:(long long)id
{
    LMCourseIntroViewController *lin = [[LMCourseIntroViewController alloc] init];
    lin.id  = id;
    [self.navigationController pushViewController:lin animated:YES];
}

- (void)photoClickTap:(UITapGestureRecognizer *)tap
{
    int i = tap.view.tag;
    MyLog(@"tap.view.tag = %d", tap.view.tag);
    NSDictionary *dic =self.adArr[i];
    
    int login = [dic[@"login"] intValue];
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    
    if (login == 1 ) {
        
        if (account) {
            int type = [dic[@"type"] intValue];
            switch (type) {
                    
                case 0:
                {
                    LMAdOtherViewController *odv = [[LMAdOtherViewController alloc] init];
                    odv.urlString = [NSString stringWithFormat:@"%@%@",dic[@"pageUrl"],account.userPhone] ;
                    odv.title = dic[@"title"];
                    
                    //行为分析
                    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                    
                    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                    NSDictionary *dict = nil;
                    if (account) {
                        NSString *userPhone = account.userPhone;
                        dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":@"H5页面",@"num":@"0"};
                    }else
                    {
                        dict = @{@"device":deviceInfo,@"ad":@"H5页面",@"num":@"0"};
                    }
                    
                    [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                    
                    
                    [self.navigationController pushViewController:odv animated:YES];
                }
                    break;
                    
                case 1:
                {
                    LMCourseIntroViewController *cdv = [[LMCourseIntroViewController alloc] init];
                    cdv.id = [dic[@"typeId"] intValue];
                    
                    //行为分析
                    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                    
                    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                    NSDictionary *dict = nil;
                    if (account) {
                        NSString *userPhone = account.userPhone;
                        dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":dic[@"typeId"],@"num":@"1"};
                    }else
                    {
                        dict = @{@"device":deviceInfo,@"ad":dic[@"typeId"],@"num":@"1"};
                    }
                    
                    [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                    
                    [self.navigationController pushViewController:cdv animated:YES];
                }
                    break;
                    
                case 2:
                {
                    LMActivityDetailViewController *adv = [[LMActivityDetailViewController alloc] init];
                    adv.id = [dic[@"typeId"] intValue];
                    
                    //行为分析
                    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                    
                    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                    NSDictionary *dict = nil;
                    if (account) {
                        NSString *userPhone = account.userPhone;
                        dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":dic[@"typeId"],@"num":@"2"};
                    }else
                    {
                        dict = @{@"device":deviceInfo,@"ad":dic[@"typeId"],@"num":@"2"};
                    }
                    
                    [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                    
                    [self.navigationController pushViewController:adv animated:YES];
                }
                    break;
                    
                case 3:
                {
                    LMSchoolIntroViewController *adv = [[LMSchoolIntroViewController alloc] init];
                    adv.id = [dic[@"typeId"] intValue];
                    //行为分析
                    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                    
                    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                    NSDictionary *dict = nil;
                    if (account) {
                        NSString *userPhone = account.userPhone;
                        dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":dic[@"typeId"],@"num":@"3"};
                    }else
                    {
                        dict = @{@"device":deviceInfo,@"ad":dic[@"typeId"],@"num":@"3"};
                    }
                    
                    [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                    
                    [self.navigationController pushViewController:adv animated:YES];
                }
                    break;
                    
                case 4:
                {
                    LMTeacherIntroViewController *adv = [[LMTeacherIntroViewController alloc] init];
                    adv.id = [dic[@"typeId"] intValue];
                    
                    //行为分析
                    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                    
                    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                    NSDictionary *dict = nil;
                    if (account) {
                        NSString *userPhone = account.userPhone;
                        dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":dic[@"typeId"],@"num":@"4"};
                    }else
                    {
                        dict = @{@"device":deviceInfo,@"ad":dic[@"typeId"],@"num":@"4"};
                    }
                    
                    [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                    
                    [self.navigationController pushViewController:adv animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            
        }else
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"]) {
                LMLoginViewController *lg = [[LMLoginViewController alloc] init];
                lg.from = FromeOther;
                
                [self.navigationController pushViewController:lg animated:YES];
            }else
            {
                LMRegisterViewController *rv = [[LMRegisterViewController alloc] init];
                rv.from = FromeOtherVc;
                [self.navigationController pushViewController:rv animated:YES];
            }
        }
       
    }else
    {
        int type = [dic[@"type"] intValue];
        
        switch (type) {
                
            case 0:
            {
                LMAdOtherViewController *odv = [[LMAdOtherViewController alloc] init];
                odv.urlString = [NSString stringWithFormat:@"%@%@",dic[@"pageUrl"],account.userPhone] ;
                odv.title = dic[@"title"];
                
                //行为分析
                NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                
                LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                NSDictionary *dict = nil;
                if (account) {
                    NSString *userPhone = account.userPhone;
                    dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":@"H5页面",@"num":@"0"};
                }else
                {
                    dict = @{@"device":deviceInfo,@"ad":@"H5页面",@"num":@"0"};
                }
                
                [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                
                
                [self.navigationController pushViewController:odv animated:YES];
            }
                break;
                
            case 1:
            {
                LMCourseIntroViewController *cdv = [[LMCourseIntroViewController alloc] init];
                cdv.id = [dic[@"typeId"] intValue];
                NSString *adId = [NSString stringWithFormat:@"%@",dic[@"typeId"]];
                //行为分析
                NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                
                LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                NSDictionary *dict = nil;
                if (account) {
                    NSString *userPhone = account.userPhone;
                    dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":adId,@"num":@"1"};
                }else
                {
                    dict = @{@"device":deviceInfo,@"ad":adId,@"num":@"1"};
                }
                
                [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                
                [self.navigationController pushViewController:cdv animated:YES];
            }
                break;
                
            case 2:
            {
                LMActivityDetailViewController *adv = [[LMActivityDetailViewController alloc] init];
                adv.id = [dic[@"typeId"] intValue];
                NSString *adId = [NSString stringWithFormat:@"%@",dic[@"typeId"]];
                //行为分析
                NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                
                LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                NSDictionary *dict = nil;
                if (account) {
                    NSString *userPhone = account.userPhone;
                    dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":adId,@"num":@"2"};
                }else
                {
                    dict = @{@"device":deviceInfo,@"ad":adId,@"num":@"2"};
                }
                
                [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                
                [self.navigationController pushViewController:adv animated:YES];
            }
                break;
                
            case 3:
            {
                LMSchoolIntroViewController *adv = [[LMSchoolIntroViewController alloc] init];
                adv.id = [dic[@"typeId"] intValue];
                NSString *adId = [NSString stringWithFormat:@"%@",dic[@"typeId"]];
                //行为分析
                NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                
                LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                NSDictionary *dict = nil;
                if (account) {
                    NSString *userPhone = account.userPhone;
                    dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":adId,@"num":@"3"};
                }else
                {
                    dict = @{@"device":deviceInfo,@"ad":adId,@"num":@"3"};
                }
                
                [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                
                [self.navigationController pushViewController:adv animated:YES];
            }
                break;
                
            case 4:
            {
                LMTeacherIntroViewController *adv = [[LMTeacherIntroViewController alloc] init];
                adv.id = [dic[@"typeId"] intValue];
                NSString *adId = [NSString stringWithFormat:@"%@",dic[@"typeId"]];
                //行为分析
                NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
                
                LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
                NSDictionary *dict = nil;
                if (account) {
                    NSString *userPhone = account.userPhone;
                    dict = @{@"phone":userPhone,@"device":deviceInfo,@"ad":adId,@"num":@"4"};
                }else
                {
                    dict = @{@"device":deviceInfo,@"ad":adId,@"num":@"4"};
                }
                
                [MTA trackCustomKeyValueEvent:@"event_home_ad_click" props:dict];
                
                [self.navigationController pushViewController:adv animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }

    
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1002) {
        // 1.计算页码
        double ratio = scrollView.contentOffset.x / self.view.width;
        int page = (int)(ratio + 0.5);
        // 2.设置页码
        self.pageControl.currentPage = page;
    }else
    {
        if(!iOS8)
        {
            
            self.pageControl.y = - self.conScrollView.contentOffset.y + self.adScrollView.height - 8;
        }else
        {
            
            self.pageControl.y = - self.conScrollView.contentOffset.y + self.adScrollView.height - 8;
        }
    
    }
    
    
    
   
}

//添加定时器
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//移除定时器
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage
{
    // 1.增加pageControl的页码
    int page = 0;
    if (self.pageControl.currentPage == self.adArr.count - 1) {
        page = 0;
    }else
    {
        page = self.pageControl.currentPage + 1;
    }
    
     // 2.计算scrollView滚动的位置
    CGFloat offsetX = page *self.view.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.adScrollView setContentOffset:offset animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)searchBtnClick
{
    //行为分析
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
    [MTA trackCustomKeyValueEvent:@"event_search_box_click" props:dict];
    
    LMSearchViewController *rv = [[LMSearchViewController alloc] init];
    [self.navigationController pushViewController:rv animated:NO];
}


- (void)meBtnClick
{
    LMSettingViewController *set = [[LMSettingViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
}


- (void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"course/list.json"];
    

    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];

    arr[@"count"] = @"10";
    arr[@"order"] = @"4";
    
    NSString *gpsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"localGps"];
    if(gpsStr)
    {
        arr[@"gps"] = gpsStr;
    }
   
    
 
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    if(account)
    {
        parameters[@"sid"] = account.sid;
    }
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [self performSelector:@selector(delayAll) withObject:nil afterDelay:1.5];

        NSDictionary *courseDic = [responseObject[@"data"] objectFromJSONString];
                MyLog(@"%@",courseDic);
        
        NSArray *courseList = courseDic[@"courseList"];
        
        if(courseList.count == 0)
        {
            [self initFailView];
        }else
        {
            self.recommendCourseLists = [LMCourseList objectArrayWithKeyValuesArray:courseList];
            
            self.cr.courseLists = self.recommendCourseLists;
            
            [self.cr.tableView reloadData];
        }
     
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
            
            
            [self performSelector:@selector(delayHidHud) withObject:nil afterDelay:1.5];

            [self initFailView];
            
    }];
    
     
}

- (void)delayHidHud
{
    [CLProgressHUD dismiss];
    
}

- (void)delayFailView
{
    [self.failView removeFromSuperview];
}

- (void)delayAll
{
    [CLProgressHUD dismiss];
    [self.failView removeFromSuperview];
}
    


- (void)loadImage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"/commons/indexAd.json"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"provinceId"] = @"1";
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"------imagehome%@",dateDic);
        
        NSArray *adsArr = dateDic[@"ad"];
        self.adArr = adsArr;
        
        [self setupAdScrollView];
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
        [self setupAdScrollView];
    }];
    
}

- (void)loadCourseType
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"commons/indexCourseType.json"];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSArray *dateDic = responseObject[@"indexCourseTypeList"] ;
        MyLog(@"%@",dateDic);
        
//        NSArray *courseTypesArr = dateDic[@"courseTypes"];
        
        self.typrArr = [LMCourseType objectArrayWithKeyValuesArray:dateDic];
  
        self.cv.titles = self.typrArr;
        [self.cv.collectionView reloadData];
////
////        NSString *str = @"courseTypes.plist";
////        NSString *courseTypesPath = [str appendDocumentPath];
////        LogObj(courseTypesPath);
////        
//////        NSArray *courseArr = dateDic[@"courseTypes"];
//////        NSString *courseArrStr = [courseArr JSONString];
//////        [[NSUserDefaults standardUserDefaults] setObject:courseArrStr forKey:@"areaKey"];
//////        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        [courseTypesArr writeToFile:courseTypesPath atomically:YES];
        
        
        //计算刷新高度
        int row =  self.typrArr.count / 4;
        int collectHigh =  row *(10 + 60) + 10;
        self.cv.collectionView.height = collectHigh;
        self.space.y = CGRectGetMaxY(self.cv.collectionView.frame);
        self.otherView.y = CGRectGetMaxY(self.space.frame);
        self.cr.tableView.y = CGRectGetMaxY(self.otherView.frame);
        self.viewAll.y = CGRectGetMaxY(self.cr.tableView.frame);
        
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}


- (void)loadCity
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"commons/area.json?areaId=828"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"addressdateDic==%@",dateDic);
        
        NSArray *areaArr = dateDic[@"areas"];
        
        NSString *areaArrStr = [areaArr JSONString];
        [[NSUserDefaults standardUserDefaults] setObject:areaArrStr forKey:@"areaKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      
        [areaArr writeToFile:LMAreasPath atomically:YES];
     

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}




#pragma mark - 点击城市按钮
- (void)titleBtnOnClick:(IWCityButton *)cityButton
{
    
#warning 暂时禁掉
//    CityListViewController *city = [[CityListViewController alloc] init];
//    
//    
//    city.delegate = self;
//    
//    [self presentViewController:city animated:NO completion:nil];
    
    //行为分析
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
    [MTA trackCustomKeyValueEvent:@"event_home_city_switch_click" props:dict];
    
    UILabel *label = [[UILabel alloc] init];
    label.width = 200;
    label.height = 40;
    label.centerX = self.view.centerX;
    label.y = self.view.height - 150;
    
    label.text = @"目前只支持北京地区";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 5;
    label.clipsToBounds =  YES;
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 0;
    
    [self.view addSubview:label];
    
    [UIView animateWithDuration:0.5 animations:^{
        label.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];

  
}

#warning 点击城市改变标题的,暂时不用
//#pragma mark - LMCityListViewControllerDelegate
//- (void)cityListViewController:(CityListViewController *)cityListViewController didSeclectCity:(NSString *)city
//{
//    [self.cityButton setTitle:city forState:UIControlStateNormal];
//
//}


#pragma mark - LMCourseCollectionViewControllerDelegate
- (void)courseCollectionViewController:(LMCourseCollectionViewController *)courseCollectionViewController title:(NSString *)title productId:(NSNumber *)productId
{
    LMCourseListMainViewController *lv = [[LMCourseListMainViewController alloc] init];
   

    lv.TypeId = productId;
    lv.courseTitle = title;
    lv.from = FromHome;
    
    [self.navigationController pushViewController:lv animated:YES];
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        {
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reject"];
        
        }else if (buttonIndex == 2)
        {
            NSString *lastTime =[NSString timeNow];//@"1417363200000";// ;//测试1419696000
            [[NSUserDefaults standardUserDefaults] setObject:lastTime forKey:@"lastTime"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lookLater"];
        
        }else
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reject"];
        }
    
}


- (NSArray *)recommendCourseLists
{
    if (_recommendCourseLists == nil) {
        _recommendCourseLists = [NSArray array];
    }
    return _recommendCourseLists;
}


- (void)addAlertView
{
    UIButton *alertViewBtn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertViewBtn.alpha = 0.5;
    alertViewBtn.backgroundColor = [UIColor blackColor];
    [alertViewBtn addTarget:self action:@selector(alterViewQuit) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:alertViewBtn];
    self.alertViewBtn  = alertViewBtn;
    
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = UIColorFromRGB(0xfffddd);
    alertView.layer.cornerRadius = 2.5f;
    alertView.clipsToBounds = YES;
    alertView.size = CGSizeMake(230, 285);
    alertView.centerX = self.view.centerX;
    alertView.centerY = self.view.centerY;
    [[UIApplication sharedApplication].keyWindow  addSubview:alertView];
    self.alertView = alertView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 140, 68)];
    imageView.image = [UIImage imageNamed:@"review_loading"];
    [alertView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 70, 180, 40)];
    label.text = @"  主人,如果觉得“多学”好,    请赐予我们一个5星的评价吧";
    label.textColor = UIColorFromRGB(0xff9e01);
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    [alertView addSubview:label];

    
    UIButton *scoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 117, 180, 48)];
    [scoreBtn setBackgroundImage:[UIImage imageNamed:@"btn_review_loading_normal"] forState:UIControlStateNormal];
    [scoreBtn setBackgroundImage:[UIImage imageNamed:@"btn_review_loading_pressed"] forState:UIControlStateHighlighted];
    [scoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scoreBtn setTitle:@"赐个5星" forState:UIControlStateNormal];
    scoreBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [scoreBtn addTarget:self action:@selector(scoreFive) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:scoreBtn];

    
    UIButton *laterBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 175, 130, 44)];
    [laterBtn setBackgroundImage:[UIImage imageNamed:@"btn2_review_loading_normal"] forState:UIControlStateNormal];
    [laterBtn setBackgroundImage:[UIImage imageNamed:@"btn2_review_loading_pressed"] forState:UIControlStateHighlighted];
    [laterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [laterBtn setTitle:@"再看看表现" forState:UIControlStateNormal];
    laterBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [laterBtn addTarget:self action:@selector(scoreLater) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:laterBtn];
    
    UIButton *rejectBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 229, 130, 44)];
    [rejectBtn setBackgroundImage:[UIImage imageNamed:@"btn2_review_loading_normal"] forState:UIControlStateNormal];
    [rejectBtn setBackgroundImage:[UIImage imageNamed:@"btn2_review_loading_pressed"] forState:UIControlStateHighlighted];
    [rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rejectBtn setTitle:@"残忍拒绝" forState:UIControlStateNormal];
    rejectBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [rejectBtn addTarget:self action:@selector(reject) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:rejectBtn];

    
}

- (void)alterViewQuit
{
    MyLog(@"点击背景===");
    NSString *lastTime =[NSString timeNow];//@"1417363200000";// ;//测试1419696000
    [[NSUserDefaults standardUserDefaults] setObject:lastTime forKey:@"lastTime"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lookLater"];
    
    [self.alertView removeFromSuperview];
    [self.alertViewBtn removeFromSuperview];
}

- (void)scoreFive
{
    MyLog(@"scoreFive===");
    NSString* m_appleID = LMAppID;    //此处的appID是在iTunes Connect创建应用程序时生成的Apple ID
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://itunes.apple.com/app/id%@",m_appleID ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reject"];
    [self.alertView removeFromSuperview];
    [self.alertViewBtn removeFromSuperview];
}

- (void)scoreLater
{
    MyLog(@"scoreLater===");
    NSString *lastTime =[NSString timeNow];//@"1417363200000";// ;//测试1419696000
    [[NSUserDefaults standardUserDefaults] setObject:lastTime forKey:@"lastTime"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lookLater"];
    [self.alertView removeFromSuperview];
    [self.alertViewBtn removeFromSuperview];
}

- (void)reject
{
   MyLog(@"reject===");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reject"];
    [self.alertView removeFromSuperview];
    [self.alertViewBtn removeFromSuperview];
}



-(void)initFailView
{
    if (self.failView==nil)
    {
        
        CGRect myRect  =[UIApplication sharedApplication].keyWindow.bounds;
        _failView = [[UIView alloc]initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y+NavHight, myRect.size.width, myRect.size.height-NavHight)];
        _failView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_failView];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,240-45,MainViewWidth, 20)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = RGBCOLOR(62, 62, 62);
        lbl.font = [UIFont systemFontOfSize:15.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"咦，数据加载失败了";
        [_failView addSubview:lbl];
        
        
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0,270-45,MainViewWidth, 20)];
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.textColor = RGBCOLOR(82, 82, 82);
        lbl2.font = [UIFont systemFontOfSize:14.0f];
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.text = @"请检查下您的网络，重新加载吧";
        [_failView addSubview:lbl2];
        
        
        UIImage *bgI = [UIImage imageNamed:@"default_button"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MainViewWidth/2-bgI.size.width/2,310-45,bgI.size.width, bgI.size.height);
        [btn setBackgroundImage:[UIImage imageNamed:@"default_button"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"default_button_press"] forState:UIControlStateHighlighted];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(62, 62, 62) forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(refreshDataWhenFailRequest)
      forControlEvents:UIControlEventTouchUpInside];
    
        [_failView addSubview:btn];
    }
  
    
    
}

-(void)refreshDataWhenFailRequest
{
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
    
    [self loadData];
    [self loadImage];
    [self loadCourseType];
}





@end
