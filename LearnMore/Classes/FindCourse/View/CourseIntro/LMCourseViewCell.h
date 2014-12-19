//
//  LMCourseViewCell.h
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCourseList;

@interface LMCourseViewCell : UITableViewCell
@property (nonatomic, assign) long long id;
@property (nonatomic, assign) int needBook;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *secondTypeName;
@property (weak, nonatomic) IBOutlet UILabel *schoolInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;

@property (nonatomic, copy) NSString *gps;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) LMCourseList *courselist;
@end
