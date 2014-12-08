//
//  LMDetailAct.m
//  LearnMore
//
//  Created by study on 14-11-3.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMDetailAct.h"

@implementation LMDetailAct

+ (instancetype)actWithDict:(NSDictionary *)dict
{
    LMDetailAct *act = [[self alloc] init];
    act.actImage = dict[@"actImage"];
    act.actBeginTime = dict[@"actBeginTime"];
    act.actEndTime = dict[@"actEndTime"];
    act.schoolName = dict[@"schoolName"];
    act.contactPhone = dict[@"contactPhone"];
    act.actNowCount = [dict[@"actNowCount"] intValue];
    
    return act;
}

- (NSString *)actBeginTime
{
    long long time = [_actBeginTime longLongValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    return [fmt stringFromDate:date];
}

- (NSString *)actEndTime
{
    long long time = [_actEndTime longLongValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    return [fmt stringFromDate:date];
}


@end
