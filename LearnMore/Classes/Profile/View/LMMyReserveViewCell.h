//
//  LMMyReserveViewCell.h
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCourseBook;

@interface LMMyReserveViewCell : UITableViewCell
@property (nonatomic, strong) LMCourseBook *courseBook;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
