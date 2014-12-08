//
//  UIImage+Extension.h
//  7期微博
//
//  Created by apple on 05/08/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名称创建一张适配IOS67的图片
 *
 *  @param imageName 需要创建的图片名称
 *
 *  @return 适配后的图片
 */
//+ (instancetype)imageWithName:(NSString *)imageName;

/**
 *  根据图片名称创建一张拉伸不变形的图片
 *
 *  @param imageName 需要创建的图片名称
 *
 *  @return 拉伸不变形的图片
 */
+ (instancetype)resizableImageWithName:(NSString *)imageName;
@end
