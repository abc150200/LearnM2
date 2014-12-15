//
//  LMSchoolTeacherViewControllerTableViewController.m
//  LearnMore
//
//  Created by study on 14-12-15.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMSchoolTeacherViewController.h"
#import "LMSchoolTeacherCell.h"
#import "LMTeachList.h"
#import "LMTeacherIntroViewController.h"


@interface LMSchoolTeacherViewController ()

@end

@implementation LMSchoolTeacherViewController

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
    static NSString *ID = @"LMSchoolTeacherCell";
    LMSchoolTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMSchoolTeacherCell" owner:nil options:nil] lastObject];
    }
    
    LMTeachList *teachList = self.teachers[indexPath.row];
    cell.teacherList = teachList;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMTeachList *teachList = self.teachers[indexPath.row];
    
    long long teacherId = teachList.id;
    
    LMTeacherIntroViewController *ti = [[LMTeacherIntroViewController alloc] init];
    
    ti.id = teacherId;
    
    [self.navigationController pushViewController:ti animated:YES];
    
}


@end
