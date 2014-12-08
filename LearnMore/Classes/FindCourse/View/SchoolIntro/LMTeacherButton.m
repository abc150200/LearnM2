//
//  LMTeacherButton.m
//  LearnMore
//
//  Created by study on 14-10-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMTeacherButton.h"
#define LMSale 0.7

@implementation LMTeacherButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.contentMode = UIViewContentModeCenter;
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.width;
    CGFloat imageH = self.height * LMSale;
    return  CGRectMake(imageX, imageY, imageW, imageH);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = self.height * LMSale;
    CGFloat titleW = self.width;
    CGFloat titleH = self.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
