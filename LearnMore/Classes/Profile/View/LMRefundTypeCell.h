//
//  LMRefundTypeCell.h
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMRefundType;

@interface LMRefundTypeCell : UITableViewCell
@property (nonatomic, strong) LMRefundType *refundType;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, assign) NSInteger id;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *typeDes;

@end
