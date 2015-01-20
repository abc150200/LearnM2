//
//  LMCommonItem.m
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCommonItem.h"

@implementation LMCommonItem
- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.title = title;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title];
}


- (instancetype)initWithIcon:(NSString *)icon Title:(NSString *)title
{
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
    }
    return self;
    
}

+ (instancetype)itemWithIcon:(NSString *)icon Title:(NSString *)title
{
    return [[self alloc] initWithIcon:icon Title:title];
}
@end
