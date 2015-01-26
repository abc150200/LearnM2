//
//  LMHomeCourseViewCell.h
//  LearnMore
//
//  Created by study on 15-1-26.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCourseList;

@interface LMHomeCourseViewCell : UITableViewCell
@property (nonatomic, assign) long long id;
@property (nonatomic, assign) NSInteger schoolId;
@property (nonatomic, assign) int needBook;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *secondTypeName;
@property (weak, nonatomic) IBOutlet UILabel *schoolInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;

@property (nonatomic, copy) NSString *gps;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) LMCourseList *courselist;
@end
