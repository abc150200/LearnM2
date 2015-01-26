//
//  LMHomeCourseViewCell.m
//  LearnMore
//
//  Created by study on 15-1-26.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMHomeCourseViewCell.h"
#import "LMCourseList.h"
#import "TQStarRatingDisplayView.h"
#import <CoreLocation/CoreLocation.h>
#import "LMAuths.h"
#import "LMCourseComment.h"

@interface LMHomeCourseViewCell ()

@property (copy, nonatomic) NSString *ageInfo;
@property (weak, nonatomic) IBOutlet UIImageView *free;
@property (weak, nonatomic) IBOutlet UILabel *disstanLabel;
@property (weak, nonatomic) IBOutlet UILabel *visit;
@property (weak, nonatomic) IBOutlet UILabel *visitLook;

/** gps */
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (weak, nonatomic) IBOutlet UIImageView *cer;
@property (weak, nonatomic) IBOutlet UIImageView *ensure;
@property (weak, nonatomic) IBOutlet UIImageView *discount;

@end


@implementation LMHomeCourseViewCell

- (void)awakeFromNib
{
    
    //添加顶部的线条
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.contentView.width - 10, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xe1e1e1);
    [self.contentView addSubview:lineView];
    
    
    self.courseImageView.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
    self.courseImageView.layer.borderWidth = 0.5f;
    self.visit.textColor = UIColorFromRGB(0xfa952f);
    
    self.cer.hidden = YES;
    self.ensure.hidden = YES;
    self.discount.hidden = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    LMHomeCourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMHomeCourseViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setCourselist:(LMCourseList *)courselist
{
    _courselist = courselist;
    
    self.courseName.text = _courselist.courseName;
    
    //    self.secondTypeName.text = [NSString stringWithFormat:@"%@ | %@",_courselist.secondTypeName,[NSString ageBegin:_courselist.propAgeStart ageEnd:_courselist.propAgeEnd]];
    self.schoolInfoLabel.text = _courselist.schoolFullName;
    self.id = _courselist.id;
    self.schoolId = _courselist.schoolId;
    self.free.hidden = !(_courselist.needBook);
    
    self.needBook = _courselist.needBook;
    
    
    NSString *str = _courselist.courseImage;
    if([str isKindOfClass:[NSString class]])
    {
        NSURL *url = [NSURL URLWithString:str];
        [self.courseImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"380,210"]];
    }
    
    
    CGRect rect = CGRectMake(110,31,90,14);
    LMCourseComment *dict = _courselist.courseCommentLevel;
    NSString *str1 = dict.avgTotalLevel;
    TQStarRatingDisplayView *star = [[TQStarRatingDisplayView alloc] initWithFrame:rect numberOfStar:5 norImage:@"public_review_small_normal" highImage:@"public_review_small_pressed" starSize:14 margin:0 score:str1];
    [self.contentView addSubview:star];
    
    if([dict.visitCount intValue])
    {
        self.visit.text = dict.visitCount;
    }else
    {
        self.visit.hidden = YES;
        self.visitLook.hidden = YES;
    }
    
    
    
    //认证
    NSArray *arrCer = _courselist.auths;
    for (int i = 0; i < arrCer.count; i++) {
        LMAuths *auth = arrCer[i];
        if (auth.id == 1  ) {
            self.cer.hidden = NO;
        }
        if (auth.id == 4  ) {
            self.ensure.hidden = NO;
        }
        if (auth.id == 7  ) {
            self.discount.hidden = NO;
        }
    }
    
    
    NSArray *arr1 = [_courselist.gps componentsSeparatedByString:@","];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:[arr1[1] doubleValue]  longitude:[arr1[0] doubleValue]];
    
    NSString *gpsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"localGps"];
    
    if (gpsStr) {
        NSArray *arr2 = [gpsStr componentsSeparatedByString:@","];
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[arr2[0] doubleValue] longitude:[arr2[1] doubleValue]];
        
        // 2.计算2个位置的直线距离(CLLocationDistance单位是m)
        CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
        NSLog(@"%.0f", distance);
        
        if (distance >= 1000) {
            self.disstanLabel.text = [NSString stringWithFormat:@"%.1fkm",distance/1000];
        }else
        {
            self.disstanLabel.text = [NSString stringWithFormat:@"%.0fm",distance];
        }
    }else
    {
        self.disstanLabel.text = @"距离未知";
    }
    
    
}
@end
