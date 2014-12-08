//
//  LMMyCollectionViewCell.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMyCollectionViewCell.h"
#import "LMCollectCourse.h"

@implementation LMMyCollectionViewCell

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
    LMMyCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMMyCollectionViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setCollectCourse:(LMCollectCourse *)collectCourse
{
    _collectCourse = collectCourse;
    
    self.courseName.text = _collectCourse.courseName;
    self.secondTypeName.text = [NSString stringWithFormat:@"%@ | %@",_collectCourse.secondTypeName,[NSString ageBegin:_collectCourse.propAgeStart ageEnd:_collectCourse.propAgeEnd]];
    self.schoolInfoLabel.text = _collectCourse.schoolFullName;

    self.free.hidden = !(_collectCourse.needBook);
    
    NSString *str = _collectCourse.courseImage;
    if([str isKindOfClass:[NSString class]])
    {
        NSURL *url = [NSURL URLWithString:str];
        [self.courseImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    }
}


@end
