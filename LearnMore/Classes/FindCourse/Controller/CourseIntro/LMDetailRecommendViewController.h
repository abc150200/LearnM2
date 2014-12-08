//
//  LMDetailRecommendViewController.h
//  LearnMore
//
//  Created by study on 14-12-2.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMDetailRecommendViewController : UITableViewController
@property (nonatomic, assign) long long id;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (copy, nonatomic) NSString *mainTitle;

@property (nonatomic, strong) NSDictionary  *courseScoreDic;

@end
