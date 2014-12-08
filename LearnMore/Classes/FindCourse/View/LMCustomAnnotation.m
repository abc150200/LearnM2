//
//  LMCustomAnnotation.m
//  LearnMore
//
//  Created by study on 14-10-28.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCustomAnnotation.h"

@implementation LMCustomAnnotation
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coords
{
    if (self = [super init]) {
        self.coordinate = coords;
    }
    return self;
}
@end
