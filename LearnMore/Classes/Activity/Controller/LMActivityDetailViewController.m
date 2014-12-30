//
//  LMActivityDetailViewController.m
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMPadding 20

#import "LMActivityDetailViewController.h"
#import "UMSocial.h"
#import "AFNetworking.h"
#import "LMMapViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LMReserveViewController.h"
#import "ACETelPrompt.h"
#import "CLProgressHUD.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "LMLoginViewController.h"
#import "MTA.h"
#import "MBProgressHUD+NJ.h"
#import "AESenAndDe.h"

@interface LMActivityDetailViewController ()<UIWebViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *actImageView;

@property (weak, nonatomic) IBOutlet UILabel *leastCount;

@property (nonatomic, weak) UIView *htmlView;

@property (nonatomic, assign) CGFloat currentY;

//电话
@property (copy, nonatomic) NSString *phoneNum;
/** 介绍页面 */
@property (nonatomic, weak) UIView *infoView;

@property (copy, nonatomic) NSString *actTitle;
@property (weak, nonatomic) IBOutlet UILabel *actTitleLabel;

@property (nonatomic, weak) UIWebView *webView;

/** 导航栏相关 */
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UIButton *collectBtn;
//@property (nonatomic, strong) UIView *rightBarItemsView ;
@property (nonatomic, weak) UIButton *shareBtn;

/** 底部工具条 */
@property (strong, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UILabel *addrssLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;

/** 地址字典 */
@property (nonatomic, strong) NSMutableArray *arrAddress;

@end

@implementation LMActivityDetailViewController

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
    
    //添加分享,收藏
    UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    self.collectBtn = collectBtn;
    [collectBtn setImage:[UIImage imageNamed:@"public_nav_collect_normal"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collection) forControlEvents:UIControlEventTouchUpInside];
    
#warning 暂时隐藏掉
//    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(38, 0, 34, 34)];
//    self.shareBtn = shareBtn;
//    [shareBtn setImage:[UIImage imageNamed:@"public_nav_share"] forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIView *rightBarItemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 34)];
//    [rightBarItemsView addSubview:collectBtn];
//    [rightBarItemsView addSubview:shareBtn];
//    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarItemsView];
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:rightBarItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    
    /** 加载数据 */
    [self loadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"活动详情";
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
 
    
    [self.view addSubview:self.toolView];
    self.toolView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.toolView.height, self.view.width, self.toolView.height);
    
    /** 添加scrollView */
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    scrollView.x = 0;
#warning 正常情况下是0???
    scrollView.y = 64;
    scrollView.width = self.view.width;
    scrollView.height = [UIScreen mainScreen].bounds.size.height - self.toolView.height - 64;
    self.scrollView = scrollView;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.headView];
 
    scrollView.bounces = NO;

    self.toolView.backgroundColor = UIColorFromRGB(0xf0f0f0);
   
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.x = 0;
    webView.y = CGRectGetMaxY(self.headView.frame) + LMPadding;
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




- (void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"activity/info.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"jsonStr==========%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        parameters[@"sid"] = account.sid;
    }
    
    //设备信息
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
     MyLog(@"parameters===========%@",parameters);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MyLog(@"responseObject===============%@",responseObject);
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"data==============%@",dateDic);
        
        /** 取出活动字典 */
        NSDictionary *actInfoDic = dateDic[@"activity"];
        

            NSString *dateStart = [self timeResultWith:actInfoDic[@"actBeginTime"]];
            NSString *dateEnd = [self timeResultWith:actInfoDic[@"actEndTime"]];
        
            self.actTitle = actInfoDic[@"actTitle"];
            self.actTitleLabel.text = actInfoDic[@"actTitle"];
        
            //收藏
            if ([actInfoDic[@"favStatus"] intValue]) {
                [self.collectBtn setImage:[UIImage imageNamed:@"public_nav_collect_pressed"] forState:UIControlStateNormal];
            }
  
            self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",dateStart,dateEnd];
            
            self.leastCount.text = [NSString stringWithFormat:@"剩余%d名额",([actInfoDic[@"actCount"] intValue] - [actInfoDic[@"actNowCount"] intValue])];
            
            self.phoneNum = actInfoDic[@"contactPhone"];
            
            NSString *str = actInfoDic[@"actImage"];
            if([str isKindOfClass:[NSString class]])
            {
                NSURL *url = [NSURL URLWithString:str];
                
                self.actImageView.layer.masksToBounds = YES;
                [self.actImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"activity"]];
                self.actImageView.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
                self.actImageView.layer.borderWidth = 0.5f;
            }
            
            self.schoolNameLabel.text = actInfoDic[@"schoolName"];
        
         //地址
        NSArray *arr = actInfoDic[@"addrList"];
        if (arr.count == 0) {
            self.addrssLabel.text = @"线上活动";
            self.mapBtn.enabled = NO;
        }else if (arr.count == 1)
        {
            NSDictionary *dic = arr[0];
            self.addrssLabel.text = dic[@"address"];
            NSDictionary *dict3 = @{@"gps":dic[@"gps"],@"address":dic[@"address"]};
            [self.arrAddress addObject:dict3];
        }else
        {
            self.addrssLabel.text = @"多商圈";
        
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dic1 in arr) {
                NSDictionary *dict2 = @{@"gps":dic1[@"gps"],@"address":dic1[@"address"]};
                [arrM addObject:dict2];
            }
            self.arrAddress = arrM;
            
        }
    
        [CLProgressHUD dismiss];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}


