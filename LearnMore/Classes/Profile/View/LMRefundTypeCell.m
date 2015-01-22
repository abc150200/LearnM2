//
//  LMRefundTypeCell.m
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMRefundTypeCell.h"
#import "LMRefundType.h"


@interface LMRefundTypeCell ()




@end


@implementation LMRefundTypeCell

- (void)awakeFromNib {
    
    self.selectBtn.userInteractionEnabled = NO;
}



- (void)setRefundType:(LMRefundType *)refundType
{
    _refundType = refundType;
    
    self.typeName.text = refundType.typeName;
    self.typeDes.text = refundType.typeDes;
}


@end
