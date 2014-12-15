//
//  LMCourseDetailViewController.m
//  切换标签Demo
//
//  Created by study on 14-12-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMMyScrollMarkHeight  ([UIScreen mainScreen].bounds.size.height - 44 - 45 - 64)

#import "LMCourseDetailViewController.h"



@interface LMCourseDetailViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LMCourseDetailViewController




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
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/course_des.html?id=%lli",_id];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
  
}







@end
