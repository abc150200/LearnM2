//
//  IWPopMenu.h
//  7期微博
//
//  Created by apple on 08/08/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWPopMenu;

@protocol IWPopMenuDelegate <NSObject>

- (void)popMenudidDismiss:(IWPopMenu *)popMenu;

@end

@interface IWPopMenu : UIView
/**
 *  根据要显示的内容创建一个菜单
 *
 *  @param contentView 需要显示的内容
 *
 *  @return 菜单对象
 */
- (instancetype)initWithContentView:(UIView *)contentView;

/**
 *  根据要显示的内容创建一个菜单
 *
 *  @param contentView 需要显示的内容
 *
 *  @return 菜单对象
 */
+ (instancetype)popMenuViewWithContentView:(UIView *)contentView;

/**
 *  根据指定菜单的frame显示菜单
 *
 *  @param rect 黑色菜单显示的位置和大小
 */
- (void)showRect:(CGRect)rect;

/**
 *  关闭菜单
 */
- (void)dismiss;

@property (nonatomic, weak) id<IWPopMenuDelegate> delegate;


- (void)setBackground:(UIImage *)image;
@end
