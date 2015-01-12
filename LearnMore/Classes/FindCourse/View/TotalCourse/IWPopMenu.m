//
//  IWPopMenu.m
//  7期微博
//
//  Created by apple on 08/08/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWPopMenu.h"

@interface IWPopMenu()

@property (nonatomic, strong) UIView  *contentView;
/**
 *  自定义菜单的容器视图(黑色视图)
 */
@property (nonatomic, weak) UIImageView *container;
/**
 *  蒙版
 */
@property (nonatomic, weak) UIButton *cover;
@end

@implementation IWPopMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        MyLog(@"initWithFrame");
        // 初始化两个子控件
        // 1.创建蒙版
        UIButton *cover = [[UIButton alloc] init];
        cover.backgroundColor = [UIColor clearColor];
        [cover addTarget:self action:@selector(coverBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        // 添加蒙版到当前视图
        [self addSubview:cover];
        self.cover = cover;

        // 2.创建内容视图(黑色视图)
        UIImageView *container = [[UIImageView alloc] init];
//        container.image = [UIImage resizableImageWithName:@"popover_background"];
        container.userInteractionEnabled = YES;
        // 添加内容视图到蒙版
        [cover addSubview:container];
        self.container = container;
    }
    return self;
}
- (instancetype)initWithContentView:(UIView *)contentView
{
    if (self = [super init]) {
//        MyLog(@"initWithContentView");
        self.contentView = contentView;
    }
    
    return self;
}

+ (instancetype)popMenuViewWithContentView:(UIView *)contentView
{
    return [[self alloc]initWithContentView:contentView];
}

- (void)showRect:(CGRect)rect
{
    // 1.设置当前view的frame等于window的frame
    UIApplication *app = [UIApplication sharedApplication];
    self.frame = app.keyWindow.bounds;
    
    // 添加当前视图到keyWindow
     [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    // 2.设置黑色菜单的frame
    self.container.frame = rect;
    
    // 3.将创建菜单时传入的内容设置到内容视图上
    [self.container addSubview:self.contentView];
    
    // 调整contentView的frame
    CGFloat topMargin = 0;
    CGFloat leftMargin = 0;
    CGFloat rightMargin = 0;
    CGFloat bottomMargin = 0;
    
    self.contentView.y = topMargin;
    self.contentView.x = leftMargin;
    self.contentView.width = self.container.width - leftMargin - rightMargin;
    self.contentView.height = self.container.height - topMargin - bottomMargin;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置蒙版的frame
    self.cover.frame = self.bounds;
   
}

- (void)dismiss
{
    // 从keyWindow上移除当前视图
    [self removeFromSuperview];
}

#pragma mark - 内部方法
- (void)coverBtnOnClick
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(popMenudidDismiss:)]) {
        [self.delegate popMenudidDismiss:self];
    }
//    MyLog(@"coverBtnOnClick");
    [self dismiss];
}

/**
 *  设置菜单的背景图片
 *
 *  @param image <#image description#>
 */
- (void)setBackground:(UIImage *)image
{
    self.container.image = image;
}
@end
