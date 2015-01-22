//
//  LMViewController.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define NavH (([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)? 0 : 0)

#define LMAdsDocPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ads.plist"]

#define LMAreasPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"smallAreas.plist"]

#define AdScrollViewH 135

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

@end

@implementation LMFindCourseViewController

- (void)viewDidLoad
{
   
    
    [super viewDidLoad];
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
//    [DejalWhiteActivityView currentActivityView].activityLabel.text = @"正在加载";
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    MyLog(@"%@=====",identifier);

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,35)];
    view.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = view;

    
    //创建城市按钮
    IWCityButton *cityButton = [[IWCityButton alloc] init];
    cityButton.frame = CGRectMake(20, 0, 55, 30);
    // 设置标题
    [cityButton setTitle:@"北京" forState:UIControlStateNormal];
    [cityButton setTitleColor:UIColorFromRGB(0x9ac72c) forState:UIControlStateNormal];
    
    [cityButton setImage:[UIImage imageNamed:@"btn_home_arrow"] forState:UIControlStateNormal];
    [view addSubview:cityButton];
    self.cityButton = cityButton;
    // 2.1监听标题按钮的点击事件
    [cityButton addTarget:self action:@selector(titleBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
 
    
    // 创建自定义搜素框
    UIImageView *searchBar = [[UIImageView alloc] init];
    searchBar.x = CGRectGetMaxX(self.cityButton.frame) + 20;
    searchBar.y = 0;
    searchBar.width = self.view.width - 20 - self.cityButton.width -20 - 15 - 15;
    searchBar.height = 30;
    searchBar.image = [UIImage resizableImageWithName:@"search_nav_bg"];
    [view addSubview:searchBar];
    self.searchBar = searchBar;
    
    //添加一个放大镜
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_search"]];
    iv.frame = CGRectMake(10, 7.5, 15, 15);
    [self.searchBar addSubview:iv];
    
    //添加label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 100, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"输入关键字";
    [self.searchBar addSubview:label];

    //覆盖一个透明的按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:self.searchBar.frame];
    btn.backgroundColor = [UIColor clearColor];
    [view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    LogFrame(btn);
    
    //创建内容scrollView
    UIScrollView *conScrollView  = [[UIScrollView alloc] init];
    conScrollView.delegate =self;
    conScrollView.x = 0;
    conScrollView.y = 0;
    conScrollView.width = self.view.width;
    conScrollView.height = self.view.height;
    [self.view addSubview:conScrollView];
    self.conScrollView = conScrollView;
    
    //创建广告adScrollView
    UIScrollView *adScrollView  = [[UIScrollView alloc] init];
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

    cv.collectionView.frame = CGRectMake(0, self.adScrollView.height, self.view.width, 275);
    
    [self.conScrollView addSubview:cv.collectionView];

	self.cv = cv;
    
   
    
    //其他孩子都在学
    UIView *view1= [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cv.collectionView.frame), self.view.width, 30)];
    view1.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.conScrollView addSubview:view1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
    label1.text = @"别人家的孩子都在学";
    label1.textColor = [UIColor darkGrayColor];
    label1.font = [UIFont systemFontOfSize:14];
    [view1 addSubview:label1];
    
    //加载推荐课程
    LMCourseRecommendViewController *cr = [[LMCourseRecommendViewController alloc] init];
    self.cr = cr;
    cr.delegate = self;
    cr.tableView.rowHeight = 98;
    CGFloat CrHeight = cr.tableView.rowHeight * 10;
    cr.tableView.frame = CGRectMake(0,CGRectGetMaxY(view1.frame), self.view.width, CrHeight);
    [self.conScrollView addSubview:cr.tableView];
    
    
    //其他孩子都在学
    UIView *view2= [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cr.tableView.frame), self.view.width, 30)];
    view2.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.conScrollView addSubview:view2];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [moreBtn addTarget:self action:@selector(btnMoreClick) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:moreBtn];
    
    
    //设置contentSize
    self.conScrollView.contentSize = CGSizeMake(self.view.width,CGRectGetMaxY(view2.frame) + NavH);
    
    if ([[NSString deviceString] isEqualToString: @"iPhone 4S"]) {
        self.conScrollView.contentSize = CGSizeMake(self.view.width,CGRectGetMaxY(view2.frame) + 64);
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

////评分引导页面
//- (void)showScore
//{
//    
//    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil message:@"评分引导" delegate:self cancelButtonTitle:@"残忍拒绝" otherButtonTitles:@"赐个5星",@"再看看表现", nil];
//    
//    alert.delegate = self;
//    [alert show];
//}

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
    pageControl.x = self.view.width - 70;
    pageControl.y = height + 30;
    
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
}

