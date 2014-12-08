//
//  MJTabBarButton.m
//  00-ItcastLottery
//
//  Created by apple on 14-4-14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJTabBarButton.h"
#define IWTabBarButtonRatio 0.6

@implementation MJTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置按钮图片居中显示
        self.imageView.contentMode = UIViewContentModeCenter;
        // 设置按钮标题居中显示
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置按钮的字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        // 设置标题颜色
        [self setTitleColor:UIColorFromRGB(0xb2b2b2) forState:UIControlStateNormal];
        // 设置按钮选中状态的文字颜色
        [self setTitleColor:UIColorFromRGB(0x9ac72c)  forState:UIControlStateSelected];
        
        
    }
    return self;
}

// 控制器图片的位置
// contentRect 就是当前按钮的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 4;
    CGFloat imageW = self.width;
    CGFloat imageH = self.height * IWTabBarButtonRatio - 4;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
// 控制器标题的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = self.height * IWTabBarButtonRatio;
    CGFloat titleW = self.width;
    CGFloat titleH = self.height - titleY;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}


/**
 *  只要覆盖了这个方法,按钮就不存在高亮状态
 */
- (void)setHighlighted:(BOOL)highlighted
{

}
@end
