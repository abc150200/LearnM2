//
//  LMTResultViewController.h
//  切换标签Demo
//
//  Created by study on 14-12-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMTResultViewController : UIViewController
@property (nonatomic, assign) long long id;
@property (copy, nonatomic) NSString *urlString;
@property (nonatomic, weak) UIWebView *webView;
@end
