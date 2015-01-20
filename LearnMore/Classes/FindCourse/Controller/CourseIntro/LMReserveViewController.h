//
//  LMReserveViewController.h
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

typedef enum
{
    FromCourse,
    FromeAct
}FromeWhere;

#import <UIKit/UIKit.h>

@interface LMReserveViewController : UIViewController
@property (copy, nonatomic) NSString *schoolName;
@property (copy, nonatomic) NSString *courseName;
@property (nonatomic, assign) FromeWhere from;
@property (nonatomic, assign) long long id;

@end
