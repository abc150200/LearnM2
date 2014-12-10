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
#import "HTMLParser.h"
#import "FDLabelView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LMReserveViewController.h"
#import "ACETelPrompt.h"
#import "CLProgressHUD.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "LMLoginViewController.h"

@interface LMActivityDetailViewController ()

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
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];

#warning 暂时屏蔽
//    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_collect_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(collection)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
//
//    self.navigationItem.rightBarButtonItems = @[item1,item0];
    self.navigationItem.rightBarButtonItem = item1;
    
    
    
    
//    //在分享代码前设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
//    //UMSocialWXMessageTypeImage 为纯图片类型
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
//    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
//    [UMSocialData defaultData].extConfig.title = @"朋友圈分享内容";
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.learnmore.com.cn";
    
    

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
    

    /** 分享详情 */
    UIView *infoView = [[UIView alloc] init];
    infoView.x = 0;
    infoView.y = self.headView.height;
    infoView.height = self.headView.height;
    infoView.width = self.view.width;
    self.infoView = infoView;
 
    
    UIView *htmlView = [[UIView alloc] init];
    htmlView.x = 0;
    htmlView.y = 10;
    htmlView.width = self.view.width;
    htmlView.height = 300;
    self.htmlView = htmlView;
    [self.infoView addSubview:self.htmlView];
    
  
    /** 加载数据 */
    [self loadData];

    [self.scrollView addSubview:self.infoView];

    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [CLProgressHUD dismiss];

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
    
        [CLProgressHUD dismiss];
        
        //刷新活动介绍
        NSString *htmlStr = actInfoDic[@"actDes"];
        [self parseHTMLWithhtmlStr:htmlStr];
        MyLog(@"%f====",_currentY);
//        self.htmlView.height = _currentY + 10;
//        self.infoView.height = _currentY + 10;
//        self.scrollView.contentSize = CGSizeMake(self.view.width,self.headView.height + _currentY + 10);
        MyLog(@"%@",NSStringFromCGSize(self.scrollView.contentSize));
        
        
        
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
    NSString *urlStr = [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/activity_des.html?id=%lli",_id];
    
    NSString *text = self.actTitle;
    UIImage *image = self.actImageView.image;
    NSArray *names = @[UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToRenren, UMShareToEmail, UMShareToSms];
    
    //弹出分享页面
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAppKey shareText:text shareImage:image shareToSnsNames:names delegate:self];
    
    //weixin标题
    NSString *text1 = [NSString stringWithFormat:@"%@ %@",self.actTitle,urlStr];
    [UMSocialData defaultData].extConfig.sinaData.shareText = text1;
    
    
    //    [UMSocialData defaultData].extConfig.tencentData.shareImage = [UIImage imageNamed:@"icon"]; //分享到腾讯微博图片
    //    [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.baidu.com/img/bdlogo.gif"];
    
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



- (void)parseHTMLWithhtmlStr:(NSString *)htmlStr
{
    NSString  *html = [htmlStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSMutableArray *result = [NSMutableArray array];
    [self parseAllChildernHtmlNode:bodyNode : result];
    
    
    for (HTMLNode *node in result) {
        if (node.nodetype == HTMLImageNode) {
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

- (void)addSubImageView:(NSString *)imageURL {

    
    __block UIImage *img;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 10;
    
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
            self.htmlView.height = _currentY + 10;
            self.infoView.height = _currentY + 10;
            self.scrollView.contentSize = CGSizeMake(self.view.width,self.headView.height + _currentY + 10);
        });
        
    }];
    
    [queue addOperation:operation1];
}




//添加文章段落
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
    
    self.htmlView.height = _currentY + 10;
    self.infoView.height = _currentY + 10;
    self.scrollView.contentSize = CGSizeMake(self.view.width,self.headView.height + _currentY + 10);
    
   
}






@end
