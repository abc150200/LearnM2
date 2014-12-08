//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 定义block */
typedef void(^TouchDone)(float score);

//@class TQStarRatingView;

//@protocol StarRatingViewDelegate <NSObject>

//@optional
//-(void)starRatingView:(TQStarRatingView *)view score:(float)score;

//@end

@interface TQStarRatingView : UIView

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number norImage:(NSString *)norImage highImage:(NSString *)highImage starSize:(CGFloat)starSize margin:(CGFloat)margin;
@property (nonatomic, readonly) int numberOfStar;
//@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@property (nonatomic, copy) TouchDone completion;


@end
