//
//  LMCourseType.h
//  LearnMore
//
//  Created by study on 14-11-10.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMSecondCourseType;

@interface LMCourseType : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *typeIcon;
@property (nonatomic, strong) LMSecondCourseType *courseTypes;
@end
