//
//  LMAboutUsViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMAboutUsViewController.h"
#import "LMFeedbackViewController.h"
#import "MBProgressHUD+NJ.h"


@interface LMAboutUsViewController ()<LMFeedbackViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end

@implementation LMAboutUsViewController

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
    self.title = @"关于我们";
    
    //获取沙盒中的版本号
    NSString *key = (__bridge_transfer NSString *)kCFBundleVersionKey;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [defaults objectForKey:key];
    
    self.desc.text = [NSString stringWithFormat:@"多学 %@",localVersion];
}
- (IBAction)ButtonClick {
    
    LMFeedbackViewController *fv = [[LMFeedbackViewController alloc] init];
    
    fv.delegate = self;
    
    [self.navigationController pushViewController:fv animated:YES];
}

- (void)feedbackViewControllerDidClickButton:(LMFeedbackViewController *)feedbackViewController
{
//    [MBProgressHUD showSuccess:@"提交成功"];
}

@end
