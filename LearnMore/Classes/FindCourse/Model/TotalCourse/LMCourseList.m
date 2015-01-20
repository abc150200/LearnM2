//
//  LMCourse.m
//  LearnMore
//
//  Created by study on 14-10-28.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCourseList.h"
#import "LMAuths.h"

@implementation LMCourseList
// 该方法的作用是告诉框架, 哪个一个属性中存放什么样的值
- (NSDictionary *)objectClassInArray
{
    return @{@"auths": [LMAuths class]};
}
@end
