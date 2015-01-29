//
//  LMTeachDetailViewController.m
//  切换标签Demo
//
//  Created by study on 14-12-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMMyScrollMarkHeight  ([UIScreen mainScreen].bounds.size.height - 44 - 45 - 64)

#import "LMTResultViewController.h"

@interface LMTResultViewController ()<UIScrollViewDelegate>

@end

@implementation LMTResultViewController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, LMMyScrollMarkHeight)];
    self.webView = webView;
    self.view = webView;
    self.view.height = webView.height;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.bounces = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    MyLog(@"WebViewscrollViewDidScroll===%f",scrollView.contentOffset.y);
    
    
    if(scrollView.contentOffset.y == 0)
    {
        self.webView.scrollView.scrollEnabled = NO;
    }
    else
    {
        self.webView.scrollView.scrollEnabled = YES;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y == 0)
    {
        self.webView.scrollView.scrollEnabled = NO;
    }
    else
    {
        self.webView.scrollView.scrollEnabled = YES;
    }
    
}


@end
