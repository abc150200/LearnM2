//
//  UIBarButtonItem+Extension.h
//  7期微博
//
//  Created by apple on 06/08/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  快速创建自定义UIBarButtonItem
 *
 *  @param imageName            默认状态图片
 *  @param highlightedImageName 高亮状态图片
 *  @param target        监听方法调用者
 *  @param sel           监听按钮方法
 */
+ (instancetype)barButtonItemWithImageName:(NSString *)imageName  target:(id)target sel:(SEL)sel;
@end
