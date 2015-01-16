//
//  LMRefundReasonCell.m
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMRefundReasonCell.h"
#import "LMRefundReason.h"

@interface LMRefundReasonCell ()

@property (weak, nonatomic) IBOutlet UILabel *reasonName;


@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger reasonStatus;
@property (copy, nonatomic) NSString *reasonDes;

@end

@implementation LMRefundReasonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRefundReason:(LMRefundReason *)refundReason
{
    _refundReason = refundReason;
    
    self.reasonName.text = refundReason.reasonName;
    
    self.id = refundReason.id;
    self.reasonDes = refundReason.reasonDes;
    self.reasonStatus = refundReason.reasonStatus;
}


@end
