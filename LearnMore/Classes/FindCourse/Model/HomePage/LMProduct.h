//
//  LMProduct.h
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMProduct : NSObject
@property (nonatomic, copy) NSString *title;
@property (copy, nonatomic) NSString *icon;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)productWithDict:(NSDictionary *)dict;
@end
