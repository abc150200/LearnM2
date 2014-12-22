//
//  LMActivityDetailViewController.m
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMActivityDetailViewController.h"
#import "UMSocial.h"
#import "AFNetworking.h"
#import "LMDetailAct.h"
#import "LMMapViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LMReserveViewController.h"
#import "ACETelPrompt.h"
#import "CLProgressHUD.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "LMLoginViewController.h"
#import "MTA.h"

@interface LMActivityDetailViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *actImageView;

@property (weak, nonatomic) IBOutlet UILabel *leastCount;
/** 地址的View */
@property (weak, nonatomic) IBOutlet UIView *addressView;

/** 预留空白 */
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@property (nonatomic, weak) UIView *htmlView;

@property (nonatomic, assign) CGFloat currentY;

//电话
@property (copy, nonatomic) NSString *phoneNum;
/** 介绍页面 */
@property (nonatomic, weak) UIView *infoView;

@property (copy, nonatomic) NSString *actTitle;
@property (weak, nonatomic) IBOutlet UILabel *actTitleLabel;

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation LMActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"活动详情";
    
//    CLProgressHUD *hud = [CLProgressHUD shareInstance];
//    hud.type = CLProgressHUDTypeDarkBackground;
//    hud.shape = CLProgressHUDShapeCircle;
//    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];

#warning 暂时屏蔽
//    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_collect_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(collection)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
//
//    self.navigationItem.rightBarButtonItems = @[item1,item0];
    self.navigationItem.rightBarButtonItem = item1;
    
    
    /** 添加scrollView */
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.x = 0;
    scrollView.y = 0;
    scrollView.width = self.view.width;
    scrollView.height = self.view.height;
    self.scrollView = scrollView;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.headView];
 
    scrollView.bounces = NO;

    
    /** 加载数据 */
    [self loadData];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.x = 0;
    webView.y = CGRectGetMaxY(self.headView.frame);
    webView.width = self.view.width;
    webView.height = 64;
    self.webView = webView;
    
     webView.scrollView.bounces = NO;
    
    [self.scrollView addSubview:webView];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/activity_des.html?id=%lli",_id];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
   
    self.scrollView.contentSize =CGSizeMake(self.view.width,self.view.height);
  
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)dealloc
{
    // 删除观察者
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
     [self.webView sizeToFit];
     self.scrollView.contentSize =CGSizeMake(self.view.width, self.webView.scrollView.contentSize.height + self.headView.height - LMWebViewButton);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [webView sizeToFit];
        
        CGFloat webViewHeight=[webView.scrollView contentSize].height;
        
        MyLog(@"webViewHeight===%f",webViewHeight);
        
//         self.scrollView.contentSize =CGSizeMake(self.view.width, webViewHeight + self.headView.height - 49);
    });

}


- (void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"activity/info.json"];
    
    
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
        MyLog(@"%@",dateDic);
        
        /** 取出活动字典 */
        NSDictionary *actInfoDic = dateDic[@"activity"];
        

            NSString *dateStart = [self timeResultWith:actInfoDic[@"actBeginTime"]];
            NSString *dateEnd = [self timeResultWith:actInfoDic[@"actEndTime"]];
        
            self.actTitle = actInfoDic[@"actTitle"];
            self.actTitleLabel.text = actInfoDic[@"actTitle"];
  
            self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",dateStart,dateEnd];
            
            self.leastCount.text = [NSString stringWithFormat:@"剩余%d名额",([actInfoDic[@"actCount"] intValue] - [actInfoDic[@"actNowCount"] intValue])];
            
            self.phoneNum = actInfoDic[@"contactPhone"];
            
            NSString *str = actInfoDic[@"actImage"];
            if([str isKindOfClass:[NSString class]])
            {
                NSURL *url = [NSURL URLWithString:str];
                
                self.actImageView.layer.masksToBounds = YES;
                [self.actImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"activity"]];
            }
            
            self.schoolNameLabel.text = actInfoDic[@"schoolName"];
    
//        [CLProgressHUD dismiss];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}


- (void)collection
{
    NSLog(@"-------");
}

- (void)share
{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/activityDetail.html?id=%lli&from=singlemessage&isappinstalled=1",_id];
    
    NSString *text = self.actTitle;
    UIImage *image = self.actImageView.image;
    NSArray *names = @[UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToRenren, UMShareToEmail, UMShareToSms];
    
    //弹出分享页面
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAppKey shareText:text shareImage:image shareToSnsNames:names delegate:self];
    
    //weixin标题
    NSString *text1 = [NSString stringWithFormat:@"%@ %@",self.actTitle,urlStr];
    [UMSocialData defaultData].extConfig.sinaData.shareText = text1;
    
    
    //微信
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr;
    [UMSocialData defaultData].extConfig.qqData.url = urlStr;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlStr;
    
    
}
//报名
- (IBAction)book:(id)sender {
    
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
        LMReserveViewController *rv = [[LMReserveViewController alloc] init];
        rv.from = FromeAct;
        rv.id = self.id;
        rv.courseName = self.actTitle;
        rv.schoolName = self.schoolNameLabel.text;
        [self.navigationController pushViewController:rv animated:YES];
        
    }else
    {
        LMLoginViewController *lv = [[LMLoginViewController alloc] init];
        
        [self.navigationController pushViewController:lv animated:YES];
    }
    
   
    
}

//电话
- (IBAction)cll:(id)sender {
    
    if (self.phoneNum.length) {
        
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
        
        LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
        NSString *sid = account.sid;
        NSString *coId = [NSString stringWithFormat:@"%lli",_id];
        NSDictionary *dict = @{@"sid":sid,@"type":@"2",@"id":coId,@"version":version,@"device":deviceInfo};
        
        [MTA trackCustomKeyValueEvent:@"activity_call_record" props:dict];
        
        
        [ACETelPrompt callPhoneNumber:self.phoneNum call:^(NSTimeInterval duration) {
            
        } cancel:^{
            
        }];
    }
}

/** 跳转地图 */
- (IBAction)mapJump:(id)sender {
    
    LMMapViewController *lm = [[LMMapViewController alloc] init];
    
#warning 以后更改
    lm.gps = @"116.307185,39.977783";
    lm.address = @"苏州街长远天地大厦a座";
    
    [self presentViewController:lm animated:YES completion:nil];
    
}

/** 时间转化 */
- (NSString *)timeResultWith:(NSString *)parame
{
    long long time = [parame longLongValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    LogObj([fmt stringFromDate:date]);
    return [fmt stringFromDate:date];
}

@end
