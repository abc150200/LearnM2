//
//  TQStarRatingDisplayView.h
//  点评Demo
//
//  Created by study on 14-12-5.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQStarRatingDisplayView : UIView
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number norImage:(NSString *)norImage highImage:(NSString *)highImage starSize:(CGFloat)starSize margin:(CGFloat)margin score:(NSString *)score;
@end
