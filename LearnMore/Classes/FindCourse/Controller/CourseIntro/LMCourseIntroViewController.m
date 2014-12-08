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
#import "HTMLParser.h"
#import "FDLabelView.h"
#import <MediaPlayer/MediaPlayer.h>
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


@interface LMCourseIntroViewController ()<UIScrollViewDelegate,LMTeachListTableViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;

/** 老师列表数组 */
@property (nonatomic, strong) NSArray *teachers;

@property (nonatomic, strong) NSMutableDictionary *courseInfos;
/** 课程名称 */
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
/** 类型 */
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
/** 适合学生 */
@property (weak, nonatomic) IBOutlet UILabel *propStuLabel;
/** 课时 */
@property (weak, nonatomic) IBOutlet UILabel *courseTime;
/** 每节课费用 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 课程图片 */
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
/** 学校名称 */
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
/** 滚动视图 */
@property (nonatomic, weak) UIScrollView *scrollView;
//头部数据
@property (weak, nonatomic) IBOutlet UIView *headView;
//尾部数据
@property (strong, nonatomic) IBOutlet UIView *footView;
/** 课程详情 */
@property (nonatomic, weak) UIView *courseView;
/** 教学成果 */
@property (nonatomic, weak) UIView *resultView;
/** 老师列表 */
@property (nonatomic, weak) UIView *teacherView;
/** 老师列表控制器 */
@property (nonatomic, strong)  LMTeachListTableViewController *tl;
/** 课程详情View */
@property (nonatomic, weak) UIView *htmlView;
/** 教学成果View */
@property (nonatomic, weak) UIView *htmlView2;
/** 课程详情的高度 */
@property (nonatomic, assign) CGFloat currentY;
/** 教学成果的高度 */
@property (nonatomic, assign) CGFloat currentY2;

@property (nonatomic, strong) NSMutableArray *courseInfoDic;

/** 学校id */
@property (nonatomic, assign) long long  schoolId;

/** 老师id */
@property (nonatomic, assign) long long teacherId;

/** 教学成果字符串 */
@property (copy, nonatomic) NSString *teachStr;

/** 电话 */
@property (copy, nonatomic) NSString *phoneNum;

//@property (nonatomic, weak) TFIndicatorView *indicator;
/** 地址 */
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (copy, nonatomic) NSString *gps;

@property (strong, nonatomic) IBOutlet UIView *toolView;

@property (copy, nonatomic) NSString *stri;


@property (copy, nonatomic) NSString *html2;



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

@property (nonatomic, strong) NSDictionary *courseScoreDic;
@end

@implementation LMCourseIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"课程简介";
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
    
 
    
    //添加分享,收藏
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_collect_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(collection)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    self.navigationItem.rightBarButtonItems = @[item1,item0];
    
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://www.manytu.com/m/courseDetail.html?id=%lli",_id];
    
   
    
   
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.width,self.view.height);
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
    onerRv.view.y = CGRectGetMaxY(self.headView.frame) + 20;
    onerRv.view.width = self.view.width;
    
    onerRv.tableView.tableHeaderView = self.recHeadView;
    onerRv.tableView.tableFooterView = self.recFootView;
    
    [self.scrollView addSubview:onerRv.view];
    
    self.onerRv.view.height = 88 ;
    
    self.schoolSkin.y = CGRectGetMaxY(self.onerRv.view.frame) + 20;
    [self.scrollView addSubview: self.schoolSkin];
    
    self.courseView.y = CGRectGetMaxY(self.schoolSkin.frame) + 20;
    
    [self loadRecommendData];

    //添加几个详情页面
    [self setupDetail];
 
    [self loadData];
    
   
    
    
}



