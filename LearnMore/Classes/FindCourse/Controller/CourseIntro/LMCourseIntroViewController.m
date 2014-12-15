//
//  LMCourseIntroViewController.m
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMPadding 20
#define LMLeftPadding 15
#define LMNavHeight 0
#define LMCourseMark 20
#define LMViewMovedTime 0.3

#define LMMyScrollMarkHeight  ([UIScreen mainScreen].bounds.size.height - self.menuBtnView.height - self.toolView.height - 64)

//#define  LMNavHeight (([[NSString deviceString] isEqualToString: @"iPhone 4S"])? 64 :0)

#import "LMCourseIntroViewController.h"
#import "LMSchoolIntroViewController.h"
#import "LMReserveViewController.h"
#import "LMMapViewController.h"
#import "AFNetworking.h"
#import "LMCourseInfo.h"
#import "LMTeacherInfo.h"
#import "LMCourseList.h"
#import "LMTeachList.h"
#import "LMTeachListTableViewController.h"
#import "UMSocial.h"
#import "LMTeacherIntroViewController.h"
#import "ACETelPrompt.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AESenAndDe.h"
#import "MBProgressHUD+NJ.h"
#import "CLProgressHUD.h"
#import "LMLoginViewController.h"
#import "LMAddRecommendViewController.h"
#import "LMDetailRecommendViewController.h"

#import "LMRecommend.h"
#import "LMRecommedFrame.h"
#import "LMDetailRecommendViewCell.h"

#import "LMOnerRecViewController.h"
#import "TQStarRatingDisplayView.h"

#import "LMMenuButtonView.h"
#import "LMTResultViewController.h"
#import "LMCourseDetailViewController.h"


@interface LMCourseIntroViewController ()<UIScrollViewDelegate,LMTeachListTableViewControllerDelegate,LMMenuButtonViewDelegate>


/** 老师列表数组 */
@property (nonatomic, strong) NSArray *teachers;

@property (nonatomic, strong) NSMutableDictionary *courseInfos;
/** 课程名称 */
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
/** 类型 */
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
/** 适合学生 */
@property (weak, nonatomic) IBOutlet UILabel *propStuLabel;
/** 课程图片 */
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
/** 学校名称 */
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
/** 滚动视图 */
@property (nonatomic, weak) UIScrollView *scrollView;
//头部数据
@property (weak, nonatomic) IBOutlet UIView *headView;
/** 老师列表控制器 */
@property (nonatomic, strong)  LMTeachListTableViewController *tl;

@property (nonatomic, strong) NSMutableArray *courseInfoDic;

/** 学校id */
@property (nonatomic, assign) long long  schoolId;

/** 老师id */
@property (nonatomic, assign) long long teacherId;

/** 电话 */
@property (copy, nonatomic) NSString *phoneNum;

/** 地址 */
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (copy, nonatomic) NSString *gps;

@property (strong, nonatomic) IBOutlet UIView *toolView;


@property (nonatomic, strong) NSMutableArray *recomFrames;

@property (strong, nonatomic) IBOutlet UIView *recHeadView;

@property (strong, nonatomic) IBOutlet UIView *recFootView;

@property (nonatomic, strong) LMOnerRecViewController *onerRv;
/** 学校简图 */
@property (strong, nonatomic) IBOutlet UIView *schoolSkin;

@property (weak, nonatomic) IBOutlet UIImageView *schoolIcon;
@property (weak, nonatomic) IBOutlet UILabel *level;

@property (weak, nonatomic) IBOutlet UILabel *level1;

@property (weak, nonatomic) IBOutlet UILabel *level2;

@property (weak, nonatomic) IBOutlet UILabel *level3;

@property (weak, nonatomic) IBOutlet UILabel *parentRec;

@property (weak, nonatomic) IBOutlet UIButton *writeRecBtn;
@property (nonatomic, strong) NSDictionary *courseScoreDic;

@property (weak, nonatomic) IBOutlet UIButton *freeListen;

@property (copy, nonatomic) NSString *courseImageUrl;


/** 菜单按钮的view */
@property (nonatomic, weak) LMMenuButtonView *menuBtnView;
/** 主视图的底部ScrollView */
@property (nonatomic, strong) UIScrollView *myScrollView;


@end

@implementation LMCourseIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    [self.view addSubview:self.toolView];
    
    //重写返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"public_nav_black" target:self sel:@selector(goBack)];
    
    
    self.toolView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.toolView.height , self.view.width, self.toolView.height);
    
}

