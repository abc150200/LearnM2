//
//  LMTeachList.m
//  LearnMore
//
//  Created by study on 14-11-3.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMTeachList.h"

@implementation LMTeachList
+ (instancetype)teacherWithDict:(NSDictionary *)dict
{
    LMTeachList *t = [[self alloc] init];
    t.teacherName = dict[@"teacherName"];
    t.teacherImage = dict[@"teacherImage"];
    t.id = [dict[@"id"] longLongValue];
    return t;
    
}
@end
