//
//  LMListButton.m
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMListButton.h"

// 按钮图片的宽度
#define IWTitleButtonImageW 15

@implementation LMListButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置标题和按钮居中显示
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        
        self.imageView.contentMode = UIViewContentModeLeft;
    }
    return self;
}

// 调整标题的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleW = contentRect.size.width - IWTitleButtonImageW;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}


// 调整图片的位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = contentRect.size.width - IWTitleButtonImageW;
    CGFloat imageY = 0;
    CGFloat imageW = IWTitleButtonImageW;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

#warning 设置后不能设置居中,故设置没用
//- (void)setTitle:(NSString *)title forState:(UIControlState)state
//{
//
//    // 根据用户设置的文本计算按钮的宽度
//    CGSize titleSize =[title sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
//    
//    
////    CGSize titleSize =  [title sizeWithFont:self.titleLabel.font];
//    CGFloat buttonWidth = titleSize.width + IWTitleButtonImageW;
//    // 将计算后的frame设置给按钮
//    self.width = buttonWidth;
//
//    [super setTitle:title forState:state];
//}


@end
