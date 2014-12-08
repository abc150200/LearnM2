//
//  LMCourseTeachCell.h
//  LearnMore
//
//  Created by study on 14-11-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMTeacherInfo;

@interface LMCourseTeachCell : UITableViewCell

@property (nonatomic, strong) LMTeacherInfo *teacherInfo;
//id
@property (nonatomic, assign) long long teacherId;
@end
