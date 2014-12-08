//
//  LMCityViewController.h
//  LearnMore
//
//  Created by study on 14-11-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCityViewController;

//自定义代理
@protocol LMCityViewControllerDelegate <NSObject>

@optional
- (void)cityViewController:(LMCityViewController *)cityViewController level:(NSString *)level id:(NSString *)id;

@end


@interface LMCityViewController : UITableViewController
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, weak) id<LMCityViewControllerDelegate> delegate;

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *level;
@end
