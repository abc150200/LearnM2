//
//  LMFeedbackViewController.h
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMFeedbackViewController;

//自定义代理
@protocol LMFeedbackViewControllerDelegate <NSObject>

@optional
- (void)feedbackViewControllerDidClickButton:(LMFeedbackViewController *)feedbackViewController;

@end

@interface LMFeedbackViewController : UIViewController

@property (nonatomic, weak) id<LMFeedbackViewControllerDelegate> delegate;


@end
