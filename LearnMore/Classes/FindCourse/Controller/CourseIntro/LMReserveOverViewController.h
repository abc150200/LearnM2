//
//  LMReserveOverViewController.h
//  LearnMore
//
//  Created by study on 14-11-16.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//



#import <UIKit/UIKit.h>



@interface LMReserveOverViewController : UIViewController
@property (copy, nonatomic) NSString *stuName;
@property (nonatomic, assign) int age;
@property (copy, nonatomic) NSString *schoolName;
@property (copy, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *setting;
@property (nonatomic, assign) int sex;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
