//
//  LMCourseInfo.m
//  LearnMore
//
//  Created by study on 14-11-1.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCourseInfo.h"
#import "LMTeacherInfo.h"

@implementation LMCourseInfo
- (NSDictionary *)objectClassInArray
{
    return @{@"teachers":[LMTeacherInfo class]};
}
@end
