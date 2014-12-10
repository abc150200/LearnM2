//
//  LMAccount.h
//  LearnMore
//
//  Created by study on 14-11-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMAccount : NSObject
@property (copy, nonatomic) NSString *sessionkey;
@property (copy, nonatomic) NSString *sid;
@property (nonatomic, assign) long time;
@property (nonatomic, assign) long uid;
@property (copy, nonatomic) NSString *userPhone;
@property (copy, nonatomic) NSString *pwd;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
