//
//  LMMyRecFrame.h
//  LearnMore
//
//  Created by study on 14-12-16.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMMyRec;

@interface LMMyRecFrame : NSObject

@property (nonatomic, strong) LMMyRec *myRec;

/** 顶部的view */
@property (nonatomic, assign, readonly) CGRect topViewF;
@property (nonatomic, assign, readonly) CGRect upImgF;
@property (nonatomic, assign, readonly) CGRect downImgF;
/** 时间 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;

/** 点评内容 */
@property (nonatomic, assign, readonly) CGRect recViewF;
/** 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/** 评分 */
@property (nonatomic, assign, readonly) CGRect recLabelF;
/** 标题 */
@property (nonatomic, assign, readonly) CGRect titleLabelF;
/** 线条 */
@property (nonatomic, assign, readonly) CGRect dividerF;
/** 配图的frame */
@property (nonatomic, assign, readonly) CGRect originalPhotosViewF;


@property (nonatomic, assign, readonly) CGRect upImg1F;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;




@end
