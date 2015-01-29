//
//  LMSchoolCourseViewController.m
//  LearnMore
//
//  Created by study on 14-12-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMSchoolCourseViewController.h"
#import "LMSchoolCourseViewCell.h"
#import "LMSchoolCourse.h"
#import "LMCourseInfo.h"
#import "LMCourseIntroViewController.h"

@interface LMSchoolCourseViewController ()<UIScrollViewDelegate>

@end

@implementation LMSchoolCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 93;
    
    self.tableView.bounces = NO;
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LMSchoolCourseViewCell";
    
    
    LMSchoolCourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMSchoolCourseViewCell" owner:self options:nil] lastObject];
    }
    
    LMCourseInfo *course = self.datas[indexPath.row];
    
    cell.course = course;
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCourseInfo *tCourse = self.datas[indexPath.row];
    
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
