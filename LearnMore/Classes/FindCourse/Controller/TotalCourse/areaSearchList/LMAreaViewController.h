//
//  LMAreaViewController.h
//  LearnMore
//
//  Created by study on 14-11-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMAreaViewController;

//自定义代理
@protocol LMAreaViewControllerDelegate <NSObject>

@optional

- (void)areaViewController:(LMAreaViewController *)controller selectedCities:(NSArray *)cities row:(int)row;;
//- (void)areaViewController:(LMAreaViewController *)controller selectedCities:(NSArray *)cities areaId:(NSString *)areaId areaLevel:(NSString *)areaLevel title:(NSString *)title;

- (void)areaViewController:(LMAreaViewController *)controller didSelectRow:(int)row;

@end


@interface LMAreaViewController : UITableViewController

@property (nonatomic, weak) id<LMAreaViewControllerDelegate> areaDelegate;

@end
