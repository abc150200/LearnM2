//
//  IWSearchBar.m
//  7期微博
//
//  Created by apple on 06/08/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWSearchBar.h"


@implementation IWSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        
        // 2.设置文字居中
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        // 4.添加放大镜
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_home_search"]];
        // 设置图片的宽度
        iv.width = 30;
        iv.contentMode = UIViewContentModeCenter;
        self.rightView = iv;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        
        //左边加入一个透明的View
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
        view.backgroundColor = [UIColor clearColor];
        view.contentMode = UIViewContentModeCenter;
        self.leftView = view;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // 5.设置提示文
        self.returnKeyType = UIReturnKeySearch;
        
    
    }
    return self;
}






@end
