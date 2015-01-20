//
//  LMRefundReasonListVC.m
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMRefundReasonListVC.h"
#import "LMRefundReasonCell.h"
#import "LMRefundReason.h"


@interface LMRefundReasonListVC ()
@property (nonatomic, strong) NSMutableArray *currentArray;
@property (nonatomic, strong) NSMutableArray *secondArray;
@end

@implementation LMRefundReasonListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44.0f;
    
    _currentArray = [[NSMutableArray alloc] init];
    
    _secondArray = [[NSMutableArray alloc] init];
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
    LMRefundReason *refundReason = self.reasonArr[indexPath.row];
    cell.refundReason = refundReason;
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
//    [button addTarget:self action:@selector(onCheck:) forControlEvents:UIControlEventTouchUpInside];
//    BOOL isSelect = NO;
//    for (NSString *name in _currentArray) {
//        NSString *nameStr = refundReason.reasonName;
//        if ([name isEqualToString:nameStr]) {
//            [button setBackgroundImage:[UIImage imageNamed:@"refund_pressed"] forState:UIControlStateNormal];
//            isSelect = YES;
//            cell.tag = 1;
//        }
//    }
//    if (!isSelect) {
//        [button setBackgroundImage:[UIImage imageNamed:@"refund_normal"] forState:UIControlStateNormal];
//        cell.tag = 0;
//    }
//    button.tag = [indexPath row];
//    button.frame = CGRectMake(0, 0, 18, 18);
//    cell.accessoryView = button;
//    return cell;
    
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMRefundReasonCell *cell = (LMRefundReasonCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.btn.selected = !(cell.btn.selected);
}


//-(void)onCheck:(id)sender{
//    
//    UIButton *button = (UIButton *)sender;
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
//    if (cell.tag == 0) {
//        cell.tag = 1;
//        [button setBackgroundImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateNormal];
//        NSString *checkedName = [firstArray objectAtIndex:button.tag];
//        for (NSString *name in currentArray) {
//            if ([name isEqualToString:checkedName]) {
//                return;
//            }
//        }
//        [currentArray addObject:checkedName];
//    }else if (cell.tag == 1) {
//        cell.tag = 0;
//        [button setBackgroundImage:[UIImage imageNamed:@"Unselected.png"] forState:UIControlStateNormal];
//        NSString *checkedName = [firstArray objectAtIndex:button.tag];
//        for (NSString *name in currentArray) {
//            if ([name isEqualToString:checkedName]) {
//                [currentArray removeObject:name];
//                return;
//            }
//        }
//    }
//    
//}

@end