//添加几个详情页面
- (void)setupDetail
{
    /** 课程详情 */
    UIView *courseView = [[UIView alloc] init];
    courseView.x = 0;
    courseView.y = CGRectGetMaxY(self.schoolSkin.frame) + LMPadding;
    courseView.width = self.view.width;
    courseView.height = 200;
    courseView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:courseView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LMLeftPadding, 0, 60, 40)];
    titleLabel.text = @"课程详情";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [courseView addSubview:titleLabel];
    
    UIView *divider  = [[UIView alloc] initWithFrame:CGRectMake(LMLeftPadding, 44, self.view.width - LMLeftPadding, 1)];
    divider.backgroundColor = [UIColor grayColor];
    [courseView addSubview:divider];
    
    
    UIView *htmlView = [[UIView alloc]init];
    htmlView.x = 0;
    htmlView.y = 44 + 1 + 5 ;
    htmlView.width = self.view.width;
    htmlView.height = 200;
    _htmlView = htmlView;
    
    [courseView addSubview:htmlView];
    self.courseView = courseView;
    
    
    /** 教学成果 */
    UIView *resultView = [[UIView alloc] init];
    resultView.x = 0;
    resultView.y = CGRectGetMaxY(self.courseView.frame) + LMPadding;
    resultView.width = self.view.width;
    resultView.height = 200;
    resultView.backgroundColor = [UIColor whiteColor];

    [self.scrollView addSubview:resultView];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(LMLeftPadding, 0, 60, 40)];
    titleLabel2.text = @"教学成果";
    titleLabel2.textColor = [UIColor blackColor];
    titleLabel2.font = [UIFont systemFontOfSize:15];
    [resultView addSubview:titleLabel2];
    
    UIView *divider2  = [[UIView alloc] initWithFrame:CGRectMake(LMLeftPadding, 44, self.view.width - LMLeftPadding, 1)];
    divider2.backgroundColor = [UIColor grayColor];
    [resultView addSubview:divider2];
    
    UIView *htmlView2 = [[UIView alloc]init];
    htmlView2.x = 0;
    htmlView2.y = 44 + 1 + 5 ;
    htmlView2.width = self.view.width - 2 * LMLeftPadding;
    htmlView2.height = 130;
    _htmlView2 = htmlView2;
    
    [resultView addSubview:htmlView2];
    self.resultView = resultView;

     /**任课教师*/
    UIView *teacherView = [[UIView alloc] init];
    teacherView.x = 0;
    teacherView.y = CGRectGetMaxY(self.resultView.frame) + LMPadding;
    teacherView.width = self.view.width;
    teacherView.height = 350;
    teacherView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:teacherView];
    
    UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(LMLeftPadding, 0, 60, 40)];
    titleLabel3.text = @"任课老师";
    titleLabel3.textColor = [UIColor blackColor];
    titleLabel3.font = [UIFont systemFontOfSize:15];
    [teacherView addSubview:titleLabel3];
    
    UIView *divider3  = [[UIView alloc] initWithFrame:CGRectMake(LMLeftPadding, 44, self.view.width - LMLeftPadding, 1)];
    divider3.backgroundColor = [UIColor grayColor];
    [teacherView addSubview:divider3];
    
    LMTeachListTableViewController *tl = [[LMTeachListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    tl.delegate  = self;
    self.tl = tl;
    tl.view.x = 0;
    tl.view.y = divider3.y + 1;
    tl.view.width = self.view.width;
    
    [teacherView addSubview:tl.view];
    self.teacherView = teacherView;


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
    NSString *text = @"多学课程分享";
    UIImage *image = [UIImage imageNamed:@"logo96,96"];
    NSArray *names = @[UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToRenren, UMShareToEmail, UMShareToSms];
    
//    弹出分享页面
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAppKey shareText:text shareImage:image shareToSnsNames:names delegate:self];
    

    if (self.needBook) {
        [self.toolView removeFromSuperview];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.toolView];
            self.toolView.frame = CGRectMake(0, self.view.height - self.toolView.height, self.view.width, self.toolView.height);
            
        });
    }
    

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
        
        /** 判断价格 */
        if(([courseInfoDic[@"showPerPrice"] intValue] == 0) && ([courseInfoDic[@"showPackagePrice"] intValue] == 0) )
        {
            self.priceLabel.text = @"价格面议";
        }else if (([courseInfoDic[@"showPerPrice"] intValue] == 1) && ([courseInfoDic[@"showPackagePrice"] intValue] == 0))
        {
            self.priceLabel.text = [NSString stringWithFormat:@"%d元/小时",[courseInfoDic[@"perPrice"] intValue]];
        }else
        {
            self.priceLabel.text = [NSString stringWithFormat:@"共%d元",[courseInfoDic[@"packagePrice"] intValue]];
        }
        
        
            self.courseTime.text = [NSString stringWithFormat:@"共%d课时",[courseInfoDic[@"courseTime"] intValue]];
            
            self.schoolNameLabel.text = courseInfoDic[@"schoolFullName"];
            
            
            NSString *str = courseInfoDic[@"courseImage"];
            if([str isKindOfClass:[NSString class]])
            {
                NSURL *url = [NSURL URLWithString:str];
                [self.courseImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"380,210"]];
                
            }
        
            NSString *str2 = courseInfoDic[@"school"][@"schoolImage"];
        if([str2 isKindOfClass:[NSString class]])
        {
            [self.schoolIcon sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"380,210"]];
        }else
        {
            self.schoolIcon.image = [UIImage imageNamed:@"380,210"];
        }
        
        
        
        /** 课程评分 */
        self.courseScoreDic = courseInfoDic[@"courseCommentLevel"];
        MyLog(@"self.courseScoreDic===%@",self.courseScoreDic);
        
         /** 学校评分 */
        NSDictionary *schoolCommentLevel  = courseInfoDic[@"school"][@"schoolCommentLevel"];
        self.level.text = schoolCommentLevel[@"avgLevel1"];
        self.level1.text = schoolCommentLevel[@"avgLevel2"];
        self.level2.text = schoolCommentLevel[@"avgLevel3"];
        self.level3.text = schoolCommentLevel[@"avgLevel4"];
        
        TQStarRatingDisplayView *star = [[TQStarRatingDisplayView alloc] initWithFrame:CGRectMake(75,34,90,14) numberOfStar:5 norImage:@"public_review_small_normal" highImage:@"public_review_small_pressed" starSize:14 margin:5 score:schoolCommentLevel[@"avgTotalLevel"]];
        [self.schoolSkin addSubview:star];
            
       self.stri = courseInfoDic[@"courseDes"];
       
   
        [CLProgressHUD dismiss];
        
        /** 课程详情 */
        NSString *strHtml = courseInfoDic[@"courseDes"];
        [self parseHTMLWithhtmlStr:strHtml];

        
        /** 教学成果 */
        NSString *strHtml2 = courseInfoDic[@"courseAchieve"];
        self.html2 = strHtml2;
        
        MyLog(@"strHtml2===%@",strHtml2);
        MyLog(@"strHtml2.length===%d",strHtml2.length);
        
        if(strHtml2.length)
        {
            [self parse2HTMLWithhtmlStr:strHtml2];
        }else
        {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"暂未录入";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14];
            label.frame = CGRectMake(15, 44, 100, 44);
            [self.resultView addSubview:label];
            self.resultView.height = 44 +_currentY2 + 44;
            self.teacherView.y = CGRectGetMaxY(self.resultView.frame) + LMPadding;
            self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.resultView.frame));
            
        }
        
            
            /** 刷新老师 */
            self.teachers = [LMTeacherInfo objectArrayWithKeyValuesArray:courseInfoDic[@"teachers"]];
            self.tl.teachers = self.teachers;
        
        if (self.teachers.count) {
            
            self.tl.tableView.rowHeight = 70;
            [self.tl.tableView reloadData];
            
            [self.teacherView addSubview:self.tl.view];
            self.teacherView.height = (self.teachers.count) * (self.tl.tableView.rowHeight) + 44;
            
            MyLog(@"%fteacherView高度",self.teacherView.height);
            
            
            LogObj(self.teachers);
            MyLog(@"%d老师个数===",self.teachers.count);
            
            if(self.needBook)
            {
      
                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame) + self.toolView.height + LMNavHeight);
            }else
            {
                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame) + LMNavHeight);
            }
            
            
        }else
        {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"暂未录入";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14];
            label.frame = CGRectMake(15, 44, 100, 44);
            [self.teacherView addSubview:label];
            self.teacherView.height = 44 + 44;
            
            if(self.needBook)
            {
                
                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame) + self.toolView.height + LMNavHeight);
            }else
            {
                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame)+ LMNavHeight);
            }
        }
        
      
        [self.courseView  setNeedsDisplay];
        
        [self.resultView setNeedsDisplay];
        
        [self.teacherView  setNeedsDisplay];
        
        [self.scrollView  setNeedsDisplay];
      

        
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame) + self.toolView.height);
        
        
 
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
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatuChange:) name:@"LoginStatuChangeNotification" object:nil];
    
