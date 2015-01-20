//
//  LMCourseSearch.m
//  LearnMore
//
//  Created by study on 14-10-21.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCourseSearch.h"

@implementation LMCourseSearch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 2.设置文字居中
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        // 4.添加放大镜
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_class_list_search"]];
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
