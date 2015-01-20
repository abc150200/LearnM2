//
//  LMMyActivityViewCell.m
//  LearnMore
//
//  Created by study on 14-10-15.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMyActivityViewCell.h"
#import "LMActBook.h"


@interface LMMyActivityViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation LMMyActivityViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    LMMyActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMMyActivityViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)setActBook:(LMActBook *)actBook
{
    _actBook = actBook;
    
    self.titleLabel.text =_actBook.actTitle;
    self.timeLabel.text = [NSString stringWithFormat:@"%@~%@",[NSString timeFmtWithLong:_actBook.actBeginTime],[NSString timeFmtWithLong:_actBook.actEndTime]];
}


@end