#warning 是不是应该在前面加上;
        if (self.recomFrames.count ==  0) {
            
            self.onerRv.view.height = 88 ;
            
            self.schoolSkin.y = CGRectGetMaxY(self.onerRv.view.frame) + 20;
            [self.scrollView addSubview: self.schoolSkin];
            
            self.courseView.y = CGRectGetMaxY(self.schoolSkin.frame) + 20;
        }
 
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}

- (void)loginStatuChange:(NSNotification *)notifi
{
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat height = [userInfo[@"cellHeight"] doubleValue];

    MyLog(@"height===%f",height);
    
    self.onerRv.view.height = 88 + height;
    
    self.schoolSkin.y = CGRectGetMaxY(self.onerRv.view.frame) + 20;
    [self.scrollView addSubview: self.schoolSkin];
    
    self.courseView.y = CGRectGetMaxY(self.schoolSkin.frame) + 20;
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



///** 学校点评 */
//- (void)loadSchoolRec
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    
//    //url地址
//    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/list.json"];
//    
//    
//    //参数
//    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
//    arr[@"id"] = [NSString stringWithFormat:@"%lli",self.schoolId];
//    arr[@"type"] = @"3";
//    arr[@"time"] = [NSString timeNow];
//    arr[@"count"] = @"1";
//    
//    NSString *jsonStr = [arr JSONString];
//    MyLog(@"%@",jsonStr);
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"param"] = jsonStr;
//    
//    
//    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        LogObj(responseObject);
//        
//        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
//        MyLog(@"%@",dateDic);
//        
////        NSArray *recomArr = [LMRecommend objectArrayWithKeyValuesArray:dateDic[@"comments"]];
////        NSMutableArray *frameModels = [NSMutableArray arrayWithCapacity:recomArr.count];
////        for (LMRecommend *recom in recomArr) {
////            LMRecommedFrame *recomFrame = [[LMRecommedFrame alloc] init];
////            recomFrame.recommend = recom;
////            [frameModels addObject:recomFrame];
////        }
////        
////        self.recomFrames = frameModels;
////        
////        
////        
////        [self.tableView reloadData];
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        LogObj(error.localizedDescription);
//    }];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    MyLog(@"self.needBook===%d",self.needBook);
    
    if(self.needBook)
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self.toolView];
        self.toolView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.toolView.height , self.view.width, self.toolView.height);
    }
  
    

}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [CLProgressHUD dismiss];
    
    [self.toolView removeFromSuperview];
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

