//
//  LMCollectCourse.h
//  LearnMore
//
//  Created by study on 14-11-15.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//
/** [{"id":31,"typeId":754,"favoriteType":1,"userName":"18710289910","userTrueName":null,"userMobile":"18710289910","courseImage":"http://file.manytu.com/source/2014/11/06/20141106212050692.png","courseName":"高中舞蹈艺术特长生培训班","propAgeStart":15,"propAgeEnd":18,"firstTypeId":10,"firstTypeName":"声乐舞蹈","secondTypeId":58,"secondTypeName":"其他","schoolId":221,"orgName":null,"schoolFullName":"北京校园舞蹈学校","schoolType":1,"provinceId":1,"provinceName":"北京","cityId":828,"cityName":"北京","zoneId":192,"zoneName":"海淀区","address":"北京市海淀区紫竹院路广源大厦B1-121","gps":"116.31796, 39.949869","createTime":1416029750000}, */

#import <Foundation/Foundation.h>

@interface LMCollectCourse : NSObject
@property (nonatomic, assign) long long typeId;
@property (copy, nonatomic) NSString *courseImage;
@property (copy, nonatomic) NSString *courseName;
@property (assign, nonatomic) int propAgeStart;      // 年龄段开始
@property (assign, nonatomic) int propAgeEnd;        // 年龄段结束
@property (copy, nonatomic) NSString *secondTypeName;
@property (copy, nonatomic) NSString *schoolFullName;
@property (nonatomic, assign) int needBook;
@end
