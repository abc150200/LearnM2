//
//  LMMyAwardVieCell.h
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMMyOrder;

@interface LMMyOrderViewCell : UITableViewCell

@property (nonatomic, strong) LMMyOrder *myOrder;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
