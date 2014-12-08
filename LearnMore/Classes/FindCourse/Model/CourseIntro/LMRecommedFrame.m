//
//  LMRecommedFrame.m
//  LearnMore
//
//  Created by study on 14-12-2.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define Padding  15
#define LMCellWidth [UIScreen mainScreen].bounds.size.width
#define LMPhotoW  69
#define LMPhotoH  69 

#import "LMRecommedFrame.h"
#import "LMRecommend.h"

@implementation LMRecommedFrame

-(void)setRecommend:(LMRecommend *)recommend
{
    _recommend = recommend;
    
    //设置用户名
    CGFloat userLabelX = Padding;
    CGFloat userLabelY = Padding;
    CGSize userSize = [_recommend.contactPhone sizeWithAttributes:@{NSFontAttributeName:LMUserFont} ];
    CGFloat userLabelW = userSize.width;
    CGFloat userLabelH = userSize.height;
    _userLabelF = CGRectMake(userLabelX, userLabelY, userLabelW, userLabelH);
    
    //设置时间
    CGFloat timeLabelX = CGRectGetMaxX(_userLabelF) + 20;
    CGFloat timeLabelY = userLabelY;
    CGSize timeSize = [[NSString timeWithLong:_recommend.createTime] sizeWithAttributes:@{NSFontAttributeName:LMTimeFont} ];
    CGFloat timeLabelW = timeSize.width;
    CGFloat timeLabelH = timeSize.height;
    _timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    //设置文本
    CGFloat contentLabelX = userLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(_userLabelF) + Padding;
    CGSize contentMaxSize = CGSizeMake(LMCellWidth - 2 * Padding, MAXFLOAT);
    NSDictionary *att = @{NSFontAttributeName : LMContentFont};
    CGSize size = [_recommend.commentText boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil].size;
    CGFloat contentLabelW = size.width;
    CGFloat contentLabelH = size.height;
    _contentLabelF = CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH);
    
    //设置配图容器的View
    
    CGFloat topViewH = 0;
    if ([recommend.images hasPrefix:@"http"]) {
        
        CGFloat photosViewX = userLabelX;
        CGFloat photosViewY = CGRectGetMaxY(_contentLabelF) + Padding;
        CGFloat photosViewW = LMCellWidth - 2 * Padding;
        CGFloat photosViewH = LMPhotoH;
        _originalPhotosViewF = CGRectMake(photosViewX, photosViewY, photosViewW, photosViewH);
        
        topViewH = CGRectGetMaxY(_originalPhotosViewF) + Padding;
    }else
    {
        topViewH = CGRectGetMaxY(_contentLabelF) + Padding;

    }
   

    
    //设置顶部View
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = LMCellWidth;

    _topViewF = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    

    _cellHeight = CGRectGetMaxY(_topViewF);
}

@end
