//
//  LMCustomAnnotation.h
//  LearnMore
//
//  Created by study on 14-10-28.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LMCustomAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coords;
@end
