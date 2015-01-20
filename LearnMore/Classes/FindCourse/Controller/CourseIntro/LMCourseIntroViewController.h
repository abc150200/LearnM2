//
//  LMCourseIntroViewController.h
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCourseInfo;

@interface LMCourseIntroViewController : UIViewController

/** 课程的id */
@property (nonatomic, assign) long long  id;
@property (nonatomic, strong) LMCourseInfo *courseInfo;
@property (nonatomic, assign) int needBook;
@end
