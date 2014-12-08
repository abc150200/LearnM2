//
//  LMActList.m
//  LearnMore
//
//  Created by study on 14-10-30.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMActList.h"

@implementation LMActList
- (NSString *)actBeginTime
{
    long long time = [_actBeginTime longLongValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    LogObj([fmt stringFromDate:date]);
    return [fmt stringFromDate:date];
}

- (NSString *)actEndTime
{
    long long time = [_actEndTime longLongValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    LogObj([fmt stringFromDate:date]);
    return [fmt stringFromDate:date];
}


@end
