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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"全部";
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(cityViewController:level:id:)]) {
        [self.delegate cityViewController:self level:self.level id:self.id];
    }
}

@end
