//
//  LMDetailRecommendViewCell.h
//  LearnMore
//
//  Created by study on 14-12-2.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMRecommedFrame;


@interface LMDetailRecommendViewCell : UITableViewCell
@property (nonatomic, strong) LMRecommedFrame *recommendFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
