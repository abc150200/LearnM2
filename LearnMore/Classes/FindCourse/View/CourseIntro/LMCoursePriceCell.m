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

@property (weak, nonatomic) IBOutlet UILabel *label;


@property (nonatomic, assign) long productTypeId;

@end


@implementation LMCoursePriceCell

- (void)awakeFromNib {
    // Initialization code
 
}


- (void)setCoursePrice:(LMCoursePrice *)coursePrice
{
    _coursePrice = coursePrice;
    
    self.id = coursePrice.id;
    self.productTypeId = coursePrice.productTypeId;
    self.productNameLabel.text = coursePrice.productName;

    NSString *discountPriceStr = [NSString stringWithFormat:@"￥%d",coursePrice.discountPrice];
    NSString *costPriceStr = [NSString stringWithFormat:@" ￥%d",coursePrice.costPrice];
    
    NSMutableAttributedString *disStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",discountPriceStr,costPriceStr]];
    
    int discountLength = [discountPriceStr length];
    int costLength = [costPriceStr length];
    
    [disStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],NSFontAttributeName : [UIFont systemFontOfSize:16]} range:NSMakeRange(0, discountLength)];
    [disStr addAttributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:11]} range:NSMakeRange(discountLength, costLength)];
    [disStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle] range:NSMakeRange(discountLength + 1, costLength - 1)];
    [disStr addAttribute:NSStrikethroughColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(1, costLength - 1)];
    
    
    self.label.attributedText = disStr;
    
}


@end
