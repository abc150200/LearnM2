//
//  LMRecommend.h
//  LearnMore
//
//  Created by study on 14-12-2.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LMUserFont [UIFont systemFontOfSize:12]
#define LMTimeFont [UIFont systemFontOfSize:12]
#define LMContentFont [UIFont systemFontOfSize:14]

@interface LMRecommend : NSObject
@property (copy, nonatomic) NSString *contactPhone;
@property (assign, nonatomic) long createTime;
@property (copy, nonatomic) NSString *commentText;
@property (copy, nonatomic) NSString *images;
@property (nonatomic, strong) NSDictionary *level;



@end
