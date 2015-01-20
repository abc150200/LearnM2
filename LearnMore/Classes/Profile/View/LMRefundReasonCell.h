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

@property (weak, nonatomic) IBOutlet UILabel *reasonName;


@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger reasonStatus;
@property (copy, nonatomic) NSString *reasonDes;
@end
