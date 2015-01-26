//
//  LMLoginViewController.h
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//
typedef enum
{
    FromReg,
    FromeOther
}FromeLogVc;

#import <UIKit/UIKit.h>

@interface LMLoginViewController : UIViewController
@property (nonatomic, assign) FromeLogVc from;
@end
