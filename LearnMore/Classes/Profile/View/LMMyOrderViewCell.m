//
//  LMMyAwardVieCell.m
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMMyOrderViewCell.h"
#import "LMMyOrder.h"
#import "LMOrderCourse.h"
#import "UIImageView+WebCache.h"


@interface LMMyOrderViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusDesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *needBookMark;


@end


@implementation LMMyOrderViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LMMyOrderViewCell";
    LMMyOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMMyOrderViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setMyOrder:(LMMyOrder *)myOrder
{
    _myOrder = myOrder;
    
    LMOrderCourse *course = myOrder.course;
    self.courseNameLabel.text = course.courseName;
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:course.courseImage] placeholderImage:[UIImage imageNamed:@"380,210"]];
    self.needBookMark.hidden = !(course.needBook);

    
    self.productNameLabel.text = myOrder.productName;
    self.productCountLabel.text = [NSString stringWithFormat:@"%d",myOrder.productCount];
    
#warning 以后估计还会改吧
    NSInteger totalPrice = (myOrder.discountPrice) * (myOrder.productCount);
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%d",totalPrice];
    
    self.orderStatusDesLabel.text = myOrder.orderStatusDes;
    
    
}

@end
