//
//  LMCourseTeachCell.m
//  LearnMore
//
//  Created by study on 14-11-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCourseTeachCell.h"
#import "LMTeacherInfo.h"

@interface LMCourseTeachCell ()

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@end


@implementation LMCourseTeachCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTeacherInfo:(LMTeacherInfo *)teacherInfo
{
    _teacherInfo = teacherInfo;
    
    self.iconImageView.layer.cornerRadius = 30;
    self.iconImageView.clipsToBounds = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:teacherInfo.image] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    self.nameLabel.text = teacherInfo.name;
    
    self.teacherId = teacherInfo.id;
    
}

@end
