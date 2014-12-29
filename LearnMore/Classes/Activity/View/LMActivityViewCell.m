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


@end

@implementation LMActivityViewCell

- (void)awakeFromNib
{
    self.actImageView.clipsToBounds = YES;
    self.actImageView.layer.cornerRadius = 5;
    self.actImageView.backgroundColor = [UIColor lightGrayColor];
    self.addressLabel.textColor = UIColorFromRGB(0x9ac72c);
    
    self.actImageView.layer.borderColor = UIColorFromRGB(0xc7c7c7).CGColor;
    self.actImageView.layer.borderWidth = 1.0f;
    
    
    self.activityBig.clipsToBounds = YES;
    self.activityBig.layer.cornerRadius = 5;

    
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
    
}

//- (NSString *)intervalSinceFuture:(long long)futureDate now:(long long)nowDate
//{
//
//    NSString *timeString=nil;
//    
//    NSTimeInterval cha=(futureDate - nowDate)/1000;
//
//    
//    if (cha/86400>1)
//    {
//        timeString = [NSString stringWithFormat:@"%f", cha/86400];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"剩余%@天", timeString];
//        
//    }else if (cha/3600>1&&cha/86400<1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/3600];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"剩余%@小时", timeString];
//    }else
//    {
//        timeString=[NSString stringWithFormat:@"已过期"];
//    }
//    
//    return timeString;
//}




@end
