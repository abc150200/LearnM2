//
//  CZCityViewController.m
//  08-多控制器表格联动
//
//  Created by apple on 11/07/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "CZCityViewController.h"

@interface CZCityViewController ()

@end

@implementation CZCityViewController

- (void)setCities:(NSArray *)cities
{
    _cities = cities;
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 30;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *dict = self.cities[indexPath.row];
    
    cell.textLabel.text = dict[@"typeName"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.cities[indexPath.row];
    NSNumber *id = dict[@"id"];
    NSString *title = dict[@"typeName"];
    
    if ([self.delegate respondsToSelector:@selector(cityViewController:didSeclctedItem: title:)]) {
        [self.delegate cityViewController:self didSeclctedItem:id title:title];
    }
    

    
}

@end
