//
//  LMSchoolIntroViewController.h
//  LearnMore
//
//  Created by study on 14-10-9.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMSchoolCourse;

@interface LMSchoolIntroViewController : UIViewController
@property (nonatomic, strong) LMSchoolCourse *course;

@property (copy, nonatomic) NSString *secondTypeName;

@property (nonatomic, assign) long long id;



@end
