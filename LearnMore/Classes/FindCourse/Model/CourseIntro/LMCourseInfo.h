//
//  LMCourseInfo.h
//  LearnMore
//
//  Created by study on 14-11-1.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMCourseList;
@class LMTeacherInfo;

@interface LMCourseInfo : NSObject

///** 课程列表 */
//@property (nonatomic, strong) LMCourseList *course;

@property (assign, nonatomic) long long id; //课程编号
@property (copy, nonatomic) NSString *courseName;// 课程名称
@property (copy, nonatomic) NSString *schoolFullName;// 所属学校名字
@property (copy, nonatomic) NSString *secondTypeName; // 课程分类
@property (assign, nonatomic) int propAgeStart;      // 年龄段开始
@property (assign, nonatomic) int propAgeEnd;        // 年龄段结束
@property (copy, nonatomic) NSString *courseImage;   //课程图片
@property (assign, nonatomic) int perPrice;    // 课时折扣价（单位:元/课时）
@property (assign, nonatomic) int packagePrice;// 课时原价钱（单位:元/课时）
@property (nonatomic, assign) int fullCourseTime; //课时
@property (copy, nonatomic) NSString *schoolGps;//坐标
@property (copy, nonatomic) NSString *schoolPhone;//电话
@property (copy, nonatomic) NSString *address;//学校地址

/** 老师数组 */
@property (nonatomic, strong) NSArray *teachers;

@end
