//
//  LMMyReserveViewCell.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMyReserveViewCell.h"
#import "LMCourseBook.h"

@interface LMMyReserveViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *schoolName;

@end


@implementation LMMyReserveViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCourseBook:(LMCourseBook *)courseBook
{
    _courseBook = courseBook;
    
    self.courseNameLabel.text = _courseBook.courseName;
    self.infoLabel.text = [NSString stringWithFormat:@"%@ | %@",_courseBook.secondTypeName,[NSString ageBegin:_courseBook.propAgeStart ageEnd:_courseBook.propAgeEnd]];
    
    self.schoolName.text = _courseBook.schoolFullName;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    LMMyReserveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMMyReserveViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


@end
