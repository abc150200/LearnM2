//
//  LMOneSchRecViewController.m
//  LearnMore
//
//  Created by study on 14-12-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMOneSchRecViewController.h"
#import "LMRecommend.h"
#import "LMRecommedFrame.h"
#import "LMDetailRecommendViewCell.h"


@interface LMOneSchRecViewController ()

@end

@implementation LMOneSchRecViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recomFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 1.创建cell
    LMDetailRecommendViewCell *cell = [LMDetailRecommendViewCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    LMRecommedFrame *recF = self.recomFrames[indexPath.row];
    cell.recommendFrame = recF;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 3.返回cell
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMRecommedFrame *recF = self.recomFrames[indexPath.row];
    MyLog(@"LMRecommedFrame===%f",recF.cellHeight);
    
    /** 以下两行发布通知 */
    NSDictionary *userInfo = @{@"SchoolCellHeight": @(recF.cellHeight)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OneRecSchoolNotification" object:nil userInfo:userInfo];
    
    return recF.cellHeight;
}






- (NSMutableArray *)recomFrames
{
    if (_recomFrames == nil) {
        _recomFrames = [NSMutableArray array];
    }
    return _recomFrames;
}

@end