- (IBAction)recommend:(id)sender {
    
    LMAddRecommendViewController *add = [[LMAddRecommendViewController alloc] init];
    
    add.id = self.id;
    
    [self.navigationController pushViewController:add animated:YES];
    
}

- (IBAction)lookRecommend:(id)sender {
    LMDetailRecommendViewController *dv = [[LMDetailRecommendViewController alloc] init];
    dv.id = _id;
    dv.mainTitle = self.courseNameLabel.text;
    dv.courseScoreDic = self.courseScoreDic;
    [self.navigationController pushViewController:dv animated:YES];
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
    LMSchoolIntroViewController *si = [[LMSchoolIntroViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
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


/** 以下两行代码是递归方法 */
- (void)parseAllChildernHtmlNode:(HTMLNode *) inputNode : (NSMutableArray *) array
{
    for (HTMLNode *node in [inputNode children]) {
        [self parseSingleNode:node :array];
    }
}

- (void)parseSingleNode:(HTMLNode *)node : (NSMutableArray *) array
{
    if (node.nodetype == HTMLImageNode) {
        [array addObject:node];
        
    }
    
    if (node.nodetype == HTMLTextNode) {
        [array addObject:node];
    }
    
    [self parseAllChildernHtmlNode:node :array];
}


//解析Html
- (void)parseHTMLWithhtmlStr:(NSString *)htmlStr
{
    NSString  *html = [htmlStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        MyLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSMutableArray *result = [NSMutableArray array];
    [self parseAllChildernHtmlNode:bodyNode : result];
    
    int i = 0;
    for (HTMLNode *node in result) {
        if (node.nodetype == HTMLImageNode) {
            MyLog(@"i = %d",i++);
                [self addSubImageView:[node getAttributeNamed:@"src"]];
       
        }
        
        if (node.nodetype == HTMLTextNode) {
        
            NSString *text = [node.rawContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            if (text.length > 0) {
    
                   [self addSubText:text];
       
            }
            
        }
        
    }
    
}

//添加图片
- (void)addSubImageView:(NSString *)imageURL {
  MyLog(@"_current---- = %f",_currentY);
    __block UIImage *img;

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
    
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat height = (self.view.frame.size.width-30)/img.size.width * img.size.height;
            CGRect rect = CGRectMake(15, _currentY, self.view.frame.size.width-30, height);
            _currentY += height + 10;
            _htmlView.size = CGSizeMake(self.view.size.width, _currentY);
            MyLog(@"_currentxxxxx = %f",_currentY);
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
            [imageView setImage:img];
            CALayer *layer=[imageView layer];
            [layer setMasksToBounds:YES];
            [layer setCornerRadius:10.0];
            [layer setBorderWidth:1];
            [layer setBorderColor:[[UIColor blackColor] CGColor]];
            [_htmlView addSubview:imageView];
            self.courseView.height = 44 +_currentY;
            MyLog(@"%f===============_currentY",_currentY);
            //        NSLog(@"%f ---")
            self.resultView.y = CGRectGetMaxY(self.courseView.frame) + LMPadding;
            self.teacherView.y = CGRectGetMaxY(self.resultView.frame) +LMPadding;
            if(self.needBook)
            {
                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame) + self.toolView.height+ LMNavHeight);
            }else
            {
                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame)+ LMNavHeight);
            }
        });
        
    }];

    [queue addOperation:operation1];


}





