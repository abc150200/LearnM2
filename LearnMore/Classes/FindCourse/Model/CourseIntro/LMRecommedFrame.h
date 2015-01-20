//
//  LMRecommedFrame.h
//  LearnMore
//
//  Created by study on 14-12-2.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMRecommend;

@interface LMRecommedFrame : NSObject
@property (nonatomic, strong) LMRecommend *recommend;


/** 顶部的view */
@property (nonatomic, assign, readonly) CGRect topViewF;
/** 用户名 */
@property (nonatomic, assign, readonly) CGRect userLabelF;
/** 时间 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;
/** 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;


/** 配图的frame */
@property (nonatomic, assign, readonly) CGRect originalPhotosViewF;

@end
