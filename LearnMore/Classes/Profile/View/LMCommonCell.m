//
//  LMCommonCell.m
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCommonCell.h"
#import "LMCommonItemArrow.h"
#import "LMCommonItemLabel.h"

@interface LMCommonCell ()

@property(nonatomic, strong)UILabel *accessoryLabel;
@property(nonatomic, strong)UIImageView *accessoryImage;

@end


@implementation LMCommonCell

#pragma mark - 快速创建方法
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    LMCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LMCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.设置标题的字体大小
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.accessoryLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return self;
}


/** 设置数据 */
- (void)setItem:(LMCommonItem *)item
{
    _item = item;
    
    //设置图片
    self.imageView.image = [UIImage imageNamed:item.icon];
    
    //设置标题
    self.textLabel.text = _item.title;
    
    //设置子标题
    self.detailTextLabel.text = _item.subtitle;
    
    //根据模型设置cell右边的辅助视图
    [self setupRightView];
}

/** 设置右边的辅助视图 */
- (void)setupRightView
{
    if ([self.item isKindOfClass:[LMCommonItemArrow class]]) {
        self.accessoryView = self.accessoryImage;
    } else if ([self.item isKindOfClass:[LMCommonItemLabel class]])
    {
        self.accessoryView = self.accessoryLabel;
        //设置label上需要显示的内容
        LMCommonItemLabel *labelItem = (LMCommonItemLabel *)self.item;
        self.accessoryLabel.text = labelItem.text;
        //计算label的宽高
        self.accessoryLabel.size = [labelItem.text sizeWithFont:self.accessoryLabel.font];
    }
    else
    {
        self.accessoryView = nil;
    }
}


/** 懒加载 */

- (UIImageView *)accessoryImage
{
    if (_accessoryImage == nil) {
        _accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    return _accessoryImage;
}


- (UILabel *)accessoryLabel
{
    if (_accessoryLabel == nil) {
        _accessoryLabel = [[UILabel alloc] init];
    }
    return _accessoryLabel;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.item.subtitle) {
        //调整子标题的位置
        self.accessoryView.x = CGRectGetMaxX(self.detailTextLabel.frame) + 5;
    }
    
}
@end
