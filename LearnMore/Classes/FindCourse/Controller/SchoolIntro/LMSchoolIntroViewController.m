//
//  LMSchoolIntroViewController.m
//  LearnMore
//
//  Created by study on 14-10-9.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//
#define LMSchoolMark 20
#define LMPadding 20
#define LMLeftPadding 15
#define LMViewMovedTime 0.3

#define LMMyScrollMarkHeight  ([UIScreen mainScreen].bounds.size.height - self.menuBtnView.height - self.phone.height - 64)


#import "LMTeacherIntroViewController.h"
#import "LMSchoolIntroViewController.h"
#import "LMTeacherButton.h"
#import "AFNetworking.h"
#import "LMTeachList.h"
#import "LMCourseInfo.h"
#import "ACETelPrompt.h"
#import "CLProgressHUD.h"
#import "LMOneSchRecViewController.h"
#import "TQStarRatingDisplayView.h"
#import "LMMapViewController.h"
#import "LMLoginViewController.h"
#import "LMMenuButtonView.h"
#import "LMSchoolDetailViewController.h"
#import "LMSchoolCourseViewController.h"
#import "LMSchoolTeacherViewController.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "LMAddRecommendViewController.h"
#import "MTA.h"

#import "LMRecommend.h"
#import "LMRecommedFrame.h"
#import "LMDetailRecommendViewCell.h"
#import "LMDetailRecommendViewController.h"

#import "LMTeacherInfo.h"


@interface LMSchoolIntroViewController ()<UIScrollViewDelegate,LMMenuButtonViewDelegate>

/** 标记 */
@property (nonatomic, assign) BOOL sign;

/** 头部标题 */
@property (nonatomic, strong) UIView *headView;

@property (strong, nonatomic) IBOutlet UIView *schoolDisplay;

/** 尾部标题 */
@property (strong, nonatomic)  UIView *footView;

/** 整个scrollView */
@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *schoolImageView;

@property (weak, nonatomic) IBOutlet UILabel *schoolFullNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong) NSArray *datas;

@property (strong, nonatomic)  UIView *teacherInfo;
/** 电话 */
@property (strong, nonatomic) IBOutlet UIView *phone;

/** 老师列表 */
@property (nonatomic, strong) NSArray *teachers;

/** 老师的id */
@property (nonatomic, assign) long long teacherId;

/** 电话 */
@property (copy, nonatomic) NSString *phoneNum;

@property (weak, nonatomic) IBOutlet UILabel *level1;
@property (weak, nonatomic) IBOutlet UILabel *level2;
@property (weak, nonatomic) IBOutlet UILabel *level3;
@property (weak, nonatomic) IBOutlet UILabel *level4;

@property (weak, nonatomic) IBOutlet UILabel *tLevel;

@property (weak, nonatomic) IBOutlet UILabel *courseMack;

@property (weak, nonatomic) IBOutlet UILabel *parentRec;

@property (strong, nonatomic) IBOutlet UIView *recHeadView;//点评头部标题
@property (strong, nonatomic) IBOutlet UIView *recFootView;//点评尾部标题

/** 学校点评,一定要用强指针引用 */
@property (nonatomic, strong) LMOneSchRecViewController *srv;

@property (copy, nonatomic) NSString *gps;
@property (copy, nonatomic) NSString *address;

/** 菜单按钮的view */
@property (nonatomic, weak) LMMenuButtonView *menuBtnView;
/** 主视图的底部ScrollView */
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIButton *writeRecBtn;
/** 老师列表控制器 */
@property (nonatomic, strong)  LMSchoolTeacherViewController *tl;
/** 点评模型 */
@property (nonatomic, strong) NSMutableArray *recomFrames;
/** 开设课程控制器 */
@property (nonatomic, strong)  LMSchoolCourseViewController *trv;
/** 学校点评字典 */
@property (nonatomic, strong) NSDictionary *schoolScoreDic;


@end

@implementation LMSchoolIntroViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.view addSubview:self.phone];
    
    //重写返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"public_nav_black" target:self sel:@selector(goBack)];
    
    self.phone.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.phone.height , self.view.width, self.phone.height);
}
- (void)goBack
{
    [self.scrollView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.title = @"学校信息";
    
    [self.writeRecBtn setTitleColor:UIColorFromRGB(0x9ac72c) forState:UIControlStateNormal];
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
    
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OneSchoolRecViewControllerChange:) name:@"OneRecSchoolNotification" object:nil];
   
    
    //创建整个scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.tag = 111;
    scrollView.frame = CGRectMake(0, 0, self.view.width,self.view.height - self.phone.height);
    scrollView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    self.scrollView = scrollView;
     scrollView.bounces = NO;
    
    
    [self.scrollView addSubview:self.schoolDisplay];
    
    
    
  
