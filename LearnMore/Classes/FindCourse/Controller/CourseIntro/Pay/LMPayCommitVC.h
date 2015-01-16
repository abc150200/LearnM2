//
//  LMPayCommitVC.h
//  LearnMore
//
//  Created by study on 15-1-7.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMPayCommitVC : UIViewController
@property (copy, nonatomic) NSString *courseName;
@property (assign, nonatomic) int count;
@property (nonatomic, assign) int singlePrice;
@property (nonatomic, assign) int totalPrice;
@property (nonatomic, copy) NSString *contact;
@property (copy, nonatomic) NSString *phone;
@property (nonatomic, assign) long productTypeId;
@property (nonatomic, assign) int productId;
@end