- (void)collection
{
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
        self.collectBtn.enabled = NO;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"favorite/favActivity.json"];
        
        
        //参数
        NSMutableDictionary *arr = [NSMutableDictionary dictionary];
        arr[@"id"] = [NSString stringWithFormat:@"%lli",self.id];
        arr[@"time"] = [NSString timeNow];
    
        
        NSString *jsonStr = [arr JSONString];
        MyLog(@"%@",jsonStr);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"sid"] = account.sid;
        parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
        
        //设备信息
        NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
        parameters[@"device"] = deviceInfo;
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            LogObj(responseObject);
            
            long long code = [responseObject[@"code"] longLongValue];
            
            switch (code) {
                case 10001:
                {
                    if ([self.collectBtn.currentImage isEqual:[UIImage imageNamed:@"public_nav_collect_normal"]]) {
                        
                        [MBProgressHUD showSuccess:@"收藏成功"];
                        [self.collectBtn setImage:[UIImage imageNamed:@"public_nav_collect_pressed"] forState:UIControlStateNormal];
                        self.collectBtn.enabled = YES;
                    }else
                    {
                        [MBProgressHUD showSuccess:@"取消收藏"];
                        [self.collectBtn setImage:[UIImage imageNamed:@"public_nav_collect_normal"] forState:UIControlStateNormal];
                        self.collectBtn.enabled = YES;
                    }
                    
                }
                    
                    break;
                    
                case 30002:
                {
                    [MBProgressHUD showError:@"用户未登录或超时"];
                    self.collectBtn.enabled = YES;
                }
                    
                    break;
                    
                case 63001:
                {
                    [MBProgressHUD showError:@"用户已收藏"];
                    self.collectBtn.enabled = YES;
                }
                    
                    break;
                    
                default:
                {
                    [MBProgressHUD showError:@"服务器异常,收藏失败"];
                    self.collectBtn.enabled = YES;
                }
                    
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
- (IBAction)call:(id)sender {
    
    if (self.phoneNum.length) {
        
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
        
        NSString *coId = [NSString stringWithFormat:@"%lli",_id];
        
        LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
        NSDictionary *dict = nil;
        if (account) {
            NSString *sid = account.sid;
            dict = @{@"sid":sid,@"type":@"1",@"id":coId,@"version":version,@"device":deviceInfo};
        }else
        {
            dict = @{@"type":@"1",@"id":coId,@"version":version,@"device":deviceInfo};
        }
        
        
        [MTA trackCustomKeyValueEvent:@"activity_call_record" props:dict];
        
        
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil message:self.phoneNum delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        
        alert.delegate = self;
        [alert show];
    }
}

/** 跳转地图 */
- (IBAction)mapJump:(id)sender {
    
    LMMapViewController *lm = [[LMMapViewController alloc] init];
    

    lm.adressArr = self.arrAddress;
    
    [self presentViewController:lm animated:YES completion:nil];
    
}

/** 时间转化 */
- (NSString *)timeResultWith:(NSString *)parame
{
    long long time = [parame longLongValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    LogObj([fmt stringFromDate:date]);
    return [fmt stringFromDate:date];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *phoneNum = self.phoneNum;
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
        [[UIApplication sharedApplication] openURL:phoneURL];
        
        MyLog(@"name===1");
        
        //拨打电话记录统计
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"commons/phoneCall.json"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
        
        LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
        if (account) {
            parameters[@"sid"] = account.sid;
        }
        parameters[@"type"] = @"1";
        parameters[@"id"] = [NSString stringWithFormat:@"%lli",_id];
        parameters[@"version"] = version;
        parameters[@"device"] = deviceInfo;
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            MyLog(@"responseObject===%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
        }];
        
    }else
    {
        MyLog(@"name===0");
    }
    
}


- (NSMutableArray *)arrAddress
{
    if (_arrAddress == nil) {
        _arrAddress = [NSMutableArray array];
    }
    return _arrAddress;
}


@end
