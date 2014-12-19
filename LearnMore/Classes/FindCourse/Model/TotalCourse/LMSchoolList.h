//
//  LMSchoolList.h
//  LearnMore
//
//  Created by study on 14-11-27.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSchoolList : NSObject
@property (assign, nonatomic) long long id;
@property (copy, nonatomic) NSString *schoolImage;
@property (copy, nonatomic) NSString *schoolFullName;
@property (nonatomic, strong) NSString *mainCourse;
@property (nonatomic, strong) NSDictionary *schoolCommentLevel;
@property (nonatomic, copy) NSString *gps;
@end
