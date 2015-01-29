//
//  LMLoading.m
//  LearnMore
//
//  Created by study on 15-1-29.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "CLProgressHUD.h"


static float const xMargin = 10;

@interface CLProgressHUD ()

@property (nonatomic, weak) UIView *hudView;
@property (nonatomic, weak) UILabel *stringLabel;
@property (nonatomic, weak) UIImageView *bgIv;

@end


@implementation CLProgressHUD

+ (instancetype)shareInstance
{
    static CLProgressHUD *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return _instance;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self initSubviews];
    }
    
    return self;
}

- (void)showInView:(UIView *)view {
    [self showInView:view withText:@""];
    
}


- (void)showInView:(UIView *)view withText:(NSString *)text {
    //此处可以再次更改
    self.frame = CGRectMake(0, 64, view.width, view.height - 64);
     [view addSubview:self];
    self.stringLabel.text = @"";
    [self layout];
    [self show];
    
}

- (void)show
{
    self.alpha = 1.0f;
    [self startAnimation];
}

- (void)initSubviews {
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectZero];
    _hudView = hudView;
    _hudView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_hudView];
    
    UIImageView *logoIv = [[UIImageView alloc] initWithFrame:CGRectMake(79, 54, 42, 42)];
    logoIv.image = [UIImage imageNamed:@"loading_logo"];
    [self.hudView addSubview:logoIv];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithFrame:CGRectMake(65, 40 , 70, 70)];
    self.bgIv = bgIv;
    bgIv.image = [UIImage imageNamed:@"loading_bg"];
    [self.hudView addSubview:bgIv];
    
    
    
    UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stringLabel.backgroundColor = [UIColor clearColor];
    stringLabel.font = [UIFont systemFontOfSize:16.0f];
    stringLabel.textColor = [UIColor darkGrayColor];
    stringLabel.textAlignment = NSTextAlignmentCenter;
    self.stringLabel = stringLabel;
    [self.hudView addSubview:_stringLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layout];
}

- (void)layout {
    CGFloat hudWidth;
    CGFloat hudHeight;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        hudWidth = 200.0;
        hudHeight = 150.0;
    } else {
        hudWidth = 210.0;
        hudHeight = 90.0;
    }

    self.hudView.frame = CGRectMake((self.width-hudWidth)*0.5, (self.height-hudHeight)*0.5, hudWidth, hudHeight);
   
    self.stringLabel.frame = CGRectMake(xMargin,self.hudView.height - 20, self.hudView.width-xMargin*2, 16);
    
    MyLog(@"self.stringLabel.frame===%@",NSStringFromCGRect(self.stringLabel.frame));
}

- (void)startAnimation {
  
    [self performSelector:@selector(addAnimationToLayer:) withObject:self.bgIv.layer];
    
}


- (void)addAnimationToLayer:(CALayer *)layer {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.delegate = self;
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.cumulative = YES;
    rotationAnimation.duration = 2.5;
    rotationAnimation.repeatCount = MAXFLOAT;
    [layer addAnimation:rotationAnimation forKey:nil];
    
}


+ (void)dismiss {
    [[CLProgressHUD shareInstance] dismiss];
}

- (void)dismiss
{
    self.alpha = 0.0f;
}

@end
