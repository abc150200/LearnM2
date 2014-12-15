//
//  LMTeachDetailViewController.m
//  切换标签Demo
//
//  Created by study on 14-12-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMMyScrollMarkHeight  ([UIScreen mainScreen].bounds.size.height - 44 - 45 - 64)

#import "LMTResultViewController.h"

@interface LMTResultViewController ()
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation LMTResultViewController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, LMMyScrollMarkHeight)];
    self.webView = webView;
    self.view = webView;
    self.view.height = webView.height;
    
    self.webView.scrollView.bounces = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/course_achieve.html?id=%lli",_id];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    
}



@end
