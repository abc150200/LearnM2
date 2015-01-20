//
//  LMProductCell.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMProductCell.h"
#import "LMProduct.h"

@interface LMProductCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation LMProductCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setProduct:(LMProduct *)product
{
    _product = product;
    self.label.font = [UIFont systemFontOfSize:11.5];
    self.label.text = product.title;
    self.imageView.image = [UIImage imageNamed:product.icon];
}



@end
