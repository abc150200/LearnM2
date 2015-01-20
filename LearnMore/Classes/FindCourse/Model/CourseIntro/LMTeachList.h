//
//  LMTeachList.h
//  LearnMore
//
//  Created by study on 14-11-3.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMTeachList : NSObject
@property (nonatomic, assign) long long id;
@property (copy, nonatomic) NSString *teacherName;
@property (copy, nonatomic) NSString *teacherImage;
@property (copy, nonatomic) NSString *schoolName;
@property (copy, nonatomic) NSString *teacherDes;
@property (copy, nonatomic) NSString *teacherAchieve;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *phone;

+ (instancetype)teacherWithDict:(NSDictionary *)dict;

@end
