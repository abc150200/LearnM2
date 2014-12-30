//
//  LMCourse.h
//  LearnMore
//
//  Created by study on 14-10-28.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

/** "tcount"://符合条件的结果总数,"courseList":[
 {"id":"// 课程编号","cname":"// 课程名称","address":"//上课地址（省,市）","school":"所属学校名字","category":"// 课程分类","age":"// 年龄段","price":"// 课时折扣价（单位:元/课时）","costPrice":"// 课时原价钱（单位:元/课时）"}
 ]} */

#import <Foundation/Foundation.h>
@class LMCourseComment;

@interface LMCourseList : NSObject

@property (assign, nonatomic) long long id; //课程编号
@property (copy, nonatomic) NSString *courseName;// 课程名称
@property (copy, nonatomic) NSString *schoolFullName;// 所属学校名字
@property (copy, nonatomic) NSString *secondTypeName; // 课程分类
@property (assign, nonatomic) int propAgeStart;      // 年龄段开始
@property (assign, nonatomic) int propAgeEnd;        // 年龄段结束
//@property (copy, nonatomic) NSString *courseImage;   //课程图片
@property (assign, nonatomic) int perPrice;    // 课时折扣价（单位:元/课时）
@property (assign, nonatomic) int packagePrice;// 课时原价钱（单位:元/课时）
@property (nonatomic, assign) int fullCourseTime; //课时
@property (copy, nonatomic) NSString *schoolGps;//坐标
@property (copy, nonatomic) NSString *courseImage;
@property (nonatomic, assign) int needBook;  //标记
@property (nonatomic, strong) LMCourseComment *courseCommentLevel;//课程点评
@property (nonatomic, copy) NSString *gps;//默认gps

@property (nonatomic, strong) NSArray *auths;
@end