- (void)goBack
{
    [self.scrollView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"课程简介";
    
    [self.writeRecBtn setTitleColor:UIColorFromRGB(0x9ac72c) forState:UIControlStateNormal];
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnerRecViewControllerChange:) name:@"OneRecNotification" object:nil];
    
    
    
    //添加分享,收藏
//    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_collect_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(collection)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
//    self.navigationItem.rightBarButtonItems = @[item1,item0];
    self.navigationItem.rightBarButtonItem = item1;
    
   
    /** 整个scrollView */
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.tag = 11;
    scrollView.frame = CGRectMake(0, 0, self.view.width,self.view.height - self.toolView.height);
  
    scrollView.contentSize = CGSizeMake(self.view.width,1200 );//
    scrollView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    
    scrollView.bounces = NO;
    
    [scrollView addSubview:self.headView];
    
    
    //添加点评页面
    LMOnerRecViewController *onerRv  = [[LMOnerRecViewController alloc] init];
    self.onerRv = onerRv;
    onerRv.view.x = 0;
    onerRv.view.y = CGRectGetMaxY(self.headView.frame) + LMCourseMark;
    onerRv.view.width = self.view.width;
    
    onerRv.tableView.tableHeaderView = self.recHeadView;
    onerRv.tableView.tableFooterView = self.recFootView;
    
    [self.scrollView addSubview:onerRv.view];
    
    self.onerRv.view.height = 88 ;
    
    self.schoolSkin.y = CGRectGetMaxY(self.onerRv.view.frame) + LMCourseMark;
    [self.scrollView addSubview: self.schoolSkin];

  
    [self loadRecommendData];

    [self loadData];
    
    
    
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
    LMMenuButtonView *titleBtnView = [[LMMenuButtonView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) titleArr:@[@"课程详情",@"教学成果",@"老师信息"]];
    self.menuBtnView = titleBtnView;
    // 设置代理
    self.menuBtnView.delegate = self;
    
    // 设置frame
    self.menuBtnView.x = 0;
    self.menuBtnView.width = self.view.width;
    self.menuBtnView.height = 44;
    self.menuBtnView.y = CGRectGetMaxY(self.schoolSkin.frame) + LMCourseMark;
    
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
    //课程详情控制器
    LMCourseDetailViewController *cv = [[LMCourseDetailViewController alloc] init];
    cv.id = self.id;
    [self.myScrollView addSubview:cv.view];
    cv.view.x = 0;
    [self addChildViewController:cv];
    
   
    
    //教学成果控制器
    LMTResultViewController *trv = [[LMTResultViewController alloc] init];
    trv.id = self.id;
    [self.myScrollView addSubview:trv.view];
    trv.view.x = CGRectGetMaxX(cv.view.frame);
    [self addChildViewController:trv];
    
    
    //老师信息控制器
    LMTeachListTableViewController *tv = [[LMTeachListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.tl = tv;
    tv.delegate = self;
    [self addChildViewController:tv];
    [self.myScrollView addSubview:tv.tableView];
    tv.tableView.x = CGRectGetMaxX(trv.view.frame);
    tv.tableView.y = 0;
    tv.tableView.height = LMMyScrollMarkHeight;
    [self addChildViewController:tv];
  
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

   if(scrollView.tag == 12)
   {
        int x = scrollView.contentOffset.x;
        
         int i = x / (self.view.width) + 0.5;
        self.menuBtnView.i = i;
        MyLog(@"scrollVieweeeeeeeeeeeee===%d",i);
        
        CGFloat progress = x / (2 * self.view.width);
         self.menuBtnView.progress = progress;
   }

}



/** 提醒按钮,覆盖在免费预约试听 */
- (IBAction)tip:(id)sender {
    
    UILabel *label = [[UILabel alloc] init];
    label.width = 220;
    label.height = 40;
    label.centerX = self.view.centerX;
    label.y = self.view.height - 150;
    
    label.text = @"此课程不支持预约试听";
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
        [UIView animateWithDuration:0.5 animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
}




- (void)collection
{
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"favorite/favCourse.json"];
        
        
        //参数
        NSMutableDictionary *arr = [NSMutableDictionary dictionary];
        arr[@"id"] = [NSString stringWithFormat:@"%lli",self.id];
        arr[@"time"] = [NSString timeNow];
        MyLog(@"time===%@",[NSString timeNow]);
        
        NSString *jsonStr = [arr JSONString];
        MyLog(@"%@",jsonStr);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"sid"] = account.sid;
        parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            LogObj(responseObject);
            
            long long code = [responseObject[@"code"] longLongValue];
            
            switch (code) {
                case 10001:
                [MBProgressHUD showSuccess:@"收藏成功"];
                break;
                
                case 30002:
                [MBProgressHUD showError:@"用户未登录或超时"];
                break;
                
                case 63001:
                [MBProgressHUD showError:@"用户已收藏"];
                break;
                
                default:
                [MBProgressHUD showError:@"服务器异常,收藏失败"];
                break;
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
        }];
    } else
    {
    
        LMLoginViewController *lg = [[LMLoginViewController alloc] init];
        [self.navigationController pushViewController:lg animated:YES];
    
    }
    

}

