//
//  LMMenuButtonView.h
//  切换标签Demo
//
//  Created by study on 14-12-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFJMenuButtonView;

/**
 *  点击按钮,切换tableView的代理方法
 */
@protocol LMMenuButtonViewDelegate <NSObject>

- (void)titleButtonViewDidClickButton:(NSInteger)tag;

@end

@interface LMMenuButtonView : UIView

/**
 *  被选中按钮的角标
 */
@property (nonatomic, assign) NSInteger i;

/**
 *  scrollView contentOffset.x 相对于tableView总个数 -1 的 屏幕宽度 滑动的比例
 */
@property (nonatomic, assign) CGFloat progress;
/** 创建 */
- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

@property (nonatomic, weak) id<LMMenuButtonViewDelegate> delegate;

@end
