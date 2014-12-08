//
//  LMCommonItem.h
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMCommonItem : NSObject
@property (copy, nonatomic) NSString *title;//标题
@property (copy, nonatomic) NSString *subtitle;//子标题
@property (copy, nonatomic) NSString *icon;//图片

- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;


- (instancetype)initWithIcon:(NSString *)icon Title:(NSString *)title;
+ (instancetype)itemWithIcon:(NSString *)icon Title:(NSString *)title;

/** 目标控制器 */
@property (nonatomic, assign) Class destVc;

/** 定义block保存将来需要执行的代码 */
@property (copy, nonatomic) void(^option)();

@end
