//
//  TQStarRatingDisplayView.m
//  点评Demo
//
//  Created by study on 14-12-5.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "TQStarRatingDisplayView.h"


@interface TQStarRatingDisplayView ()

@property (nonatomic, assign) int numberOfStar;
@property (nonatomic, assign) int score;

@property (nonatomic, strong) UIView *starBackgroundView;
@end


@implementation TQStarRatingDisplayView


- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number norImage:(NSString *)norImage highImage:(NSString *)highImage starSize:(CGFloat)starSize margin:(CGFloat)margin score:(NSString *)score
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _numberOfStar = number;
        
        _score = [score intValue];
        
        
        self.starBackgroundView = [self buidlStarViewWithnorImage:norImage highImage:highImage starSize:starSize margin:margin];
     
       [self addSubview:self.starBackgroundView];
        
    }
    return self;
}


- (UIView *)buidlStarViewWithnorImage:(NSString *)norImage highImage:(NSString *)highImage  starSize:(CGFloat)starSize margin:(CGFloat)margin
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.frame = CGRectMake(i * (starSize + margin), 0, starSize, starSize);
        
        if (i < self.score) {
            imageView.image = [UIImage imageNamed:highImage];
        }else
        {
            imageView.image = [UIImage imageNamed:norImage];
        }
        
        [view addSubview:imageView];
    }
    return view;
}


@end
