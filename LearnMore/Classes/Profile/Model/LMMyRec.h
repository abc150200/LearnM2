//
//  LMMyRec.h
//  LearnMore
//
//  Created by study on 14-12-15.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMTimeFont [UIFont systemFontOfSize:14]
#define LMContentFont [UIFont systemFontOfSize:14]
#define LMTitleFont [UIFont systemFontOfSize:14]
#define LMRecLabelFont [UIFont systemFontOfSize:12]

#import <Foundation/Foundation.h>

@interface LMMyRec : NSObject
@property (assign, nonatomic) long createTime;
@property (copy, nonatomic) NSString *typeName;
@property (nonatomic, strong) NSDictionary *level;
@property (copy, nonatomic) NSString *commentText;
@property (copy, nonatomic) NSString *images;
@end
