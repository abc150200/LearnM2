//
//  LMRecommendViewController.h
//  LearnMore
//
//  Created by study on 14-11-28.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

typedef enum
{
    FromCourseRem,
    FromeSchoolRem
}FromeWhereRem;

#import <UIKit/UIKit.h>

@interface LMAddRecommendViewController : UIViewController
@property (nonatomic, assign) long long id;
@property (copy, nonatomic) NSString *urlStr;
@property (nonatomic, assign) FromeWhereRem from;
@end
