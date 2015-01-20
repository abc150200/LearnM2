//
//  LMSchoolDetailViewController.m
//  LearnMore
//
//  Created by study on 14-12-14.

//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMMyScrollMarkHeight  ([UIScreen mainScreen].bounds.size.height - 44 - 45 - 64)


#import "LMSchoolDetailViewController.h"

@interface LMSchoolDetailViewController ()<UIScrollViewDelegate>



@end

@implementation LMSchoolDetailViewController

- (void)loadView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , LMMyScrollMarkHeight)];
    self.view = self.webView;
    self.view.height = self.webView.height;
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


@end
