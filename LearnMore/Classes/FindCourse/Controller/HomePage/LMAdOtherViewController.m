//
//  LMAdOtherViewController.m
//  LearnMore
//
//  Created by study on 14-12-17.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMAdOtherViewController.h"
#import "AFNetworking.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"

@interface LMAdOtherViewController ()

@end

@implementation LMAdOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight)];
    
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    

}






@end
