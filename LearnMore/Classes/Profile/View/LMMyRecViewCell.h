//
//  LMMyRecViewCell.h
//  LearnMore
//
//  Created by study on 14-12-16.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMMyRecFrame;

@interface LMMyRecViewCell : UITableViewCell
@property (nonatomic, strong) LMMyRecFrame *recFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign) int commentType;
@property (nonatomic, assign) long long id;
@property (nonatomic, assign) long long typeId;
@end
