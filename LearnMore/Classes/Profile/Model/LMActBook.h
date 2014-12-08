//
//  LMActBook.h
//  LearnMore
//
//  Created by study on 14-11-16.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMActBook : NSObject
@property (nonatomic, assign) long long typeId;
@property (copy, nonatomic) NSString *actTitle;
@property (nonatomic, assign) long actBeginTime;
@property (nonatomic, assign) long actEndTime;
@end
