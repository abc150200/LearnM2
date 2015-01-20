//
//  LMAccountInfo.h
//  LearnMore
//
//  Created by study on 14-11-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMAccount;

@interface LMAccountInfo : NSObject<NSCopying>
+ (instancetype)sharedAccountInfo;
@property (nonatomic, strong) LMAccount *account;
@end
