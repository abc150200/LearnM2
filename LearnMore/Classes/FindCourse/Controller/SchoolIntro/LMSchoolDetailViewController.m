//
//  LMSchoolDetailViewController.m
//  LearnMore
//
//  Created by study on 14-12-14.

//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMMyScrollMarkHeight  ([UIScreen mainScreen].bounds.size.height - 44 - 45 - 64)


#import "LMSchoolDetailViewController.h"

@interface LMSchoolDetailViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LMSchoolDetailViewController

- (void)loadView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , LMMyScrollMarkHeight)];
    self.view = self.webView;
    self.view.height = self.webView.height;
    
    self.webView.scrollView.bounces = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    NSString *urlString = [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/school_des.html?id=%lli",_id];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
}


@end
