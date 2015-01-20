//
//  LMMyCollectionViewCell.h
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCollectCourse;

@interface LMMyCollectionViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *secondTypeName;
@property (weak, nonatomic) IBOutlet UILabel *schoolInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *free;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) LMCollectCourse *collectCourse;

@end
