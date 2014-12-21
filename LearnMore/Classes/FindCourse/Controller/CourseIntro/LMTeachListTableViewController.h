//
//  LMTeachListTableViewController.h
//  LearnMore
//
//  Created by study on 14-11-3.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCourseInfoTeach;

@interface LMTeachListTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *teachers;
@property (nonatomic, strong) LMCourseInfoTeach *teachList;
@end