#warning 暂时禁掉
    //添加点评
    LMOneSchRecViewController *srv = [[LMOneSchRecViewController alloc] init];
    self.srv = srv;
    srv.view.x = 0;
    srv.view.y = CGRectGetMaxY(self.schoolDisplay.frame) + LMSchoolMark;
    srv.view.width = self.view.width;
    
    srv.tableView.tableHeaderView = self.recHeadView;
    srv.tableView.tableFooterView = self.recFootView;
    
    [self.scrollView addSubview:srv.view];
    
    self.srv.view.height = 88;
    
    
    CGSizeMake(self.view.width, CGRectGetMaxY(self.menuBtnView.frame) + LMMyScrollMarkHeight);
    
    [self loadSchoolRec];
    [self loadData];
    [self loadCourse];
    [self loadTeacher];
    
 
    // 3个控制器的菜单按钮
    [self setupTitleButtonView];
    
    // 设置ScrollView
    [self setupScrollView];
    
    // 设置tableView
    [self setupTableViews];
    
}


// 3个控制器的菜单按钮
- (void)setupTitleButtonView
{
     LMMenuButtonView *titleBtnView = [[LMMenuButtonView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) titleArr:@[@"学校详情",@"开设课程",@"老师信息"]];
    self.menuBtnView = titleBtnView;
    // 设置代理
    self.menuBtnView.delegate = self;
    
    // 设置frame
    self.menuBtnView.x = 0;
    self.menuBtnView.width = self.view.width;
    self.menuBtnView.height = 44;
    self.menuBtnView.y = CGRectGetMaxY(self.srv.view.frame) + LMSchoolMark;
    
    [self.scrollView addSubview:titleBtnView];
    
}


// 设置主视图的底部ScrollView
- (void)setupScrollView
{
    self.myScrollView.contentSize = CGSizeMake(3 * self.view.width, LMMyScrollMarkHeight);
    
    // 设置scrollView的属性
    self.myScrollView.bounces = NO;
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.userInteractionEnabled = YES;
    
    // 垂直滚动时,左右不能滚动
    self.myScrollView.directionalLockEnabled = YES;
    
    // 设置代理
    self.myScrollView.delegate = self;
    
}


// 初始化3个控制器,添加为子控制器,把控制器的view添加到根视图的scrollView里面,设置frame的x值
- (void)setupTableViews
{
    //学校详情控制器
    LMSchoolDetailViewController *cv = [[LMSchoolDetailViewController alloc] init];
    cv.urlString =  [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/school_des.html?id=%lli",_id];
    [self.myScrollView addSubview:cv.view];
    cv.view.x = 0;
    [self addChildViewController:cv];
    
    
    
    //开设课程控制器
    LMSchoolCourseViewController *trv = [[LMSchoolCourseViewController alloc] initWithStyle:UITableViewStylePlain];
    self.trv = trv;
    trv.tableView.height = LMMyScrollMarkHeight;
    [self addChildViewController:trv];
    [self.myScrollView addSubview:trv.tableView];
    trv.tableView.y = 0;
    trv.tableView.x = CGRectGetMaxX(cv.view.frame);
    
    MyLog(@"trv.tableView===%@",NSStringFromCGRect(trv.tableView.frame));
    
    
    //老师信息控制器
    LMSchoolTeacherViewController *tv = [[LMSchoolTeacherViewController alloc] init];
    self.tl = tv;
    tv.tableView.height = LMMyScrollMarkHeight;
    [self addChildViewController:tv];
    [self.myScrollView addSubview:tv.tableView];
    tv.tableView.x = CGRectGetMaxX(trv.view.frame);
    
     MyLog(@"tv.tableView===%@",NSStringFromCGRect(tv.tableView.frame));
    
    
}


#pragma mark-- LMMenuButtonViewDelegate
- (void)titleButtonViewDidClickButton:(NSInteger)tag
{
    [UIView animateWithDuration:LMViewMovedTime animations:^{
        self.myScrollView.contentOffset = CGPointMake(tag * self.view.width, 0);
    }];
    
}

#pragma mark - UIScrollViewDelegate 代理方法
// 拖动scrollView,切换标题按钮的选中状态
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView.tag == 112)
    {
        int x = scrollView.contentOffset.x;
        
        int i = x / (self.view.width) + 0.5;
        self.menuBtnView.i = i;
        MyLog(@"scrollVieweaaaaaaaaaaaaa===%d",i);
        
        CGFloat progress = x / (2 * self.view.width);
        self.menuBtnView.progress = progress;
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [CLProgressHUD dismiss];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



/** 学校点评 */
- (void)loadSchoolRec
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];


    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/list.json"];


    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",self.id];
    arr[@"type"] = @"3";
    arr[@"time"] = [NSString timeNow];
    arr[@"count"] = @"1";

    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;


    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        LogObj(responseObject);

        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"%@",dateDic);
        
        self.parentRec.text = [NSString stringWithFormat:@"家长点评（%@）",dateDic[@"tcount"]];

        NSArray *recomArr = [LMRecommend objectArrayWithKeyValuesArray:dateDic[@"comments"]];
        NSMutableArray *frameModels = [NSMutableArray arrayWithCapacity:recomArr.count];
        for (LMRecommend *recom in recomArr) {
            LMRecommedFrame *recomFrame = [[LMRecommedFrame alloc] init];
            recomFrame.recommend = recom;
            [frameModels addObject:recomFrame];
        }

        self.recomFrames = frameModels;
        self.srv.recomFrames = self.recomFrames;
        [self.srv.tableView reloadData];
        
        if (self.recomFrames.count ==  0) {
            
            self.srv.view.height = 88 ;
            self.menuBtnView.y = CGRectGetMaxY(self.srv.view.frame) + LMSchoolMark;
            self.myScrollView.y = CGRectGetMaxY(self.menuBtnView.frame);
            self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.menuBtnView.frame) + LMMyScrollMarkHeight);

        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}



