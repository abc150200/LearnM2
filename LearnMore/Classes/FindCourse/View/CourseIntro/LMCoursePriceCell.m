//
//  LMCoursePriceCell.m
//  LearnMore
//
//  Created by study on 15-1-12.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMCoursePriceCell.h"
#import "LMCoursePrice.h"

@interface LMCoursePriceCell ()

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *costPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;

@property (nonatomic, assign) int id;

@end


@implementation LMCoursePriceCell

- (void)awakeFromNib {
    // Initialization code
    
    
}


- (void)setCoursePrice:(LMCoursePrice *)coursePrice
{
    _coursePrice = coursePrice;
    
    self.id = coursePrice.id;
    self.productNameLabel.text = coursePrice.productName;
    self.costPriceLabel.text = [NSString stringWithFormat:@"￥%d",coursePrice.costPrice];
    self.discountPriceLabel.text = [NSString stringWithFormat:@"￥%d",coursePrice.discountPrice];
}


@end
