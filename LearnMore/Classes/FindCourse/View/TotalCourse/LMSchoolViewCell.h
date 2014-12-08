//
//  LMSchoolViewCell.h
//  LearnMore
//
//  Created by study on 14-11-27.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMSchoolList;


@interface LMSchoolViewCell : UITableViewCell
@property (nonatomic, assign) long long id;

@property (nonatomic, strong) LMSchoolList *schoolList;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
