//
//  LMMapViewController.m
//  LearnMore
//
//  Created by study on 14-10-28.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LMCustomAnnotation.h"
#import "LMMapViewController.h"

@interface LMMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longtitude;

@end

@implementation LMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    CLLocationDegrees latitude = self.latitudeText.doubleValue;
    //    CLLocationDegrees longtitude = self.longtitudeText.doubleValue;
    //
    //    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
    
    //    MKMapView *mapView = [[MKMapView alloc] initWithFrame:[self.view bounds]];
    //    mapView.showsUserLocation = YES;
    //    mapView.mapType = MKMapTypeStandard;
    //    self.mapView = mapView;
    //    [self.view addSubview:mapView];
    
    for (NSDictionary *dict in self.adressArr) {
        
        NSArray *arr = [dict[@"gps"] componentsSeparatedByString:@","];
        CLLocationDegrees latitude = [arr[1] doubleValue];
        self.latitude = latitude;
        CLLocationDegrees longtitude = [arr[0] doubleValue];
        self.longtitude = longtitude;
        
        self.mapView.showsUserLocation = YES;
        
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latitude,longtitude);
        
        float zoomLevel = 0.1;
        MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        
        NSString *title = dict[@"address"];
        
        [self createAnnotationWithCoords:coords title:title];
    }
  
    
}
- (IBAction)backClick:(id)sender {
    
    NSDictionary *dict1 = self.adressArr[0];
    
    NSArray *arr = [dict1[@"gps"] componentsSeparatedByString:@","];
    CLLocationDegrees latitude = [arr[1] doubleValue];
    self.latitude = latitude;
    CLLocationDegrees longtitude = [arr[0] doubleValue];
    self.longtitude = longtitude;
    
    self.mapView.showsUserLocation = YES;
    
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latitude,longtitude);
    
    float zoomLevel = 0.1;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    NSString *title = dict1[@"address"];
    
    [self createAnnotationWithCoords:coords title:title];
    
//    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(self.latitude,self.longtitude);
//    
//    float zoomLevel = 0.01;
//    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//    
//    [self createAnnotationWithCoords:coords title:@"当前位置"];
}

//一键返回
- (IBAction)locate:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//创建大头针
- (void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords title:(NSString *)title
{
    LMCustomAnnotation *anotation = [[LMCustomAnnotation alloc] initWithCoordinate:coords];
    

    anotation.title = title;
    
#warning 为什么不能自动显示大头针
    [self.mapView selectAnnotation:anotation animated:YES];
    
    [self.mapView addAnnotation:anotation];

}

////自动显示气泡
//-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    MKPinAnnotationView * piview = (MKPinAnnotationView *)[views objectAtIndex:0];
//    
//    [self.mapView selectAnnotation:piview.annotation animated:YES];
//}

@end
