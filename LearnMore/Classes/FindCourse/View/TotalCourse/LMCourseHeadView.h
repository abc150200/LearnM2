//
//  LMCourseHeadView.h
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMListButton.h"

@class LMCourseHeadView;

//自定义代理
@protocol LMCourseHeadViewDelegate <NSObject>

@optional
- (void)courseHeadView:(LMCourseHeadView *)courseHeadView didClickBtnIndex:(NSInteger)index;

@end


@interface LMCourseHeadView : UIView
@property (nonatomic, weak) id<LMCourseHeadViewDelegate> delegate;
/** 存储所有的按钮 */
@property (nonatomic, strong) NSMutableArray *buttons;

@property(nonatomic, strong)LMListButton *titleBtn;
@property(nonatomic, strong)LMListButton *cityBtn;
@property(nonatomic, strong)LMListButton *ageBtn;
@property (nonatomic, strong)LMListButton *selectedBtn;

/**
 * 存储所有的分割线
 */
@property(nonatomic, strong)NSMutableArray *dividers;

//创建底部分割线
@property (nonatomic, weak) UIView *separate;

@end
