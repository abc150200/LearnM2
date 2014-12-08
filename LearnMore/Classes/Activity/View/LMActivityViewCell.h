//
//  LMActivityViewCell.h
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMActList;
@class LMActivityViewCell;

//自定义代理
@protocol LMActivityViewCellDelegate <NSObject>

@optional
- (void)activityViewCellDidClickBtn:(LMActivityViewCell *)activityViewCell;

@end


@interface LMActivityViewCell : UITableViewCell

@property (nonatomic, strong) LMActList *actlist;

@property (nonatomic, assign) long long id;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) id<LMActivityViewCellDelegate> delegate;
@end