//监听学校点评高度变化
- (void)OneSchoolRecViewControllerChange:(NSNotification *)notifi
{
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat height = [userInfo[@"SchoolCellHeight"] doubleValue];
    
    
    MyLog(@"height===%f",height);
    
    self.srv.view.height = 88 + height;
    self.menuBtnView.y = CGRectGetMaxY(self.srv.view.frame) + LMSchoolMark;
    self.myScrollView.y = CGRectGetMaxY(self.menuBtnView.frame);
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.menuBtnView.frame) + LMMyScrollMarkHeight);
}


/** 查看点评 */
- (IBAction)lookRecommend:(id)sender {
    
    if(self.recomFrames.count)
    {
        LMDetailRecommendViewController *dv = [[LMDetailRecommendViewController alloc] init];
        dv.id = _id;
        dv.type = 3;
        dv.mainTitle = self.schoolFullNameLabel.text;
        dv.courseScoreDic = self.schoolScoreDic;
        [self.navigationController pushViewController:dv animated:YES];
    }
    
}



- (void)loadTeacher
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"teacher/list.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"school"] = [NSString stringWithFormat:@"%lli",_id];
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    //设备信息
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        
        MyLog(@"teacherList===%@",dateDic[@"teacherList"]);
        
        self.teachers = [LMTeachList objectArrayWithKeyValuesArray:dateDic[@"teacherList"]];
        self.tl.teachers = self.teachers;
        
        if(self.teachers.count == 0)
        {
            UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
            UILabel *label  = [[UILabel alloc] init];
            label.width = 100;
            label.height = 40;
            label.centerX = self.view.centerX;
            label.y = 0;
            label.text = @"暂无数据";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [moreView addSubview:label];
            self.tl.tableView.tableFooterView = moreView;
        }else
        {
            UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
            UILabel *label  = [[UILabel alloc] init];
            label.width = 100;
            label.height = 40;
            label.centerX = self.view.centerX;
            label.y = 0;
//            label.text = @"已加载全部";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [moreView addSubview:label];
            self.tl.tableView.tableFooterView = moreView;
            
        }
        
        [self.tl.tableView reloadData];
  
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}

- (void)loadCourse
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"course/list.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"school"] = [NSString stringWithFormat:@"%lli",_id];
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    //设备信息
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        NSArray *courseArr = [LMCourseInfo objectArrayWithKeyValuesArray:dateDic[@"courseList"]];
        self.trv.datas = courseArr;
        
        if(courseArr.count == 0)
        {
            UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
            UILabel *label  = [[UILabel alloc] init];
            label.width = 100;
            label.height = 40;
            label.centerX = self.view.centerX;
            label.y = 0;
            label.text = @"暂无数据";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [moreView addSubview:label];
            self.trv.tableView.tableFooterView = moreView;
        }else
        {
            UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
            UILabel *label  = [[UILabel alloc] init];
            label.width = 100;
            label.height = 40;
            label.centerX = self.view.centerX;
            label.y = 0;
//            label.text = @"已加载全部";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [moreView addSubview:label];
            self.trv.tableView.tableFooterView = moreView;
            
        }
        
        [self.trv.tableView reloadData];
      
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}



