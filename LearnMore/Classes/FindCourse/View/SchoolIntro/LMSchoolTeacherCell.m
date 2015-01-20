//
//  LMSchoolTeacherCell.m
//  LearnMore
//
//  Created by study on 14-12-15.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMSchoolTeacherCell.h"
#import "LMTeachList.h"


@interface LMSchoolTeacherCell ()

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end


@implementation LMSchoolTeacherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTeacherList:(LMTeachList *)teacherList
{
    _teacherList = teacherList;
    
    self.iconImageView.layer.cornerRadius = 30;
    self.iconImageView.clipsToBounds = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:teacherList.teacherImage] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    self.nameLabel.text = teacherList.teacherName;
    
    self.teacherId = teacherList.id; 
}

@end
