//
//  LMSchoolViewCell.m
//  LearnMore
//
//  Created by study on 14-11-27.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMSchoolViewCell.h"
#import "LMSchoolList.h"
#import "TQStarRatingDisplayView.h"



@interface LMSchoolViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *keyWord;

@property (weak, nonatomic) IBOutlet UIImageView *schoolImage;
@end


@implementation LMSchoolViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell2";
    LMSchoolViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMSchoolViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)setSchoolList:(LMSchoolList *)schoolList
{
    _schoolList = schoolList;
    [self.schoolImage sd_setImageWithURL:[NSURL URLWithString:_schoolList.schoolImage] placeholderImage:[UIImage imageNamed:@"380,210"]];
    self.nameLabel.text = _schoolList.schoolFullName;
    self.id = _schoolList.id;
    
    NSArray *arr  = [_schoolList.mainCourse objectFromJSONString];
     NSMutableArray *arr1 = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
         [arr1 addObject:dict[@"name"]];
    }
    NSString *str = [arr1 componentsJoinedByString:@"、"];
    
    self.keyWord.text = str;
    
    
    CGRect rect = CGRectMake(107,36,90,14);
    
    NSDictionary *dict = _schoolList.schoolCommentLevel;
    NSString *str1 = dict[@"avgTotalLevel"];
    TQStarRatingDisplayView *star = [[TQStarRatingDisplayView alloc] initWithFrame:rect numberOfStar:5 norImage:@"public_review_small_normal" highImage:@"public_review_small_pressed" starSize:14 margin:0 score:str1];
    [self.contentView addSubview:star];

    
}


@end
