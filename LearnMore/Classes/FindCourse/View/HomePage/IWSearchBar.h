//
//  IWSearchBar.h
//  7期微博
//
//  Created by apple on 06/08/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMCustomTextField.h"

@interface IWSearchBar : LMCustomTextField
#warning 尝试能不能外界提供放大镜接口
@property (nonatomic, strong) UIImage *searchButton;
@end
