//
//  LMComposeView.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMComposeView.h"

@interface LMComposeView ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation LMComposeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = [UIColor lightGrayColor];
        label.font = self.font;
        [self addSubview:label];
        self.label = label;
        
        /** 注册通知 */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChange
{
    self.label.hidden = (self.text.length != 0);
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.label.text = _placeholder;
    //计算label的frame
    [self setLabelFont];
}


- (void)setLabelFont
{
    //计算label的frame
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize labelMaxSize = CGSizeMake(screenWidth - 50, MAXFLOAT);
//    CGSize labelSize = [_placeholder sizeWithFont:self.label.font constrainedToSize:labelMaxSize];
    
    CGSize labelSize = [_placeholder boundingRectWithSize:labelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.label.font} context:nil].size;
    self.label.size = labelSize;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    //设置提示label的字体
    self.label.font = font;
    //计算label的frame
    [self setLabelFont];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.x = 5;
    self.label.y = 5;
}

@end