- (void)btnMoreClick
{
    LMCourseListMainViewController *lm = [[LMCourseListMainViewController alloc] init];
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
                    [self.navigationController pushViewController:odv animated:YES];
                }
                    break;
                    
                case 1:
                {
                    LMCourseIntroViewController *cdv = [[LMCourseIntroViewController alloc] init];
                    cdv.id = [dic[@"typeId"] intValue];
                    [self.navigationController pushViewController:cdv animated:YES];
                }
                    break;
                    
                case 2:
                {
                    LMActivityDetailViewController *adv = [[LMActivityDetailViewController alloc] init];
                    adv.id = [dic[@"typeId"] intValue];
                    [self.navigationController pushViewController:adv animated:YES];
                }
                    break;
                    
                case 3:
                {
                    LMSchoolIntroViewController *adv = [[LMSchoolIntroViewController alloc] init];
                    adv.id = [dic[@"typeId"] intValue];
                    [self.navigationController pushViewController:adv animated:YES];
                }
                    break;
                    
                case 4:
                {
                    LMTeacherIntroViewController *adv = [[LMTeacherIntroViewController alloc] init];
                    adv.id = [dic[@"typeId"] intValue];
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
                [self.navigationController pushViewController:lg animated:YES];
            }else
            {
                LMRegisterViewController *rv = [[LMRegisterViewController alloc] init];
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
                odv.urlString = [NSString stringWithFormat:@"%@%@",dic[@"pageUrl"],account.userPhone];
                odv.title = dic[@"title"];
                [self.navigationController pushViewController:odv animated:YES];
            }
                break;
                
            case 1:
            {
                LMCourseIntroViewController *cdv = [[LMCourseIntroViewController alloc] init];
                cdv.id = [dic[@"typeId"] intValue];
                [self.navigationController pushViewController:cdv animated:YES];
            }
                break;
                
            case 2:
            {
                LMActivityDetailViewController *adv = [[LMActivityDetailViewController alloc] init];
                adv.id = [dic[@"typeId"] intValue];
                [self.navigationController pushViewController:adv animated:YES];
            }
                break;
                
            case 3:
            {
                LMSchoolIntroViewController *adv = [[LMSchoolIntroViewController alloc] init];
                adv.id = [dic[@"typeId"] intValue];
                [self.navigationController pushViewController:adv animated:YES];
            }
                break;
                
            case 4:
            {
                LMTeacherIntroViewController *adv = [[LMTeacherIntroViewController alloc] init];
                adv.id = [dic[@"typeId"] intValue];
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
    
    // 1.计算页码
    double ratio = scrollView.contentOffset.x / self.view.width;
    int page = (int)(ratio + 0.5);
    // 2.设置页码
    self.pageControl.currentPage = page;
    
    
    if(!iOS8)
    {
        
        self.pageControl.y = - self.conScrollView.contentOffset.y + self.adScrollView.height - 10;
    }else
    {
        
        self.pageControl.y = - self.conScrollView.contentOffset.y + self.adScrollView.height - 30;
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

- (void)btnClick
{
    LMSearchViewController *rv = [[LMSearchViewController alloc] init];
    rv.from = FromHome;
    [self.navigationController pushViewController:rv animated:NO];
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
    }];
    
}

- (void)loadCourseType
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"commons/courseType.json"];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"%@",dateDic);
        
        NSArray *courseTypesArr = dateDic[@"courseTypes"];
        
        self.typrArr = [LMCourseType objectArrayWithKeyValuesArray:courseTypesArr];
        
//        self.cv.titles = self.typrArr;
//        [self.cv reloadInputViews];
        
        NSString *str = @"courseTypes.plist";
        NSString *courseTypesPath = [str appendDocumentPath];
        LogObj(courseTypesPath);
        
//        NSArray *courseArr = dateDic[@"courseTypes"];
//        NSString *courseArrStr = [courseArr JSONString];
//        [[NSUserDefaults standardUserDefaults] setObject:courseArrStr forKey:@"areaKey"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [courseTypesArr writeToFile:courseTypesPath atomically:YES];
    
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
- (void)courseCollectionViewController:(LMCourseCollectionViewController *)courseCollectionViewController title:(NSString *)title
{
    LMCourseListMainViewController *lv = [[LMCourseListMainViewController alloc] init];
   
    for (LMCourseType *type in self.typrArr) {
        if ([title isEqualToString:type.typeName]) {
            NSNumber *typeId =  type.id;
            
            lv.TypeId = typeId;
            lv.courseTitle = title;
            MyLog(@"%@",lv.TypeId);
            
        }
    }
    
//    lv.firstTypeName = title;
    
    [self.navigationController pushViewController:lv animated:NO];
    
   
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
//    [alertViewBtn addSubview:alertView];
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
        //btn.layer.borderWidth=1;
        //btn.layer.borderColor=RGBCOLOR(162, 162, 162).CGColor;
        //btn.layer.cornerRadius=5;
        [_failView addSubview:btn];
    }
    
    //    for (UIView *subView in _failView.subviews)
    //    {
    //        [subView removeFromSuperview];
    //    }
    
    
}

-(void)refreshDataWhenFailRequest
{
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
    
    [self loadData];
    [self loadImage];
}


@end
