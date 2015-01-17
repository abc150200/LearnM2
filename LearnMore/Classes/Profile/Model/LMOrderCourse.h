//
//  LMOrderCourse.h
//  LearnMore
//
//  Created by study on 15-1-17.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMOrderCourse : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger needBook;
@property (nonatomic, copy) NSString *courseName;
@property (copy, nonatomic) NSString *courseImage;
@end
