//
//  LMProduct.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMProduct.h"

@implementation LMProduct

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
     
        self.title = dict[@"title"];
        self.icon = dict[@"icon"];
    }
    return self;
}

+ (instancetype)productWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
