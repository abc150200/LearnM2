//
//  LMTeacherCouse.h
//  LearnMore
//
//  Created by study on 14-11-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMTeacherCouse : NSObject
@property (copy, nonatomic) NSString *name;
@property (nonatomic, assign) long long id;
@property (copy, nonatomic) NSString *courseImage;
@property (copy, nonatomic) NSString *secondTypeName;
@property (nonatomic, assign) int propAgeStart;
@property (nonatomic, assign) int propAgeEnd;
@end
