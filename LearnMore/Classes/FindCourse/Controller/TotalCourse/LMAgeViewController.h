//
//  LMAgeViewController.h
//  LearnMore
//
//  Created by study on 14-11-20.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMAgeViewController;

//自定义代理
@protocol LMAgeViewControllerDelegate <NSObject>

@optional
- (void)ageViewController:(LMAgeViewController *)ageViewController age:(NSString *)age title:(NSString *)title;

@end


@interface LMAgeViewController : UITableViewController
@property (nonatomic, weak) id<LMAgeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *listArr;
@end
