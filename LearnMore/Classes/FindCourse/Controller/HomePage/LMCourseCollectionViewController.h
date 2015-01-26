//
//  LMCourseCollectionViewController.h
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMCourseCollectionViewController;

//自定义代理
@protocol LMCourseCollectionViewControllerDelegate <NSObject>

@optional
- (void)courseCollectionViewController:(LMCourseCollectionViewController * )courseCollectionViewController title:(NSString *)title productId:(NSNumber *)productId;

@end


@interface LMCourseCollectionViewController : UICollectionViewController

//标题数组
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, weak) id<LMCourseCollectionViewControllerDelegate> delegate;

@end


