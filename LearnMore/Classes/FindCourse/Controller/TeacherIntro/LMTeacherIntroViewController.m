//
//  LMTeacherIntroViewController.m
//  LearnMore
//
//  Created by study on 14-10-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMTeacherMark 20
#define LMViewMovedTime 0.3

#define LMMyScrollMarkHeight  ([UIScreen mainScreen].bounds.size.height - self.menuBtnView.height - 64)

#import "LMTeacherIntroViewController.h"
#import "LMSchoolCourseViewCell.h"
#import "AFNetworking.h"
#import "CLProgressHUD.h"
#import "LMMenuButtonView.h"
#import "LMSchoolDetailViewController.h"
#import "LMTResultViewController.h"
#import "LMTeachCourseViewController.h"
#import "LMTeacherCouse.h"


#import "LMCourseInfo.h"

@interface LMTeacherIntroViewController ()<UIScrollViewDelegate,LMMenuButtonViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *iconView;


@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teacherImageView;

@property (nonatomic, weak) UIScrollView *scrollView;
/** 菜单按钮的view */
@property (nonatomic, weak) LMMenuButtonView *menuBtnView;
/** 主视图的底部ScrollView */
@property (nonatomic, strong) UIScrollView *myScrollView;

/** 老师课程控制器 */
@property (nonatomic, strong) LMTeachCourseViewController *trv;
/** 教师详情控制器 */
@property (nonatomic, strong) LMSchoolDetailViewController *cv;
/** 教学成果控制器 */
@property (nonatomic, strong) LMTResultViewController *tv;

@end

@implementation LMTeacherIntroViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    
    //重写返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"public_nav_black" target:self sel:@selector(goBack)];
    
}

- (void)goBack
{
    [self.scrollView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title  = @"老师简介";
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
    
    
    //创建整个scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.tag = 1111;
    scrollView.frame = CGRectMake(0, 0, self.view.width,self.view.height);
    scrollView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    scrollView.bounces = NO;
    
    [self.scrollView addSubview:self.iconView];
    
    
   self.scrollView.contentSize =  CGSizeMake(self.view.width, CGRectGetMaxY(self.iconView.frame) + LMMyScrollMarkHeight);
    
    
    [self loadInfo];
    
    
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
    LMMenuButtonView *titleBtnView = [[LMMenuButtonView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) titleArr:@[@"老师详情",@"开设课程",@"教学成果"]];
    self.menuBtnView = titleBtnView;
    // 设置代理
    self.menuBtnView.delegate = self;
    
    // 设置frame
    self.menuBtnView.x = 0;
    self.menuBtnView.width = self.view.width;
    self.menuBtnView.height = 44;
    self.menuBtnView.y = CGRectGetMaxY(self.iconView.frame);
    
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
    //教师详情控制器
    LMSchoolDetailViewController *cv = [[LMSchoolDetailViewController alloc] init];
    self.cv = cv;
    cv.urlString =  [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/teacher_des.html?id=%lli",_id];
    [self.myScrollView addSubview:cv.view];
    cv.view.x = 0;
    [self addChildViewController:cv];
    
    
    
    //开设课程控制器
    LMTeachCourseViewController *trv = [[LMTeachCourseViewController alloc] initWithStyle:UITableViewStylePlain];
    self.trv = trv;
    trv.tableView.height = LMMyScrollMarkHeight;
    [self addChildViewController:trv];
    [self.myScrollView addSubview:trv.tableView];
    trv.tableView.y = 0;
    trv.tableView.x = CGRectGetMaxX(cv.view.frame);
    trv.tableView.width = self.view.width;
    trv.tableView.height = LMMyScrollMarkHeight;
    
    MyLog(@"trv.tableView===%@",NSStringFromCGRect(trv.tableView.frame));
    
    
    //教学成果控制器
    LMTResultViewController *tv = [[LMTResultViewController alloc] init];
    self.tv = tv;
    tv.urlString =[NSString stringWithFormat:@"http://www.learnmore.com.cn/m/teacher_achieve.html?id=%lli",_id];
    [self.myScrollView addSubview:tv.view];
    tv.view.x = CGRectGetMaxX(trv.view.frame);
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
    
    if(scrollView.tag == 1112)
    {
        int x = scrollView.contentOffset.x;
        
        int i = x / (self.view.width) + 0.5;
        self.menuBtnView.i = i;
        MyLog(@"scrollVieweaaaaaaaaaaaaa===%d",i);
        
        CGFloat progress = x / (2 * self.view.width);
        self.menuBtnView.progress = progress;
    }
    
    
    
    MyLog(@"self.scrollView.contentOffset.y===%f",self.scrollView.contentOffset.y);
    
    MyLog(@"self.scrollView.caaaaaaat.y===%f",CGRectGetMaxY(self.iconView.frame) - 64);
    
    CGFloat height = CGRectGetMaxY(self.iconView.frame) - 64;
    
    if ((int)self.scrollView.contentOffset.y == (int)height) {
        self.cv.webView.scrollView.scrollEnabled = YES;
        self.trv.tableView.scrollEnabled = YES;
        self.tv.webView.scrollView.scrollEnabled = YES;
    }else
    {
        self.cv.webView.scrollView.scrollEnabled = NO;
        self.trv.tableView.scrollEnabled = NO;
        self.tv.webView.scrollView.scrollEnabled = NO;
    }

    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [CLProgressHUD dismiss];

    
}


- (void)loadInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"teacher/info.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
//    arr[@"id"] = @"10";
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    //设备信息
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        NSDictionary *teacherDic = dateDic[@"teacher"];
        LogObj(teacherDic);
        
        
        if([teacherDic[@"mobile"] length])
        {
            self.phoneNum.text = teacherDic[@"mobile"];
        }else
        {
             self.phoneNum.text = @"暂未录入";
        }
        
        self.teacherNameLabel.text =  teacherDic[@"teacherName"];
            
            [self.teacherImageView sd_setImageWithURL:[NSURL URLWithString:teacherDic[@"teacherImage"]] placeholderImage:[UIImage imageNamed:@"app"]];
            self.teacherImageView.layer.cornerRadius  = 38;
            self.teacherImageView.clipsToBounds = YES;
            
            if([teacherDic[@"schoolName"] isKindOfClass:[NSString class]])
            {
                self.schoolNameLabel.text = teacherDic[@"schoolName"];
            }

        
            [CLProgressHUD dismiss];
        
            
            /** 处理tableView */
            NSArray *courseArr = [LMTeacherCouse objectArrayWithKeyValuesArray:teacherDic[@"courses"]];
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




#pragma mark - 懒加载
- (UIScrollView *)myScrollView
{
    if (_myScrollView == nil) {
        
        // 设置frame
        CGFloat y = CGRectGetMaxY(self.menuBtnView.frame);
        CGFloat w = self.view.width;
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, w, LMMyScrollMarkHeight)];
        LogFrame(_myScrollView);
        _myScrollView.tag = 1112;
        [self.scrollView addSubview:self.myScrollView];
    }
    return _myScrollView;
}








@end
