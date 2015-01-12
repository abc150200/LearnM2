//
//  LMOrderCommitViewController.h
//  LearnMore
//
//  Created by study on 15-1-7.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMOrderCommitViewController : UIViewController
@property (nonatomic, assign) long productId;
@property (copy, nonatomic) NSString *productName;
@property (strong, nonatomic) NSNumber *costPrice;

@end
