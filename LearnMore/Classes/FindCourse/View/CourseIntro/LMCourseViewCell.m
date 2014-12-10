//
//  LMCourseViewCell.m
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCourseViewCell.h"
#import "LMCourseList.h"


@interface LMCourseViewCell ()

@property (copy, nonatomic) NSString *ageInfo;
@property (weak, nonatomic) IBOutlet UIImageView *free;

@end


@implementation LMCourseViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    LMCourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMCourseViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setCourselist:(LMCourseList *)courselist
{
    _courselist = courselist;

    self.courseName.text = _courselist.courseName;

    self.secondTypeName.text = [NSString stringWithFormat:@"%@ | %@",_courselist.secondTypeName,[NSString ageBegin:_courselist.propAgeStart ageEnd:_courselist.propAgeEnd]];
    self.schoolInfoLabel.text = _courselist.schoolFullName;
    self.id = _courselist.id;
    self.free.hidden = !(_courselist.needBook);
    
    self.needBook = _courselist.needBook;
    
    
    NSString *str = _courselist.courseImage;
    if([str isKindOfClass:[NSString class]])
    {
        NSURL *url = [NSURL URLWithString:str];
        [self.courseImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"380,210"]];
    }
    self.courseImageView.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;  
    self.courseImageView.layer.borderWidth = 1.0f;
}

@end
