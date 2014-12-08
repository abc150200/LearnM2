//
//  LMSchoolCourse.h
//  LearnMore
//
//  Created by study on 14-10-10.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSchoolCourse : NSObject

@property (copy, nonatomic) NSString *iconName;
@property (copy, nonatomic) NSString *titleName;
@property (copy, nonatomic) NSString *detailName;

/** 标记这组  YES : 展开 ,  NO : 关闭 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;
@end
