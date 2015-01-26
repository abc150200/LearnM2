//
//  LMCourseRecommendViewController.m
//  LearnMore
//
//  Created by study on 14-11-26.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCourseRecommendViewController.h"
#import "LMHomeCourseViewCell.h"
#import "LMCourseIntroViewController.h"

@interface LMCourseRecommendViewController ()

@end

@implementation LMCourseRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LMHomeCourseViewCell *cell = [LMHomeCourseViewCell cellWithTableView:tableView];
    
    cell.courselist = self.courseLists[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMHomeCourseViewCell *cell = (LMHomeCourseViewCell *)[tableView cellForRowAtIndexPath:indexPath];
   
    if ([self.delegate respondsToSelector:@selector(courseRecommendViewController:id:)]) {
        [self.delegate courseRecommendViewController:self id:cell.id];
    }

}


- (NSArray *)courseLists
{
    if (_courseLists == nil) {
        _courseLists = [NSArray array];
    }
    return _courseLists;
}

@end
