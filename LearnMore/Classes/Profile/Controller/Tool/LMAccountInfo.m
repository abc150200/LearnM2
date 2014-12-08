//
//  LMAccountInfo.m
//  LearnMore
//
//  Created by study on 14-11-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMAccountInfo.h"

@implementation LMAccountInfo

 static LMAccountInfo *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}


+ (instancetype)sharedAccountInfo
{
    // 判断是否已经被实例化
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LMAccountInfo alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}


- (void)setAccount:(LMAccount *)account
{
    _account = account;
}

@end
