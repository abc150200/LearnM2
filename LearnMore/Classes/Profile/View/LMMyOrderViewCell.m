//
//  LMMyAwardVieCell.m
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMMyOrderViewCell.h"

@implementation LMMyOrderViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LMMyOrderViewCell";
    LMMyOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMMyOrderViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setMyOrder:(LMMyOrder *)myOrder
{
    
}

@end
