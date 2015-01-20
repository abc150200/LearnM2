//
//  LMProductDetailVC.h
//  LearnMore
//
//  Created by study on 15-1-16.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMProductDetailVC : UIViewController
@property (nonatomic, assign) long productId;
@property (nonatomic, assign) long productTypeId;
@property (copy, nonatomic) NSString *productName;
@property (nonatomic, assign) int discountPrice;
@end
