//
//  LMMyRecViewCell.m
//  LearnMore
//
//  Created by study on 14-12-16.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMTimeFont [UIFont systemFontOfSize:14]
#define LMContentFont [UIFont systemFontOfSize:14]
#define LMTitleFont [UIFont systemFontOfSize:14]
#define LMRecLabelFont [UIFont systemFontOfSize:12]

#import "LMMyRecViewCell.h"
#import "LMMyRecPhotosView.h"
#import "LMMyRecFrame.h"
#import "LMMyRec.h"
#import "TQStarRatingDisplayView.h"
#import "LMLevel.h"

@interface LMMyRecViewCell ()

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) LMMyRecPhotosView *photosView;
@property (nonatomic, weak) UIImageView *upImg;
@property (nonatomic, weak) UIImageView *downImg;
@property (nonatomic, weak) UIImageView *recView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *divider;
@property (nonatomic, weak) UILabel *recLabel;
@property (nonatomic, weak) UIImageView *upImg1;


@end

@implementation LMMyRecViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //顶部VIew
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [self.contentView addSubview:topView];
        self.topView = topView;
        
        
        UIImageView *upImg = [[UIImageView alloc] init];
        upImg.image = [UIImage imageNamed:@"my_review1"];
        [self.topView addSubview:upImg];
        self.upImg = upImg;
        
        UIImageView *downImg =[[UIImageView alloc] init];
        downImg.image = [UIImage imageNamed:@"my_review"];
        [self.topView addSubview:downImg];
        self.downImg = downImg;
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = LMTimeFont;
        timeLabel.textColor = [UIColor grayColor];
        [self.topView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //点评内容
        UIImageView *recView =[[UIImageView alloc] init];
        recView.image = [UIImage resizableImageWithName:@"my_review_bg"];
        [self.topView addSubview:recView];
        self.recView = recView;
        recView.userInteractionEnabled = YES;
        
        //课程标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = LMTitleFont;
        titleLabel.textColor = [UIColor blackColor];
        [self.recView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //线条
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = [UIColor lightGrayColor];
        divider.alpha = 0.5;
        [self.recView addSubview:divider];
        self.divider = divider;
        
        //评分label
        UILabel *recLabel = [[UILabel alloc] init];
        recLabel.font = LMRecLabelFont;
        recLabel.textColor = [UIColor orangeColor];
        [self.recView addSubview:recLabel];
        self.recLabel = recLabel;
        
        //内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = LMContentFont;
        contentLabel.textColor = [UIColor blackColor];
        [self.recView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        contentLabel.numberOfLines = 0;
        
        
        //配图容器
        LMMyRecPhotosView *photosView = [[LMMyRecPhotosView alloc] init];
        [self.recView addSubview:photosView];
        self.photosView = photosView;
        
        //最下面
        UIImageView *upImg1 = [[UIImageView alloc] init];
        upImg1.image = [UIImage imageNamed:@"my_review1"];
        [self.topView addSubview:upImg1];
        self.upImg1 = upImg1;
        
        
    }
    
    return self;
}

- (void)setRecFrame:(LMMyRecFrame *)recFrame
{
    _recFrame = recFrame;
    
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
    LMMyRec *myRec = self.recFrame.myRec;
    
    self.id = myRec.id;
    self.typeId = myRec.typeId;
    self.commentType = myRec.commentType;
    
    self.timeLabel.text = [NSString timeWithLong:myRec.createTime];
    self.titleLabel.text = myRec.typeName;
    
    LMLevel *dict = myRec.level;
    self.recLabel.text = dict.totalLevel;
    
    CGRect rect = CGRectMake(25,96,90,14);
    TQStarRatingDisplayView *star = [[TQStarRatingDisplayView alloc] initWithFrame:rect numberOfStar:5 norImage:@"public_review_small_normal" highImage:@"public_review_small_pressed" starSize:14 margin:0 score:self.recLabel.text];
    [self.topView addSubview:star];
    
    self.contentLabel.text = myRec.commentText;
    
    NSMutableArray *arrM = [NSMutableArray array];
    if ([myRec.images hasPrefix:@"http"]) {
        NSArray* arr = [myRec.images componentsSeparatedByString:@","];
        for (NSString *str in arr) {
            if([str hasPrefix:@"http"])
                [arrM addObject:str];
            
            self.photosView.photos = arrM;
        }
    }else
    {
        self.photosView.photos = 0;
    }
}

/** self.photosView.photos = [myRec.images componentsSeparatedByString:@","]; */

/**
 *  设置frame
 */
- (void)settingFrame
{
    self.topView.frame = self.recFrame.topViewF;
    self.recView.frame = self.recFrame.recViewF;
    self.upImg.frame = self.recFrame.upImgF;
    self.downImg.frame = self.recFrame.downImgF;
    self.timeLabel.frame = self.recFrame.timeLabelF;
    self.titleLabel.frame = self.recFrame.titleLabelF;
    self.divider.frame = self.recFrame.dividerF;
    self.recLabel.frame = self.recFrame.recLabelF;
    self.contentLabel.frame = self.recFrame.contentLabelF;
    self.photosView.frame = self.recFrame.originalPhotosViewF;
    self.upImg1.frame = self.recFrame.upImg1F;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"myRec";
    LMMyRecViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LMMyRecViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
@end
