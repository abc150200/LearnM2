//
//  LMSearchViewController.h
//  LearnMore
//
//  Created by study on 14-10-23.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//



#import <UIKit/UIKit.h>
@class LMSearchViewController;

//自定义代理
@protocol LMSearchViewControllerDelegate <NSObject>

@optional
- (void)searchViewController:(LMSearchViewController *)searchViewController content:(NSString *)content;

@end


@interface LMSearchViewController : UITableViewController

@property (nonatomic, weak) id<LMSearchViewControllerDelegate> delegate;
@end
