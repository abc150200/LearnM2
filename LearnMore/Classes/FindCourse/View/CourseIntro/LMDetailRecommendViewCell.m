//
//  LMDetailRecommendViewCell.m
//  LearnMore
//
//  Created by study on 14-12-2.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//
#define LMUserFont [UIFont systemFontOfSize:12]
#define LMTimeFont [UIFont systemFontOfSize:12]
#define LMContentFont [UIFont systemFontOfSize:14]

#import "LMDetailRecommendViewCell.h"
#import "LMRecommend.h"
#import "LMRecommedFrame.h"
#import "LMPhotosView.h"
#import "TQStarRatingDisplayView.h"

@interface LMDetailRecommendViewCell ()

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UILabel *userLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIView *userImgView;
@property (nonatomic, weak) LMPhotosView *photosView;

@end


@implementation LMDetailRecommendViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        //顶部VIew
        UIView *topView = [[UIView alloc] init];
        [self.contentView addSubview:topView];
        self.topView = topView;
        
        //用户名
        UILabel *userLabel = [[UILabel alloc] init];
        userLabel.font = LMUserFont;
        userLabel.textColor = [UIColor blackColor];
        [self.topView addSubview:userLabel];
        self.userLabel = userLabel;
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = LMTimeFont;
        timeLabel.textColor = [UIColor grayColor];
        [self.topView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //文本
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = LMContentFont;
        contentLabel.textColor = [UIColor blackColor];
        [self.topView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        contentLabel.numberOfLines = 0;
        
        //配图容器
        LMPhotosView *photosView = [[LMPhotosView alloc] init];
        [self.topView addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}

-(void)setRecommendFrame:(LMRecommedFrame *)recommendFrame
{
    _recommendFrame = recommendFrame;
    
    // 1.设置数据
    [self settingData];
    
    // 2.设置frame
    [self settingFrame];
}

/**
 *  设置数据
 */
- (void)settingData
{
    LMRecommend *recommend = self.recommendFrame.recommend;
    NSMutableString *str = [[NSMutableString alloc] initWithString:recommend.contactPhone];
    [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.userLabel.text = str;
    self.timeLabel.text = [NSString timeWithLong:recommend.createTime];
    self.contentLabel.text = recommend.commentText;
    
    NSMutableArray *arrM = [NSMutableArray array];
    if ([recommend.images hasPrefix:@"http"]) {
        NSArray* arr = [recommend.images componentsSeparatedByString:@","];
        for (NSString *str in arr) {
            if([str hasPrefix:@"http"])
                [arrM addObject:str];
            
            self.photosView.photos = arrM;
        }
    }else
    {
        self.photosView.photos = 0;
    }
    
    
    CGRect rect = CGRectMake(self.contentView.width - 85, 15, 70, 14);
    
    NSDictionary *dict = recommend.level;
    NSString *str1 = dict[@"totalLevel"];
    TQStarRatingDisplayView *star = [[TQStarRatingDisplayView alloc] initWithFrame:rect numberOfStar:5 norImage:@"public_review_small_normal" highImage:@"public_review_small_pressed" starSize:14 margin:0 score:str1];
    [self.contentView addSubview:star];
    
    
}

/**
 *  设置frame
 */
- (void)settingFrame
{
    self.topView.frame = self.recommendFrame.topViewF;
    self.userLabel.frame = self.recommendFrame.userLabelF;
    self.timeLabel.frame = self.recommendFrame.timeLabelF;
    self.contentLabel.frame = self.recommendFrame.contentLabelF;
    
    self.photosView.frame = self.recommendFrame.originalPhotosViewF;
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"recommend";
    LMDetailRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LMDetailRecommendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

@end
