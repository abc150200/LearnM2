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
    self.title.text = course.courseName;
    self.detail.text = [NSString stringWithFormat:@"%@ | %@,0基础",course.secondTypeName,[NSString ageBegin:_course.propAgeStart ageEnd:_course.propAgeEnd]];
    
}



@end
