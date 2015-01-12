//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"

@interface TQStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@property (nonatomic, assign) CGFloat starSize;
@property (nonatomic, assign) CGFloat margin;

@end

@implementation TQStarRatingView

//- (id)initWithFrame:(CGRect)frame
//{
//    return [self initWithFrame:frame numberOfStar:5 norImage:<#(NSString *)#> highImage:<#(NSString *)#> starSize:<#(CGFloat)#> margin:<#(CGFloat)#>
//}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number norImage:(NSString *)norImage highImage:(NSString *)highImage starSize:(CGFloat)starSize margin:(CGFloat)margin
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        
        self.starBackgroundView = [self buidlStarViewWithImageName:norImage starSize:starSize margin:margin];
        self.starForegroundView = [self buidlStarViewWithImageName:highImage starSize:starSize margin:margin];
        
        self.starSize = starSize;
        self.margin = margin;
        
        [self addSubview:self.starBackgroundView];
//        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addSubview:self.starForegroundView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak TQStarRatingView * weekSelf = self;
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:point];
     }
                    completion:^(BOOL finished)
     {
    
     }];
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName starSize:(CGFloat)starSize margin:(CGFloat)margin
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        
            imageView.frame = CGRectMake(i * (starSize + margin), 0, starSize, starSize);
        
        [view addSubview:imageView];
    }
    return view;
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    /** 额外增加 */
    CGFloat single = self.starSize + self.margin;
    double temp = p.x / single;
    int count = (temp + 1);
 
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
//    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
//    float score = int ([str floatValue] + 0.5);
    float score = count;
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, single * count , self.frame.size.height);
    
//    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
//    {
//        [self.delegate starRatingView:self score:score];
//    }
    
    if (self.completion != nil) {
        self.completion(score);
    }
}

@end
