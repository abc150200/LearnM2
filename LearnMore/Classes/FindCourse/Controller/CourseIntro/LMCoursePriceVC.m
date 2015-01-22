//
//  LMCoursePriceVC.m
//  LearnMore
//
//  Created by study on 15-1-12.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMCoursePriceVC.h"
#import "LMCoursePriceCell.h"
#import "LMOrderCommitViewController.h"
#import "LMCoursePrice.h"
#import "LMProductDetailVC.h"

@interface LMCoursePriceVC ()

@end

@implementation LMCoursePriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.priceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LMCoursePriceCell";
    LMCoursePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMCoursePriceCell" owner:nil options:nil] lastObject];
    }
    
    // 2.给cell传递模型
    cell.coursePrice = self.priceArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 3.返回cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCoursePrice *coursePrice = self.priceArr[indexPath.row];

//    LMOrderCommitViewController *ov = [[LMOrderCommitViewController alloc] init];
//    ov.productId = coursePrice.id;
//    ov.discountPrice = coursePrice.discountPrice;
//    ov.productName = coursePrice.productName;
//    ov.productTypeId = coursePrice.productTypeId;
//    [self.navigationController pushViewController:ov animated:YES];
    
    LMProductDetailVC *pv = [[LMProductDetailVC alloc] init];
    pv.productId = coursePrice.id;
    pv.discountPrice = coursePrice.discountPrice;
    pv.productName = coursePrice.productName;
    pv.productTypeId = coursePrice.productTypeId;
    [self.navigationController pushViewController:pv animated:YES];
}

@end
