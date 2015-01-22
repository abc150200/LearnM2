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



@end

@implementation LMRefundReasonCell

- (void)awakeFromNib {
    // Initialization code
    
    self.btn.userInteractionEnabled = NO;
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
