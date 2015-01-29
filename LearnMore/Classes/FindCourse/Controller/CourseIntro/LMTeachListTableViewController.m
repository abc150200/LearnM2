//
//  LMTeachListTableViewController.m
//  LearnMore
//
//  Created by study on 14-11-3.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMTeachListTableViewController.h"
#import "LMTeacherInfo.h"
#import "LMCourseTeachCell.h"
#import "LMTeacherIntroViewController.h"

@interface LMTeachListTableViewController ()<UIScrollViewDelegate>

@end

@implementation LMTeachListTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.rowHeight = 70;
    self.tableView.bounces = NO;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teachers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LMCourseTeachCell";
    LMCourseTeachCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMCourseTeachCell" owner:nil options:nil] lastObject];
    }
    
    LMTeacherInfo *teachList = self.teachers[indexPath.row];
    cell.teacherInfo = teachList;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCourseTeachCell *cell = (LMCourseTeachCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    long long teacherId = cell.teacherId;
    
    LMTeacherIntroViewController *teach = [[LMTeacherIntroViewController alloc] init];
    teach.id = teacherId;
    
    [self.navigationController pushViewController:teach animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView.contentOffset.y == 0)
    {
        self.tableView.scrollEnabled = NO;
    }
    else
    {
        self.tableView.scrollEnabled = YES;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y == 0)
    {
        self.tableView.scrollEnabled = NO;
    }
    else
    {
        self.tableView.scrollEnabled = YES;
    }
}

@end
