//
//  LMMyOrderCourseVC.m
//  LearnMore
//
//  Created by fudong on 15/1/17.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMMyOrderCourseVC.h"
#import "LMCourseViewCell.h"
#import "LMCourseIntroViewController.h"

@interface LMMyOrderCourseVC ()

@end

@implementation LMMyOrderCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 98;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LMCourseViewCell *cell = [LMCourseViewCell cellWithTableView:tableView];
    
    cell.courselist = self.courseLists[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCourseViewCell *cell = (LMCourseViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    int needBook = cell.needBook;
    
    LMCourseIntroViewController *li = [[LMCourseIntroViewController alloc] init];
    
    li.title = @"课程介绍";
    li.needBook = needBook;
    li.id = cell.id;
    
    
    [self.navigationController pushViewController:li animated:YES];
}


- (NSMutableArray *)courseLists
{
    if (_courseLists == nil) {
        _courseLists = [NSMutableArray array];
    }
    return _courseLists;
}




@end
