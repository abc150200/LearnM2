//
//  LMProductCell.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMProductCell.h"
#import "LMCourseType.h"

@interface LMProductCell()

@property (nonatomic, assign) NSNumber *id;

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

- (void)setCourseType:(LMCourseType *)courseType
{
    _courseType = courseType;
    self.label.font = [UIFont systemFontOfSize:13];
    self.label.text = courseType.typeName;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:courseType.typeIcon] placeholderImage:[UIImage imageNamed:@"380,210"]];
    self.id = courseType.id;
}



@end
