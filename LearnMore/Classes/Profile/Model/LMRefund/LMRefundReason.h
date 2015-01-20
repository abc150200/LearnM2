//
//  LMRefundReason.h
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMRefundReason : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger reasonStatus;
@property (nonatomic, copy) NSString *reasonName;
@property (copy, nonatomic) NSString *reasonDes;
@end
