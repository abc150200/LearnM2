//
//  LMCourseRecommendViewController.h
//  LearnMore
//
//  Created by study on 14-11-26.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCourseRecommendViewController;

//自定义代理
@protocol LMCourseRecommendViewControllerDelegate <NSObject>

@optional
- (void)courseRecommendViewController:(LMCourseRecommendViewController *)courseRecommendViewController id:(long long)id;

@end


@interface LMCourseRecommendViewController : UITableViewController
@property (nonatomic, assign) long long id;
@property (nonatomic, strong) NSArray *courseLists;

@property (nonatomic, weak) id<LMCourseRecommendViewControllerDelegate> delegate;
@end