- (void)share
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.manytu.com/m/courseDetail.html?id=%lli",_id];

    
    NSString *text = nil;
    if (self.needBook) {
        text = [NSString stringWithFormat:@"免费试听来啦，快来多学预约试%@学校的%@吧",self.schoolNameLabel.text,self.courseNameLabel.text];
    }else
    {
        text = [NSString stringWithFormat:@"孩子素质如何提升？快来多学了解一下%@学校的%@吧",self.schoolNameLabel.text,self.courseNameLabel.text];
    }

    UIImage *image = self.courseImageView.image;
    
    NSArray *names = @[UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToRenren, UMShareToEmail, UMShareToSms];

//    弹出分享页面
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAppKey shareText:text shareImage:image shareToSnsNames:names delegate:self];
    
    
    NSString *text1 = nil;
    if (self.needBook) {
        text1 = [NSString stringWithFormat:@"#%@课程#免费试听来啦，快来多学预约试%@学校的%@吧。 %@ ",self.typeNameLabel.text,self.schoolNameLabel.text,self.courseNameLabel.text,urlStr];
    }else
    {
        text1 = [NSString stringWithFormat:@"#%@课程#如何提升孩子综合素质？快来多学了解一下%@学校的%@吧。 %@",self.typeNameLabel.text,self.schoolNameLabel.text,self.courseNameLabel.text,urlStr];
    }
    [UMSocialData defaultData].extConfig.sinaData.shareText = text1;
    
    
    //微信
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr;
    [UMSocialData defaultData].extConfig.qqData.url = urlStr;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlStr;
     
    
}



