//
//  UIImage+NJ.h
//  02-音乐播放器
//
//  Created by 李南江 on 14-7-25.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NJ)
/**
 *  获取一个和原图相切的圆形截图,带边框
 *
 *  @param name        原图名称
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)circleImageWithData:(NSData *)data borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
