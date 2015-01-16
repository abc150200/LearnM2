//
//  LMRefundType.h
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMRefundType : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger typeStatus;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *typeDes;

@end
