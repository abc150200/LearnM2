//
//  CZProvinceViewController.h
//  08-多控制器表格联动
//
//  Created by apple on 11/07/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZProvinceViewController;

@protocol CZProvinceViewControllerDelegate <NSObject>

- (void)provinceViewController:(CZProvinceViewController *)controller selectedCities:(NSArray *)cities row:(int)row;

@end

@interface CZProvinceViewController : UITableViewController

// 定义代理
@property (nonatomic, weak) id<CZProvinceViewControllerDelegate> provinceDelegate;



@end