//添加文本
- (void)addSubText:(NSString *)content {
    
    
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, _currentY, 300, 0)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.00];
    titleView.textColor = [UIColor blackColor];
    titleView.font = [UIFont systemFontOfSize:14];
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.lineHeightScale = 0.80;
    titleView.fixedLineHeight = 20;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [_htmlView addSubview:titleView];
    
    _currentY += titleView.visualTextHeight + 10;
    _htmlView.size = CGSizeMake(self.view.size.width, _currentY);
    
    titleView.debug = NO;
    
    self.courseView.height = 44 +_currentY;
    self.resultView.y = CGRectGetMaxY(self.courseView.frame) + LMPadding;
    self.teacherView.y = CGRectGetMaxY(self.resultView.frame) +LMPadding;
    
    if(self.needBook)
    {
        self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame) + self.toolView.height+ LMNavHeight) ;
    }else
    {
        self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame)+ LMNavHeight);
    }
    
    
}







- (void)parse2HTMLWithhtmlStr:(NSString *)htmlStr
{
    NSString  *html = [htmlStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        MyLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSMutableArray *result = [NSMutableArray array];
    [self parseAllChildernHtmlNode:bodyNode : result];
    
    
    for (HTMLNode *node in result) {
        if (node.nodetype == HTMLImageNode) {
            [self add2SubImageView:[node getAttributeNamed:@"src"]];
        }
        
        if (node.nodetype == HTMLTextNode) {
            
            NSString *text = [node.rawContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            if (text.length > 0) {
                [self add2SubText:text];
            }
            
        }
        
    }
    
}

- (void)add2SubImageView:(NSString *)imageURL {
    
    
    __block UIImage *img;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
    
    CGFloat height = (self.view.frame.size.width-30)/img.size.width * img.size.height;
    CGRect rect = CGRectMake(15, _currentY2, self.view.frame.size.width-30, height);
    _currentY2 += height + 10;
    _htmlView2.size = CGSizeMake(self.view.size.width, _currentY2);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    [imageView setImage:img];
    
    CALayer *layer=[imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
    [_htmlView2 addSubview:imageView];
            
    self.resultView.height = 44 +_currentY2;
    self.teacherView.y = CGRectGetMaxY(self.resultView.frame) +LMPadding;

            if(self.needBook)
            {
                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame) + self.toolView.height+ LMNavHeight);
            }else
            {
                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame)+ LMNavHeight);
            }
            
        });
        
    }];
    

    
    [queue addOperation:operation1];

    
}


//添加文章段落
- (void)add2SubText:(NSString *)content {
    
    
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, _currentY, 300, 0)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.00];
    titleView.textColor = [UIColor blackColor];
    titleView.font = [UIFont systemFontOfSize:14];
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.lineHeightScale = 0.80;
    titleView.fixedLineHeight = 20;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [_htmlView2 addSubview:titleView];
    
    _currentY2 += titleView.visualTextHeight + 10;
    _htmlView2.size = CGSizeMake(self.view.size.width, _currentY2);
    
    titleView.debug = NO;
    
    self.resultView.height = 44 +_currentY2;
    
    self.teacherView.y = CGRectGetMaxY(self.resultView.frame) +LMPadding;

    
    if(self.needBook)
    {
        self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame) + self.toolView.height+ LMNavHeight);
    }else
    {
        self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame)+ LMNavHeight);
    }
}


@end
