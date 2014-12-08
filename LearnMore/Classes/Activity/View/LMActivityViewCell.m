//
//  LMActivityViewCell.m
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMActivityViewCell.h"
#import "LMActList.h"

@interface LMActivityViewCell ()



@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *actImageView;

@property (weak, nonatomic) IBOutlet UIButton *freeBtn;
@end

@implementation LMActivityViewCell

- (void)awakeFromNib
{
    self.actImageView.clipsToBounds = YES;
    self.actImageView.layer.cornerRadius = 5;
    self.actImageView.backgroundColor = [UIColor lightGrayColor];
    

    self.freeBtn.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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


- (IBAction)book:(id)sender {
    
    
#warning 在ViewDidLoad 已让其失去交互
    
    if([self.delegate respondsToSelector:@selector(activityViewCellDidClickBtn:)])
    {
        [self.delegate activityViewCellDidClickBtn:self];
    }
    
}

-(void)setActlist:(LMActList *)actlist
{
    _actlist = actlist;
    
    self.titleLabel.text = _actlist.actTitle;
    self.schoolNameLabel.text = _actlist.schoolName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",_actlist.actBeginTime,_actlist.actEndTime];
    

    [self.actImageView sd_setImageWithURL:[NSURL URLWithString:_actlist.actImage] placeholderImage:[UIImage imageNamed:@"activity"]];
    self.id = _actlist.id;
}

@end
