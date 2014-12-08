//
//  UIImage+Extension.m
//  7期微博
//
//  Created by apple on 05/08/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


+ (instancetype)resizableImageWithName:(NSString *)imageName
{
    // 1.创建图片
    UIImage *image = [self imageNamed:imageName];
    
    // 2.计算多宽不拉伸
    CGFloat left = image.size.width * 0.5;
    CGFloat top = image.size.height * 0.5;
    // 3.生成拉伸不变形的图片
    /*
     1 =  width - leftCapWidth
     1 =  height - topCapWidth
     */
    image = [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
    
//    [image resizableImageWithCapInsets:nil];
//    [image resizableImageWithCapInsets:nil resizingMode:nil];
    // 4.返回图片
    return image;
}
@end
