//
//  LMTeacherCourseCell.m
//  LearnMore
//
//  Created by study on 14-11-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMTeacherCourseCell.h"
#import "LMTeacherCouse.h"

@interface LMTeacherCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end


@implementation LMTeacherCourseCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)setTeachCourse:(LMTeacherCouse *)teachCourse
{
    _teachCourse = teachCourse;
    
    
    self.icon.image = [UIImage imageNamed:@"logo96,96"];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:teachCourse.courseImage] placeholderImage:[UIImage imageNamed:@"app"]];
    self.icon.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
    self.icon.layer.borderWidth = 1.0f;
    
    self.title.text = teachCourse.name;
    self.detail.text = [NSString stringWithFormat:@"%@ | %@,0基础",teachCourse.secondTypeName,[NSString ageBegin:teachCourse.propAgeStart ageEnd:teachCourse.propAgeEnd]];
    
}

@end
