//
//  LMrefundVC.h
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMRefundVC : UIViewController
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) NSInteger refundFee;
@property (copy, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *productName;
@property (nonatomic, assign) NSInteger discountPrice;
@property (nonatomic, assign) NSInteger productCount;

@end
