//
//  LMComposeView.h
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMComposeView : UITextView

/** 需要提示的内容 */
@property (copy, nonatomic) NSString *placeholder;
/** 设置提示框的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
