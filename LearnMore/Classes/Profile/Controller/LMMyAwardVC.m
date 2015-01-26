//
//  LMMyAwardVC.m
//  LearnMore
//
//  Created by study on 15-1-12.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMMyAwardVC.h"
#import "LMAccount.h"
#import "LMAccountInfo.h"

@interface LMMyAwardVC ()

@end

@implementation LMMyAwardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:web];
    
    self.title = @"我的奖品";
    
    LMAccount *account =  [LMAccountInfo sharedAccountInfo].account;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/userGift.html?sid=%@",account.sid];
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
}


@end
