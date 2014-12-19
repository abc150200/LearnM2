//
//  LMMyRecFrame.m
//  LearnMore
//
//  Created by study on 14-12-16.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMyRecFrame.h"
#import "LMMyRec.h"

#define Padding  15
#define RecPadding 10
#define LMCellWidth [UIScreen mainScreen].bounds.size.width
#define LMPhotoW  69
#define LMPhotoH  69


@implementation LMMyRecFrame

- (void)setMyRec:(LMMyRec *)myRec
{
    _myRec = myRec;
    
    CGFloat upImgX = Padding;
    CGFloat upImgY = 0;
    CGFloat upImgW = 20;
    CGFloat upImgH = 13;
    _upImgF = CGRectMake(upImgX, upImgY, upImgW, upImgH);
    
    
    CGFloat downImgX = Padding;
    CGFloat downImgY = 13;
    CGFloat downImgW = 20;
    CGFloat downImgH = 31;
    _downImgF = CGRectMake(downImgX, downImgY, downImgW, downImgH);
    
    //时间
    CGFloat timeLabelX = CGRectGetMaxX(_downImgF) + 9;
    CGFloat timeLabelY = downImgY;
    CGSize timeSize = [[NSString timeWithLong:_myRec.createTime] sizeWithAttributes:@{NSFontAttributeName:LMTimeFont} ];
    CGFloat timeLabelW = timeSize.width;
    CGFloat timeLabelH = timeSize.height;
    _timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    //标题
    CGFloat titleLabelX = RecPadding;
    CGFloat titleLabelY = 11;
    CGSize titleSize = [[NSString timeWithLong:_myRec.createTime] sizeWithAttributes:@{NSFontAttributeName:LMTitleFont} ];
    CGFloat titleLabelW = LMCellWidth - 2*(RecPadding + Padding);
    CGFloat titleLabelH = titleSize.height;
    _titleLabelF = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    //线条
    CGFloat dividerX = RecPadding;
    CGFloat dividerY = 44;
    CGFloat dividerW = LMCellWidth - 2 * Padding;
    CGFloat dividerH = 1;
    _dividerF = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    
    //评分
    CGFloat recLabelX = 120;
    CGFloat recLabelY = 48.5;
    CGFloat recLabelW = 30;
    CGFloat recLabelH = 21;
    _recLabelF = CGRectMake(recLabelX, recLabelY, recLabelW, recLabelH);
    
    //设置文本
    CGFloat contentLabelX = RecPadding;
    CGFloat contentLabelY = 45;
    CGSize contentMaxSize = CGSizeMake(LMCellWidth - 2 * (Padding + RecPadding), MAXFLOAT);
    NSDictionary *att = @{NSFontAttributeName : LMContentFont};
    CGSize size = [_myRec.commentText boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil].size;
    CGFloat contentLabelW = size.width;
    CGFloat contentLabelH = size.height;
    _contentLabelF = CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH);
    
    //设置图片容器
    CGFloat  recViewH= 0;
    if ([_myRec.images hasPrefix:@"http"]) {
        
        CGFloat photosViewX = RecPadding;
        CGFloat photosViewY = CGRectGetMaxY(_contentLabelF) + Padding;
        CGFloat photosViewW = LMCellWidth - 2 * (Padding + RecPadding) ;
        CGFloat photosViewH = LMPhotoH;
        _originalPhotosViewF = CGRectMake(photosViewX, photosViewY, photosViewW, photosViewH);
        
        recViewH = CGRectGetMaxY(_originalPhotosViewF) + Padding;
    }else
    {
        recViewH = CGRectGetMaxY(_contentLabelF) + Padding;
        
    }
    
    //设置最下面的竖线
    CGFloat upImg1X = Padding;
    CGFloat upImg1Y = CGRectGetMaxY(_recViewF);
    CGFloat upImg1W = 20;
    CGFloat upImg1H = 13;
    _upImg1F = CGRectMake(upImg1X, upImg1Y, upImg1W, upImg1H);
    
    //topView
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = LMCellWidth;
    CGFloat topViewH = CGRectGetMaxY(_upImg1F);
    _topViewF = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
    
    //高度
    _cellHeight =  CGRectGetMaxY(_upImg1F);
    
}

@end
