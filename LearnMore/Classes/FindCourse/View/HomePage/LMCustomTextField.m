//
//  LMCustomTextField.m
//  LearnMore
//
//  Created by study on 14-10-22.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCustomTextField.h"

@implementation LMCustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawPlaceholderInRect:(CGRect)rect

{
    
    
    [[UIColor whiteColor] setFill];
    
    [[self placeholder]drawInRect:rect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} ];
    
    [super drawRect:rect];
    
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y + 5, bounds.size.width, bounds.size.height);//更好理解些
    
    return inset;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
