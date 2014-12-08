//
//  LMCourseListViewController.h
//  LearnMore
//
//  Created by study on 14-11-27.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMMainTableViewController.h"

@interface LMCourseListViewController : LMMainTableViewController
@property (nonatomic, strong) NSMutableArray *courseLists;

@property (nonatomic, strong) NSMutableDictionary *arr;

- (void)loadNewData;

@end
