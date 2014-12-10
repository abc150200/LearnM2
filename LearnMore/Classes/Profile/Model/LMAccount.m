//
//  LMAccount.m
//  LearnMore
//
//  Created by study on 14-11-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//
/** @property (copy, nonatomic) NSString *sessionkey;
 @property (copy, nonatomic) NSString *sid;
 @property (nonatomic, assign) long time;
 @property (nonatomic, assign) long uid; */

#import "LMAccount.h"

@implementation LMAccount
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 初始化操作
        self.sessionkey = dict[@"sessionkey"];
        self.sid =  dict[@"sid"];
        self.time =   [dict[@"time"] longValue];
        self.uid = [dict[@"uid"] longValue];
        self.userPhone = dict[@"userPhone"];
        self.pwd = dict[@"pwd"];
    }
    return self;
}
+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


/**
 *  将一个对象写入文件的时候调用, 在此方法中说清楚对象怎么存
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.sessionkey forKey:@"sessionkey"];
    [encoder encodeObject:self.sid forKey:@"sid"];
    [encoder encodeInt32:self.time forKey:@"time"];// encodeObject:self.time forKey:@"time"];
    [encoder encodeInt32:self.uid forKey:@"uid"];
    [encoder encodeObject:self.userPhone forKey:@"userPhone"];
    [encoder encodeObject:self.pwd forKey:@"pwd"];
}
/**
 *  将一个对象从文件中读取出来的时候调用, 在此方法中说清楚怎么读取数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    // 注意: 如果父类也实现了NSCoding协议, 必须调用 [super initWithCoder:aDecoder]
    if (self = [super init]) {
        self.sessionkey = [decoder decodeObjectForKey:@"sessionkey"];
        self.sid = [decoder decodeObjectForKey:@"sid"];
        self.time = [decoder decodeInt32ForKey:@"time"];
        self.uid = [decoder decodeInt32ForKey:@"uid"];
        self.userPhone = [decoder decodeObjectForKey:@"userPhone"];
        self.pwd = [decoder decodeObjectForKey:@"pwd"];
        
    }
    return self;
}

@end
