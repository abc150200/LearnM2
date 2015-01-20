//
//  LMActList.h
//  LearnMore
//
//  Created by study on 14-10-30.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMActList : NSObject
@property (nonatomic, assign) long long  id; //活动id
@property (copy, nonatomic) NSString *actTitle; //活动标题
@property (copy, nonatomic) NSString *actImage; //图片
@property (assign, nonatomic) int actPrice; //价格
@property (assign, nonatomic) int actCount; //全部名额
@property (assign, nonatomic) int actNowCount;  //当前剩余名额
@property (assign, nonatomic) long long actBeginTime; //开始时间
@property (assign, nonatomic) long long actEndTime;   //结束时间
@property (copy, nonatomic) NSString *contactUser;  //联系人
@property (copy, nonatomic) NSString *contactPhone; //联系电话
@property (copy, nonatomic) NSString *schoolName; //联系电话
@property (copy, nonatomic) NSString *actAddress;
@property (copy, nonatomic) NSString *gps;//gps
@property (nonatomic, assign) long long visitCount;//访问人数
//@property (nonatomic, assign) NSNumber *visitCount;
//@property (nonatomic, copy) NSString *visitCount;
@property (nonatomic, copy) NSString *leftDays;//剩余天数

@property (nonatomic, strong) NSArray *addrList;

@end
