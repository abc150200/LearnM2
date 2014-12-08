//
//  PJFiled.m
//  反射1
//
//  Created by pj on 14-8-8.
//  Copyright (c) 2014年 pj. All rights reserved.
//

#import "PJFiled.h"

@implementation PJFiled
- (void)setType:(NSString *)type
{
   // @"User"  // 取中间
    
    NSRange rang = NSMakeRange(2,[type length] - 3);
    type = [type substringWithRange:rang];
    if ([type hasPrefix:@"NS"]) {
        self.isBase = false;
    }else
    {
        if (NSClassFromString(type) != nil) {
            self.isBase = true;
        }else
        {
            self.isBase = false;
        }
    }
    _type = type;
}

- (void)setArgName:(NSString *)argName
{
    if ([argName hasPrefix:@"_"]) {
        // 删除_
        argName = [argName substringFromIndex:1];
    }
    _argName = argName;
}

- (NSString *)description
{
    return _argName;
}

@end