- (void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"school/info.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    //设备信息
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        
        
        /** 取出字典 */
        NSDictionary *schoolInfoDic = dateDic[@"school"];
        LogObj(dateDic[@"school"]);
        MyLog(@"name===%@",dateDic[@"school"]);
        
        self.phoneNum = schoolInfoDic[@"contactPhone"];
        self.gps = schoolInfoDic[@"schoolGps"];
        self.address = schoolInfoDic[@"address"];
        
        NSArray *mainCourse = [schoolInfoDic[@"mainCourse"] objectFromJSONString];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in mainCourse) {
            [arrM addObject:dict[@"name"]];
        }
        self.courseMack.text = [NSString stringWithFormat:@"课程标签: %@",[arrM componentsJoinedByString:@"、"]];
        
        
//        if (self.schoolMark) {
//            self.courseMack.text =[NSString stringWithFormat:@"课程标签: %@",self.schoolMark] ;
//        }else
//        {
//            self.courseMack.text = @"课程标签: 其他";
//        }
        
        
        NSDictionary *schoolCommentLevel =schoolInfoDic[@"schoolCommentLevel"];
        self.schoolScoreDic = schoolCommentLevel;
        self.level1.text = schoolCommentLevel[@"avgLevel1"];
        self.level2.text = schoolCommentLevel[@"avgLevel2"];
        self.level3.text = schoolCommentLevel[@"avgLevel3"];
        self.level4.text = schoolCommentLevel[@"avgLevel4"];
        
        TQStarRatingDisplayView *star = [[TQStarRatingDisplayView alloc] initWithFrame:CGRectMake(125,45,90,14) numberOfStar:5 norImage:@"public_review_small_normal" highImage:@"public_review_small_pressed" starSize:14 margin:5 score:schoolCommentLevel[@"avgTotalLevel"]];
        [self.schoolDisplay addSubview:star];
        
        self.tLevel.text = schoolCommentLevel[@"avgTotalLevel"];
        
    
        
     
            self.addressLabel.text = schoolInfoDic[@"address"];
            
            
            if ([schoolInfoDic[@"schoolImage"] isKindOfClass:[NSString class]] )
            {
                [self.schoolImageView sd_setImageWithURL:[NSURL URLWithString:schoolInfoDic[@"schoolImage"]] placeholderImage:[UIImage imageNamed:@"activity"]];
            }
        self.schoolImageView.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
        self.schoolImageView.layer.borderWidth = 1.0f;
        
          
            
            self.schoolFullNameLabel.text = schoolInfoDic[@"schoolFullName"];
        
        
         [CLProgressHUD dismiss];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}


- (IBAction)recommend:(id)sender {
    
    LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    if (account) {
        LMAddRecommendViewController *add = [[LMAddRecommendViewController alloc] init];
        
        add.id = self.id;
        add.urlStr = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/schoolComment.json"];
        
        [self.navigationController pushViewController:add animated:YES];
    }else
    {
        LMLoginViewController *log = [[LMLoginViewController alloc] init];
        [self.navigationController pushViewController:log animated:YES];
    }
    
    
    
}


- (IBAction)call:(id)sender {
    
    if (self.phoneNum.length) {
        
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
        
        LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
        NSString *sid = account.sid;
        NSString *coId = [NSString stringWithFormat:@"%lli",_id];
        NSDictionary *dict = @{@"sid":sid,@"type":@"3",@"id":coId,@"version":version,@"device":deviceInfo};
        
        [MTA trackCustomKeyValueEvent:@"school_call_record" props:dict];
        
        
        [ACETelPrompt callPhoneNumber:self.phoneNum call:^(NSTimeInterval duration) {
            
        } cancel:^{
            
        }];
    }
    
}


/** 跳转地图页面 */
- (IBAction)mapClick:(id)sender {
    LMMapViewController *lm = [[LMMapViewController alloc] init];
    lm.gps = self.gps;
    lm.address = self.address;
    
    [self presentViewController:lm animated:YES completion:nil];
    
}

#pragma mark - 懒加载
- (UIScrollView *)myScrollView
{
    if (_myScrollView == nil) {
        
        // 设置frame
        CGFloat y = CGRectGetMaxY(self.menuBtnView.frame);
        CGFloat w = self.view.width;
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, w, LMMyScrollMarkHeight)];
        LogFrame(_myScrollView);
        _myScrollView.tag = 112;
        [self.scrollView addSubview:self.myScrollView];
    }
    return _myScrollView;
}




@end
