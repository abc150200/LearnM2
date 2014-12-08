//
//  LMMainTableViewController.m
//  LearnMore
//
//  Created by study on 14-11-27.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMainTableViewController.h"

@interface LMMainTableViewController ()

@end

@implementation LMMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // 设置表格的y值
    self.tableView.y = 107;
    if (!iOS8) {
        self.tableView.y = 43;
    }
    self.tableView.height = [UIScreen mainScreen].bounds.size.height - 107;
    if (!iOS8) {
        self.tableView.height = [UIScreen mainScreen].bounds.size.height - 43;
    }
   
    self.tableView.rowHeight = 88;
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 10, 0);
}


@end
