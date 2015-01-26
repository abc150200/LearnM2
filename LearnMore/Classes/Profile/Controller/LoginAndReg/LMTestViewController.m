//
//  LMTestViewController.m
//  LearnMore
//
//  Created by study on 15-1-6.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMTestViewController.h"
#import "LMLoginViewController.h"
#import "LMRegisterViewController.h"

@interface LMTestViewController () <UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation LMTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView = webView;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo.html" ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    [self.webView loadHTMLString:html baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"%@",urlString);
    
    #define customURL @"js-call://"
    
    if ([urlString hasPrefix:customURL]) {
        MyLog(@"进入自定义");
        NSString *content = [urlString substringFromIndex:[customURL length]];
        
        MyLog(@"content===%@",content);
        
        // 4> 定义要调用的方法
        SEL func = NSSelectorFromString(content);
        
        [self performSelector:func];
    
        return NO;
    }
    
    return YES;
}


- (void)login
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everReg"]) {
        LMLoginViewController *lg = [[LMLoginViewController alloc] init];
        lg.from = FromeOther;
        
        [self.navigationController pushViewController:lg animated:YES];
    }else
    {
        LMRegisterViewController *rv = [[LMRegisterViewController alloc] init];
        rv.from = FromeOtherVc;
        [self.navigationController pushViewController:rv animated:YES];
    }
}

@end
