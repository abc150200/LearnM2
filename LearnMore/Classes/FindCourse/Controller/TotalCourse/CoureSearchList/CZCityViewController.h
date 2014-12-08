//
//  CZCityViewController.h
//  08-多控制器表格联动
//
//  Created by apple on 11/07/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZCityViewController;

//自定义代理
@protocol CZCityViewControllerDelegate <NSObject>

@optional
- (void)cityViewController:(CZCityViewController *)cityViewController didSeclctedItem:(NSNumber *)item title:(NSString *)title;

@end


@interface CZCityViewController : UITableViewController

@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, weak) id<CZCityViewControllerDelegate> delegate;

@end
