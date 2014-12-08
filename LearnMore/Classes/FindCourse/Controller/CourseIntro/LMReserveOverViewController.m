//
//  LMReserveOverViewController.m
//  LearnMore
//
//  Created by study on 14-11-16.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMReserveOverViewController.h"
#import "LMCourseIntroViewController.h"
#import "UMSocial.h"

@interface LMReserveOverViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (copy, nonatomic) NSString *sexInfo;

@end

@implementation LMReserveOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        self.contentView.layer.cornerRadius = 5;
        self.contentView.clipsToBounds = YES;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://www.learnmore.com.cn/"];
    

    if (self.sex == 1) {
        self.sexInfo = @"男";
    }else
    {
        self.sexInfo = @"女";
    }
    
    self.infoLabel.text = [NSString stringWithFormat:@"    你已经为%@(%@，%d岁)成功预约%@提供的《%@》免费试听。",self.stuName,self.sexInfo, self.age,self.schoolName,self.courseName];
    
    self.contactLabel.text = [NSString stringWithFormat:@"  %@的工作人员会在1-2个工作日内与你确定试听时间。你也可以在《我的-%@》中查看预约试听详情。",self.schoolName,self.setting];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)finish:(id)sender {
   
    NSString *text = @"多学课程分享";
    UIImage *image = [UIImage imageNamed:@"logo96,96"];
    NSArray *names = @[UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToRenren, UMShareToEmail, UMShareToSms];
    
    //    弹出分享页面
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAppKey shareText:text shareImage:image shareToSnsNames:names delegate:self];
}

@end
