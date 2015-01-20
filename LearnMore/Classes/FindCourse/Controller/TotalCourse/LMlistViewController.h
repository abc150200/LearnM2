//
//  LMlistViewController.h
//  LearnMore
//
//  Created by study on 14-11-10.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMlistViewController;

//自定义代理
@protocol LMlistViewControllerDelegate <NSObject>

@optional
- (void)listViewControllerDidClick:(LMlistViewController *)listViewController title:(NSString *)title row:(int)row;

@end


@interface LMlistViewController : UITableViewController
@property (nonatomic, strong) NSArray *listArr;
@property (nonatomic, weak) id<LMlistViewControllerDelegate> delegate;
@end
