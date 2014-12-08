//
//  LMCourseHeadView.m
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCourseHeadView.h"



@interface LMCourseHeadView ()




@end

@implementation LMCourseHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleBtn = [self addOneButtonWithTitle:@"分  类"];
        self.cityBtn = [self addOneButtonWithTitle:@"全  城"];
        self.ageBtn = [self addOneButtonWithTitle:@"年  龄"];
        self.selectedBtn = [self addOneButtonWithTitle:@"智能筛选"];
        
        // 3.创建分割线
        [self setupDivider];
        [self setupDivider];
        [self setupDivider];
        
        //4创建底部分割线
        [self setupSeparate];
        
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 1;
    }
    return self;
}

/** 添加一个按钮 */
- (LMListButton *)addOneButtonWithTitle:(NSString *)title
{
    LMListButton *btn = [[LMListButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
//    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    btn.tag  = self.buttons.count;
    [self addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
     [self.buttons addObject:btn];
    
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"btn_class_list_classify_pressed"] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(courseHeadView:didClickBtnIndex:)]) {
        [self.delegate courseHeadView:self didClickBtnIndex:btn.tag];
        MyLog(@"===%d",btn.tag);
    }
}

/**
 *  添加分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:divider];
    divider.tag = self.dividers.count;
    [self.dividers addObject:divider];
}

- (void)setupSeparate
{
    UIView *separate = [[UIView alloc] init];
    separate.backgroundColor = [UIColor lightGrayColor];
    separate.alpha = 0.7;
    [self addSubview:separate];
    self.separate = separate;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 1.设置按钮的frame
    int count = self.buttons.count;
    CGFloat widith = self.width / count;
    CGFloat height = self.height;
    
    for (int i = 0; i < count; i++) {
        LMListButton *btn = self.buttons[i];
        btn.width = widith;
        btn.height = height;
        btn.y = 0;
        btn.x = i * widith;
    }
    
    // 2.设置分割线的frame
    int dividerCount = self.dividers.count;
    for (int i = 0; i < dividerCount; i++) {
        UIImageView *iv = self.dividers[i];
        iv.width = 1;
        iv.height = 20;
        iv.centerY = height * 0.5;
        iv.centerX = (i + 1) * widith;
    }
    
    // 3.设置底部分割线的frame
    CGFloat separateX = 0;
    CGFloat separateY = self.height - 1.5;
    CGFloat separateW = self.width;
    CGFloat separateH = 1;
    self.separate.frame = CGRectMake(separateX, separateY, separateW, separateH);
}


#pragma mark - 懒加载
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (NSMutableArray *)dividers
{
    if (!_dividers) {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}



@end
