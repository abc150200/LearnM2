//
//  LMMyRecPhotosView.m
//  LearnMore
//
//  Created by study on 14-12-20.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//


#import "LMMyRecPhotosView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#define LMPhotosViewCount 15
#define LMPhotoH 69
#define LMPhotoW 69
#define CellPadding 15
#define Padding 6

@implementation LMMyRecPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i = 0; i < LMPhotosViewCount; i++) {
            //创建配图
            UIImageView *photoView = [[UIImageView alloc] init];
            [self addSubview:photoView];
            photoView.hidden = YES;
            photoView.tag = i;
            
            
            photoView.userInteractionEnabled = YES;
            
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.clipsToBounds = YES;
            
            //监听图片的点击
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
            [photoView addGestureRecognizer:tap];
            
        }
    }
    return self;
}

- (void)photoClick:(UITapGestureRecognizer *)tap
{
    // 1.创建图片浏览器
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器需要显示的内容
    
    // 2.1遍历所有的需要展示的图片
    NSMutableArray *mjPhotoArr = [NSMutableArray array];
    for (int i=0; i< self.photos.count; i++) {
        
        // 2.2创建MJPhoto对象
        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
        
        // 2.3设置MJPhoto对象的属性
        mjPhoto.url = [NSURL URLWithString:self.photos[i]];
        
        // 设置图片的来源
        mjPhoto.srcImageView = self.subviews[i];
        
        // 2.4将MJPhoto对象添加到数组中
        [mjPhotoArr addObject:mjPhoto];
    }
    // 2.5将数组赋值给图片浏览器
    photoBrowser.photos = mjPhotoArr;
    
    // 告诉图片浏览器当前显示哪张图片
    photoBrowser.currentPhotoIndex = tap.view.tag;
    
    // 3.显示图片浏览器
    [photoBrowser show];
    
    
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    int photoCount = photos.count;
    //防止重用
    if(0 == photoCount)
    {
        self.hidden = YES;
    }else
    {
        self.hidden = NO;
    }
    
    
    for (int i= 0; i < self.photos.count; i++) {
        UIImageView  *photoView = self.subviews[i];
        if (i < photoCount) {
            photoView.hidden = NO;
            
            
            if(i == 2)
            {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, LMPhotoW, LMPhotoH)];
                btn.backgroundColor = UIColorFromRGB(0xf0f0f0);
                [btn setTitle:[NSString stringWithFormat:@"共%d张",photoCount] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [photoView addSubview:btn];
            }else if (i > 2)
            {
                photoView.hidden = YES;
            }else
            {
                //下载配图
                NSString *imageUrl = self.photos[i];
                [photoView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"380,210"]];
            }
            
        }
        else
        {
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.photos.count ; i++) {
        UIImageView *photoView = self.subviews[i];
        
        photoView.width = LMPhotoW;
        photoView.height = LMPhotoH;
        
        photoView.x = (LMPhotoW + Padding) * i;
        photoView.y = 0;
    }
}

@end