- (void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"course/info.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
    
    NSString *jsonStr = [arr JSONString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    

        NSDictionary *dataDic = [responseObject[@"data"] objectFromJSONString];

        MyLog(@"=============请求结果===============%@",dataDic);
        
        /** 取出课程列表字典 */
        NSDictionary * courseInfoDic = dataDic[@"course"];
        
        /** 取出学校id */
        self.schoolId = [courseInfoDic[@"schoolId"] longLongValue];
        
        self.address.text = courseInfoDic[@"address"];
        
        self.gps = courseInfoDic[@"gps"];
    
        self.phoneNum  = courseInfoDic[@"schoolPhone"];
        
        self.needBook = [courseInfoDic[@"needBook"] intValue];
     
        
            
        self.courseNameLabel.text = courseInfoDic[@"courseName"];
        
        self.typeNameLabel.text = courseInfoDic[@"secondTypeName"];
        
        
            
        int ageStart = [courseInfoDic[@"propAgeStart"] intValue];
        int ageEnd = [courseInfoDic[@"propAgeEnd"]intValue];
        self.propStuLabel.text = [NSString stringWithFormat:@"%@",[NSString ageBegin:ageStart ageEnd:ageEnd]];
        
   
//            self.courseTime.text = [NSString stringWithFormat:@"共%d课时",[courseInfoDic[@"courseTime"] intValue]];
        
            self.schoolNameLabel.text = courseInfoDic[@"schoolFullName"];
            
            
            NSString *str = courseInfoDic[@"courseImage"];
        
            self.courseImageUrl = str;
        
            if([str isKindOfClass:[NSString class]])
            {
                NSURL *url = [NSURL URLWithString:str];
                [self.courseImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"380,210"]];
                
            }
        
            NSString *str2 = courseInfoDic[@"school"][@"schoolImage"];
        self.courseImageView.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
        self.courseImageView.layer.borderWidth = 1.0f;
        
        if([str2 isKindOfClass:[NSString class]])
        {
            [self.schoolIcon sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"380,210"]];
        }else
        {
            self.schoolIcon.image = [UIImage imageNamed:@"380,210"];
        }
        self.schoolIcon.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
        self.schoolIcon.layer.borderWidth = 1.0f;
        
        if(!self.needBook)
        {
            self.freeListen.enabled = NO;
        }
        
        /** 课程评分 */
        self.courseScoreDic = courseInfoDic[@"courseCommentLevel"];
        MyLog(@"self.courseScoreDic===%@",self.courseScoreDic);
        
         /** 学校评分 */
        NSDictionary *schoolCommentLevel  = courseInfoDic[@"schoolCommentLevel"];
        self.level.text = schoolCommentLevel[@"avgLevel1"];
        self.level1.text = schoolCommentLevel[@"avgLevel2"];
        self.level2.text = schoolCommentLevel[@"avgLevel3"];
        self.level3.text = schoolCommentLevel[@"avgLevel4"];
        
        TQStarRatingDisplayView *star = [[TQStarRatingDisplayView alloc] initWithFrame:CGRectMake(75,34,90,14) numberOfStar:5 norImage:@"public_review_small_normal" highImage:@"public_review_small_pressed" starSize:14 margin:5 score:schoolCommentLevel[@"avgTotalLevel"]];
        [self.schoolSkin addSubview:star];
       
        [CLProgressHUD dismiss];
        
        MyLog(@"courseInfoDicname===%@",courseInfoDic[@"teachers"]);
        /** 刷新老师 */
        self.teachers = [LMTeacherInfo objectArrayWithKeyValuesArray:courseInfoDic[@"teachers"]];
        MyLog(@"self.teachers===%@",self.teachers);
        self.tl.teachers = self.teachers;
        [self.tl.tableView reloadData];
        
        
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
    
}


- (void)loadRecommendData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/list.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
    arr[@"type"] = @"1";
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
        
        self.onerRv.recomFrames = self.recomFrames;
        
        [self.onerRv.tableView reloadData];
        
        
        
        if (self.recomFrames.count ==  0) {
            
            self.onerRv.view.height = 88 ;
            
            self.schoolSkin.y = CGRectGetMaxY(self.onerRv.view.frame) + LMCourseMark;
            
             self.menuBtnView.y = CGRectGetMaxY(self.schoolSkin.frame) + LMCourseMark;
            
            self.myScrollView.y = CGRectGetMaxY(self.menuBtnView.frame);
            
            self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.menuBtnView.frame) + LMMyScrollMarkHeight);
        }
 
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}


//监听课程点评高度变化
- (void)OnerRecViewControllerChange:(NSNotification *)notifi
{
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat height = [userInfo[@"cellHeight"] doubleValue];
    

    MyLog(@"height===%f",height);
    
    self.onerRv.view.height = 88 + height;
    
    self.schoolSkin.y = CGRectGetMaxY(self.onerRv.view.frame) + LMCourseMark;
    
    self.menuBtnView.y = CGRectGetMaxY(self.schoolSkin.frame) + LMCourseMark;
    
    self.myScrollView.y = CGRectGetMaxY(self.menuBtnView.frame);
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.menuBtnView.frame) + LMMyScrollMarkHeight);
}                        


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
  
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

/** 课程预定 */
- (IBAction)bookCourse:(id)sender {
    
   
        LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
        if (account) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            
            //url地址
            NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"appointment/bookCourse.json"];
            
            
            //参数
            NSMutableDictionary *arr = [NSMutableDictionary dictionary];
            arr[@"id"] = [NSString stringWithFormat:@"%lli",self.id];
            arr[@"time"] = [NSString timeNow];
            
            NSString *jsonStr = [arr JSONString];
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"sid"] = account.sid;
            parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                long long code = [responseObject[@"code"] longLongValue];
                
                switch (code) {
                    case 10001:
                        [MBProgressHUD showSuccess:@"收藏成功"];
                        break;
                        
                    case 30002:
                        [MBProgressHUD showError:@"登录超时"];
                        break;
                        
                    case 63001:
                        [MBProgressHUD showError:@"用户已收藏"];
                        break;
                        
                    default:
                        break;
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LogObj(error.localizedDescription);
            }];
        } else
        {
            
            LMLoginViewController *lg = [[LMLoginViewController alloc] init];
            [self.navigationController pushViewController:lg animated:YES];
            
        }

    
    
}

