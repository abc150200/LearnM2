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
@class LMLevel;

@interface LMMyRec : NSObject
@property (nonatomic, assign) long long id;
@property (nonatomic, assign) int commentType;
@property (nonatomic, assign) long long typeId;
@property (assign, nonatomic) long long createTime;
@property (copy, nonatomic) NSString *typeName;
@property (nonatomic, strong) LMLevel *level;
@property (copy, nonatomic) NSString *commentText;
@property (copy, nonatomic) NSString *images;
@end
