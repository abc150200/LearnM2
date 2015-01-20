//
//  LMActivityViewCell.h
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMActList;



@interface LMActivityViewCell : UITableViewCell

@property (nonatomic, strong) LMActList *actlist;

@property (nonatomic, assign) long long id;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
