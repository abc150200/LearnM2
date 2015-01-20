//
//  LMBaseTableViewController.h
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMCommonItemArrow.h"
#import "LMCommonItemLabel.h"
#import "LMCommonGroup.h"
#import "LMCommonCell.h"

@interface LMBaseTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *groups;
- (LMCommonGroup *)addGroup;
@end
