//
//  LMRefundReasonListVC.m
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMRefundReasonListVC.h"
#import "LMRefundReasonCell.h"


@interface LMRefundReasonListVC ()

@end

@implementation LMRefundReasonListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44.0f;
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reasonArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LMRefundReasonCell";
    LMRefundReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMRefundReasonCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 2.给cell传递模型
    cell.refundReason = self.reasonArr[indexPath.row];
    
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMRefundReasonCell *cell = (LMRefundReasonCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.btn.selected = !(cell.btn.selected);
}


@end
