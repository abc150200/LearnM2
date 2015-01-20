//
//  LMCommonGroup.h
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMCommonGroup : NSObject
/** 所有的cell */
@property (nonatomic, strong) NSArray *items;

+ (instancetype)group;

@end
