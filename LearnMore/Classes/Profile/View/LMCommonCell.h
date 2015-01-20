//
//  LMCommonCell.h
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCommonItem;

@interface LMCommonCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 数据模型 */
@property (nonatomic, strong) LMCommonItem *item;
@end
