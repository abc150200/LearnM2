//
//  LMSchoolCourseViewCell.m
//  LearnMore
//
//  Created by study on 14-10-9.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMSchoolCourseViewCell.h"
#import "LMCourseInfo.h"



@interface LMSchoolCourseViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;



//+ (instancetype)

@end

@implementation LMSchoolCourseViewCell

- (void)awakeFromNib
{
    // Initialization code
}


- (void)setCourse:(LMCourseInfo *)course
{
    _course = course;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:course.courseImage] placeholderImage:[UIImage imageNamed:@"app"]];
    self.icon.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
    self.icon.layer.borderWidth = 1.0f;
    
    
    self.title.text = course.courseName;
    self.detail.text = [NSString stringWithFormat:@"%@ | %@",course.secondTypeName,[NSString ageBegin:_course.propAgeStart ageEnd:_course.propAgeEnd]];
    
}



@end
