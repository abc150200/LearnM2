//
//  LMTeachListTableViewController.h
//  LearnMore
//
//  Created by study on 14-11-3.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCourseInfoTeach;
@class LMTeachListTableViewController;

//自定义代理
@protocol LMTeachListTableViewControllerDelegate <NSObject>

@optional
- (void)teachListTableViewController:(LMTeachListTableViewController *)teachListTableViewController teacherId:(long long)teacherId;

@end


@interface LMTeachListTableViewController : UITableViewController

@property (nonatomic, weak) id<LMTeachListTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *teachers;
@property (nonatomic, strong) LMCourseInfoTeach *teachList;
@end
