//
//  LMRefundReasonCell.h
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMRefundReason;

@interface LMRefundReasonCell : UITableViewCell
@property (nonatomic, strong) LMRefundReason *refundReason;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end
