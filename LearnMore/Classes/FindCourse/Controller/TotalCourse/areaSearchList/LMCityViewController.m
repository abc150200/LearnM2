//
//  LMCityViewController.m
//  LearnMore
//
//  Created by study on 14-11-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCityViewController.h"

@interface LMCityViewController ()

@end

@implementation LMCityViewController


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
    
    if (self.row != 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"全部";

        } else {
            cell.textLabel.text = dict[@"areaName"];
        }
    } else {
        cell.textLabel.text = dict[@"areaName"];
    }
   
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *dict = self.cities[indexPath.row];
    NSString *id = dict[@"id"];
    NSString *title = dict[@"areaName"];
    NSString *level = dict[@"level"];
    
    if ([self.delegate respondsToSelector:@selector(cityViewController:level: id: title:)]) {
        
        [self.delegate cityViewController:self level:level id:id title:title];
    }
    
//    if (indexPath.row == 0) {
//        
//        
//        
//    }else
//    {
//        
//        
//    
//    }
    
    
}

@end
