//
//  LMActivityListViewController.h
//  LearnMore
//
//  Created by study on 14-12-24.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMActivityListViewController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary *arr;

- (void)loadNewData;
@end
