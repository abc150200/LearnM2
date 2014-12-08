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
    // Do any additional setup after loading the view from its nib.
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
