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
#import <CoreLocation/CoreLocation.h>


@interface LMSchoolViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@property (weak, nonatomic) IBOutlet UIImageView *schoolImage;

@property (weak, nonatomic) IBOutlet UILabel *distanLabel;

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
    self.schoolImage.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
    self.schoolImage.layer.borderWidth = 1.0f;
    
    self.nameLabel.text = _schoolList.schoolFullName;
    self.id = _schoolList.id;
    
    NSArray *arr  = [_schoolList.mainCourse objectFromJSONString];
     NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
         [arrM addObject:dict[@"name"]];
    }
    NSString *str = [arrM componentsJoinedByString:@"、"];
    
    self.keyWord.text = str;
    
    
    CGRect rect = CGRectMake(115,36,90,14);
    
    NSDictionary *dict = _schoolList.schoolCommentLevel;
    NSString *str1 = dict[@"avgTotalLevel"];
    TQStarRatingDisplayView *star = [[TQStarRatingDisplayView alloc] initWithFrame:rect numberOfStar:5 norImage:@"public_review_small_normal" highImage:@"public_review_small_pressed" starSize:14 margin:0 score:str1];
    [self.contentView addSubview:star];

    
    NSArray *arr1 = [_schoolList.gps componentsSeparatedByString:@","];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:[arr1[1] doubleValue]  longitude:[arr1[0] doubleValue]];

    
    NSString *gpsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"localGps"];
    NSArray *arr2 = [gpsStr componentsSeparatedByString:@","];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[arr2[0] doubleValue] longitude:[arr2[1] doubleValue]];
    
    // 2.计算2个位置的直线距离(CLLocationDistance单位是m)
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    NSLog(@"%.0f", distance);
    

    
    if (distance >= 1000) {
        self.distanLabel.text = [NSString stringWithFormat:@"%.1fkm",distance/1000];
    }else
    {
        self.distanLabel.text = [NSString stringWithFormat:@"%.0fm",distance];
    }
    
}


@end
