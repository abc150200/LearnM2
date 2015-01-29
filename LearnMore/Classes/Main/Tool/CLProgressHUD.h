//
//  LMLoading.h
//  LearnMore
//
//  Created by study on 15-1-29.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLProgressHUD : UIView
+ (instancetype)shareInstance;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view withText:(NSString *)text;
+ (void)dismiss;
@end
