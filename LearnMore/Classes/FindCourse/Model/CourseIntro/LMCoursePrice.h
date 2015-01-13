//
//  LMCoursePrice.h
//  LearnMore
//
//  Created by study on 15-1-12.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMCoursePrice : NSObject
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, assign) int costPrice;
@property (nonatomic, assign) int discountPrice;

@end
