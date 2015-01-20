//
//  LMMyAward.h
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMOrderCourse;

@interface LMMyOrder : NSObject
@property (nonatomic, copy) NSString *id;
@property (copy, nonatomic) NSString *productName;
@property (nonatomic, assign) NSInteger productCount;
@property (nonatomic, assign) NSInteger discountPrice;
@property (copy, nonatomic) NSString *orderStatusDes;
@property (nonatomic, strong) LMOrderCourse *course;
@end
