//
//  LMTotalCourse.h
//  LearnMore
//
//  Created by study on 14-10-28.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMCourseList;

@interface LMTotalCourse : NSObject

@property (nonatomic, strong) LMCourseList *courseList;
//符合条件的结果总数
@property (nonatomic, assign) int tcount;

@end