/** 写点评 */
- (IBAction)recommend:(id)sender {
    
    LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    if (account) {
        LMAddRecommendViewController *add = [[LMAddRecommendViewController alloc] init];
        
        add.id = self.id;
        
        [self.navigationController pushViewController:add animated:YES];
    }else
    {
        LMLoginViewController *log = [[LMLoginViewController alloc] init];
        [self.navigationController pushViewController:log animated:YES];
    }
    
    
    
}

/** 查看点评 */
- (IBAction)lookRecommend:(id)sender {
    
    if(self.recomFrames.count)
    {
        LMDetailRecommendViewController *dv = [[LMDetailRecommendViewController alloc] init];
        dv.id = _id;
        dv.type = 1;
        dv.mainTitle = self.courseNameLabel.text;
        dv.courseScoreDic = self.courseScoreDic;
        [self.navigationController pushViewController:dv animated:YES];
    }
    
}



/** 跳转地图页面 */
- (IBAction)mapClick:(id)sender {
    LMMapViewController *lm = [[LMMapViewController alloc] init];
    lm.gps = self.gps;
    lm.address = self.address.text;
    
    [self presentViewController:lm animated:YES completion:nil];
    
}


/** 跳转学校介绍页面 */
- (IBAction)schoolIntroBtn:(id)sender {
    LMSchoolIntroViewController *si = [[LMSchoolIntroViewController alloc] init];
    si.secondTypeName = self.typeNameLabel.text;
    si.title = @"学校信息";
    si.id = self.schoolId;
   
    
    [self.navigationController pushViewController:si animated:YES];
}

/** 跳转老师介绍页面 */
- (void)teachListTableViewController:(LMTeachListTableViewController *)teachListTableViewController teacherId:(long long)teacherId
{
    LMTeacherIntroViewController *teach = [[LMTeacherIntroViewController alloc] init];
    teach.id = teacherId;
    
    [self.navigationController pushViewController:teach animated:YES];
}
/** 电话 */
- (IBAction)call:(id)sender {
    
    if (self.phoneNum.length) {
        
        [ACETelPrompt callPhoneNumber:self.phoneNum call:^(NSTimeInterval duration) {
            
        } cancel:^{
            
        }];
    }
    
}

/** 预约按钮 */
- (IBAction)reserveBtn:(id)sender {
    
    
    if(self.needBook)
    {
    
        LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
        if (account) {
       
            LMReserveViewController *rvc = [[LMReserveViewController alloc] init];
            rvc.id = self.id;
            rvc.from = FromCourse;
            rvc.title = @"预约免费试听";
            rvc.schoolName = self.schoolNameLabel.text;
            rvc.courseName = self.courseNameLabel.text;
            [self.navigationController pushViewController:rvc animated:YES];
        }else
        {
            LMLoginViewController *lv = [[LMLoginViewController alloc] init];
            
            [self.navigationController pushViewController:lv animated:YES];
        }
    
    }else
    {
        
        UILabel *label = [[UILabel alloc] init];
        label.width = 220;
        label.height = 40;
        label.centerX = self.view.centerX;
        label.y = self.view.height - 150;
        
        label.text = @"此课程不支持预约试听";
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
            [UIView animateWithDuration:0.5 animations:^{
                label.alpha = 0;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        }];

    }
    
}


/** 懒加载 */
- (NSMutableDictionary *)courseInfos
{
    if (_courseInfos == nil) {
        _courseInfos = [NSMutableDictionary dictionary];
    }
    return _courseInfos;
}

- (NSMutableArray *)courseInfoDic
{
    if (_courseInfoDic == nil) {
        _courseInfoDic = [NSMutableArray array];
    }
    return _courseInfoDic;
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
        _myScrollView.tag = 12;
        [self.scrollView addSubview:self.myScrollView];
    }
    return _myScrollView;
}

//- (void)setupMyScrollView
//{
//    CGFloat y = CGRectGetMaxY(self.menuBtnView.frame);
//    CGFloat w = self.view.width;
//    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, w, LMMyScrollMarkHeight)];
//    self.myScrollView = myScrollView;
//    myScrollView.tag = 12;
//    [self.scrollView addSubview:self.myScrollView];
//}


@end
