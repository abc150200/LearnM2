//
//  LMMyAwardVC.m
//  LearnMore
//
//  Created by study on 15-1-12.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMMyAwardVC.h"

@interface LMMyAwardVC ()

@end

@implementation LMMyAwardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:web];
    
    [web loadHTMLString:@"http://192.168.1.90:8081/uxue_business/login.shtml" baseURL:nil];
    
}


@end
