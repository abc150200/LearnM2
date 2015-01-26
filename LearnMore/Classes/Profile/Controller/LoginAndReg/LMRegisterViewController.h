//
//  LMRegisterViewController.h
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    FromLog,
    FromeOtherVc
}FromeRegVc;


@interface LMRegisterViewController : UIViewController
@property (nonatomic, assign) FromeRegVc from;
@end
