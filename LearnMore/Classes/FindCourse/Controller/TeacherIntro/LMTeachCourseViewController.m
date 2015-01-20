//
//  LMTeachCourseViewController.m
//  LearnMore
//
//  Created by study on 14-12-15.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMTeachCourseViewController.h"
#import "LMTeacherCouse.h"
#import "LMTeacherCourseCell.h"
#import "LMCourseIntroViewController.h"

@interface LMTeachCourseViewController ()

@end

@implementation LMTeachCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 93;
    
    self.tableView.bounces = NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LMTeacherCourseCell";

    LMTeacherCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMTeacherCourseCell" owner:self options:nil] lastObject];
    }
    
    LMTeacherCouse *course = self.datas[indexPath.row];
    
    cell.teachCourse = course;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMTeacherCouse *tCourse = self.datas[indexPath.row];
    
    long long id = tCourse.id;
    
    
    LMCourseIntroViewController *ci  = [[LMCourseIntroViewController alloc] init];
    ci.id = id;
    
    [self.navigationController pushViewController:ci animated:YES];
    
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



@end
