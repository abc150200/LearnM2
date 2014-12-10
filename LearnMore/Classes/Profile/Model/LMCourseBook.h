//
//  LMCourseBook.h
//  LearnMore
//
//  Created by study on 14-11-16.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//
/** courses = (
{
    studentName = 李晶晶;
    typeId = 745;
    schoolType = 1;
    id = 29;
    cityName = 北京;
    hopeTime = 1415527828000;
    schoolId = 221;
    gps = 116.317942, 39.949745;
    cityId = 828;
    orgName = <null>;
    createTime = 1415527828000;
    zoneId = 192;
    studentAge = 12;
    courseName = 元素性趣味舞蹈课（幼儿小班）;
    userTrueName = <null>;
    schoolFullName = 北京校园舞蹈学校;
    secondTypeName = 其他;
    userName = 15201300301;
    propAgeEnd = 5;
    studentSex = 2;
    provinceName = 北京;
    firstTypeId = 10;
    userId = 10;
    contactMobile = 15201300301;
    appointmentType = 1;
    address = 北京市海淀区紫竹院路广源大厦B1-121;
    userMobile = 15201300301;
    zoneName = 海淀区;
    secondTypeId = 58;
    propAgeStart = 4;
    provinceId = 1;
    firstTypeName = 声乐舞蹈; */


#import <Foundation/Foundation.h>

@interface LMCourseBook : NSObject
@property (nonatomic, assign) long long typeId;
@property (copy, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *secondTypeName;
@property (copy, nonatomic) NSString *schoolFullName;
@property (nonatomic, assign) int propAgeStart;
@property (nonatomic, assign) int propAgeEnd;
@end
