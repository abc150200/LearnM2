//
//  IWTitleButton.m
//  7期微博
//
//  Created by apple on 06/08/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWCityButton.h"

// 按钮图片的宽度
#define IWTitleButtonImageW 22

@implementation IWCityButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置按钮标题的颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 当按钮高亮状态的时候会自动对按钮上的图片进行调整
        // 禁止系统自动调整高亮状态下按钮上的图片
        self.adjustsImageWhenHighlighted = NO;
        
        // 设置标题和按钮居中显示
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.imageView.contentMode = UIViewContentModeCenter;
        
//        // 设置按钮背景图片
//        [self setBackgroundImage:[UIImage resizableImageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
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
    CGFloat imageH = contentRect.size.height - 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

//- (void)setTitle:(NSString *)title forState:(UIControlState)state
//{
//    
//    // 根据用户设置的文本计算按钮的宽度
//    CGSize titleSize =  [title sizeWithFont:self.titleLabel.font];
//    CGFloat buttonWidth = titleSize.width + IWTitleButtonImageW;
//    // 将计算后的frame设置给按钮
//    self.width = buttonWidth;
//    
//    [super setTitle:title forState:state];
//}

@end
