//
//  LMMyActivityViewCell.h
//  LearnMore
//
//  Created by study on 14-10-15.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMActBook;

@interface LMMyActivityViewCell : UITableViewCell
@property (nonatomic, strong) LMActBook *actBook;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
