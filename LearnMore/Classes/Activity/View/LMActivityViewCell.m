//
//  LMActivityViewCell.m
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMActivityViewCell.h"
#import "LMActList.h"
#import "LMAddrList.h"
#import <CoreLocation/CoreLocation.h>

@interface LMActivityViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *actImageView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

/** 下边背景 */
@property (weak, nonatomic) IBOutlet UIImageView *activityBig;

@property (weak, nonatomic) IBOutlet UILabel *lateLabel;

/** 访问者 */
@property (weak, nonatomic) IBOutlet UILabel *visitLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation LMActivityViewCell

- (void)awakeFromNib
{
    self.actImageView.clipsToBounds = YES;
    self.actImageView.layer.cornerRadius = 5;
    self.actImageView.backgroundColor = [UIColor lightGrayColor];
    
    self.addressLabel.textColor = UIColorFromRGB(0x9ac72c);
    [self.addressLabel setShadowColor:UIColorFromRGB(0x9ac72c)];
    [self.addressLabel setShadowOffset:CGSizeMake(-0.3, -0.3)];
    
    self.distanceLabel.textColor = UIColorFromRGB(0x9ac72c);
    [self.distanceLabel setShadowColor:UIColorFromRGB(0x9ac72c)];
    [self.distanceLabel setShadowOffset:CGSizeMake(-0.3, -0.3)];
    
    self.actImageView.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
    self.actImageView.layer.borderWidth = 0.5f;
    
    
    self.activityBig.clipsToBounds = YES;
    self.activityBig.layer.cornerRadius = 5;

    [self.schoolNameLabel setShadowColor:[UIColor darkGrayColor]];
    [self.schoolNameLabel setShadowOffset:CGSizeMake(-1, -1)];
    
    [self.timeLabel setShadowColor:[UIColor darkGrayColor]];
    [self.timeLabel setShadowOffset:CGSizeMake(-1, -1)];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"actViewCell";
    LMActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMActivityViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}




-(void)setActlist:(LMActList *)actlist
{
    _actlist = actlist;
    
    NSArray *addrList = actlist.addrList;
    if (addrList.count == 1) {
       LMAddrList *addr  = addrList[0];
        self.addressLabel.text = addr.address;
    }else if (addrList.count > 1)
    {
     self.addressLabel.text = @"多商圈";
    }
    
    
    self.schoolNameLabel.text = _actlist.schoolName;
   
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@", [NSString timeFmtWithLong:_actlist.actBeginTime] ,[NSString timeFmtWithLong:_actlist.actEndTime]];
    


    [self.actImageView sd_setImageWithURL:[NSURL URLWithString:_actlist.actImage] placeholderImage:[UIImage imageNamed:@"activity"]];
    self.id = _actlist.id;
    
    
    self.lateLabel.text = _actlist.leftDays;
    
    self.visitLabel.text = [NSString stringWithFormat:@"%lli",actlist.visitCount] ;
//    self.visitLabel.textColor = [UIColor orangeColor];
    
    //距离
    NSArray *distances = _actlist.addrList;
    LMAddrList *disDic = distances[0];
    NSString *acrGps = disDic.gps;
    
    NSArray *arr1 = [acrGps componentsSeparatedByString:@","];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:[arr1[1] doubleValue]  longitude:[arr1[0] doubleValue]];
    
    NSString *gpsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"localGps"];
    NSArray *arr2 = [gpsStr componentsSeparatedByString:@","];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[arr2[0] doubleValue] longitude:[arr2[1] doubleValue]];
    
    // 2.计算2个位置的直线距离(CLLocationDistance单位是m)
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    NSLog(@"%.0f", distance);
    
    if (distance >= 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",distance/1000];
    }else
    {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.0fm",distance];
    }
    
}





@end
