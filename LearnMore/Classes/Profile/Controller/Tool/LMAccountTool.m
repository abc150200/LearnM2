//
//  LMAccountTool.m
//  LearnMore
//
//  Created by study on 14-11-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMAccountTool.h"
#import "LMAccount.h"


#define LMAccountDocPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]


@implementation LMAccountTool

+ (BOOL)saveAccount:(LMAccount *)account
{
    // 归档模型数据
    return [NSKeyedArchiver archiveRootObject:account toFile:LMAccountDocPath];
    
}

+(LMAccount *)account
{
        MyLog(@"%@", LMAccountDocPath);
    return [NSKeyedUnarchiver unarchiveObjectWithFile:LMAccountDocPath];
    
}

@end
