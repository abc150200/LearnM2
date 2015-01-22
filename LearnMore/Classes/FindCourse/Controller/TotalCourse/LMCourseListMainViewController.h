//
//  LMCourseListMainViewController.h
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

typedef enum
{
    FromHome,
    FromeSearch
}FromeVC;

#import <UIKit/UIKit.h>

@interface LMCourseListMainViewController : UIViewController
/** 从LMResultController控制器点击按钮传过来的值 */
@property (copy, nonatomic) NSString *searchContent;
@property (strong, nonatomic) NSNumber *TypeId;
/** 城市id */
@property (copy, nonatomic) NSString *areaId;
@property (copy, nonatomic) NSString *levelId;
/** 年龄 */
@property (copy, nonatomic) NSString *ageId;

/** 课程大分类 */
@property (copy, nonatomic) NSString *courseTitle;

/** 排序id */
@property (nonatomic, assign) int orderId;

@property (nonatomic, assign) FromeVC from;

@end
