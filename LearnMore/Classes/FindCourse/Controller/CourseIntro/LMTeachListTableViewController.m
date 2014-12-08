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

@interface LMTeachListTableViewController ()

@end

@implementation LMTeachListTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.rowHeight = 70;
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

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCourseTeachCell *cell = (LMCourseTeachCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    long long teacherId = cell.teacherId;
    
    if ([self.delegate respondsToSelector:@selector(teachListTableViewController:teacherId:)]) {
        [self.delegate teachListTableViewController:self teacherId:teacherId];
    }
    
}

@end
