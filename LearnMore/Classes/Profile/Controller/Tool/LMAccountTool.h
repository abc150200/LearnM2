//
//  LMAccountTool.h
//  LearnMore
//
//  Created by study on 14-11-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMAccount;


@interface LMAccountTool : NSObject
/**
 *  根据模型对象存储对象
 *
 *  @param account 需要存储的对象
 *
 *  @return 是否存储成功
 */
+ (BOOL)saveAccount:(LMAccount *)account;

/**
 *  读取模型对象
 */
+ (LMAccount *)account;
@end
