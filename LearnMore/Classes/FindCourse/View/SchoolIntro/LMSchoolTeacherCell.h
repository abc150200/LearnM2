//
//  LMSchoolTeacherCell.h
//  LearnMore
//
//  Created by study on 14-12-15.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMTeachList;

@interface LMSchoolTeacherCell : UITableViewCell

@property (nonatomic, strong) LMTeachList *teacherList;

//id
@property (nonatomic, assign) long long teacherId;

@end
