//
//  NSString+Path.m
//  02-沙盒演练
//
//  Created by 刘凡 on 14-7-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

- (NSString *)appendDocumentPath
{
    return [[NSString documentPath] stringByAppendingPathComponent:self];
}

- (NSString *)appendCachePath
{
    return [[NSString cachePath] stringByAppendingPathComponent:self];
}

- (NSString *)appendTempPath
{
    return [[NSString tempPath] stringByAppendingPathComponent:self];
}

+ (NSString *)timeNow
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0f", a];
}

+ (NSString *)timeFmtWithLong:(long)longTime
{
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:longTime/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    return [fmt stringFromDate:date];
}

+ (NSString *)timeWithLong:(long)longTime
{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:longTime/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    return [fmt stringFromDate:date];
}

+ (NSString *)ageBegin:(int)ageBegin ageEnd:(int)ageEnd
{
    if ((ageBegin == 0) && (ageEnd == 100)) {
        return [NSString stringWithFormat:@"年龄不限"];
    }else if((ageBegin > 0 ) && (ageEnd == 100))
    {
        return  [NSString stringWithFormat:@"%d岁以上",ageBegin];
    }else
    {
        return [NSString stringWithFormat:@"%d-%d岁",ageBegin,ageEnd];
    }
}





@end
