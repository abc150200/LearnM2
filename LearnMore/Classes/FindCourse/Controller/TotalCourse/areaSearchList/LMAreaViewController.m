//
//  LMAreaViewController.m
//  LearnMore
//
//  Created by study on 14-11-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMAreaViewController.h"

@interface LMAreaViewController ()

@property (nonatomic, strong) NSArray *areas;

@end

@implementation LMAreaViewController


- (NSArray *)areas
{
    if (_areas == nil) {
        _areas = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"smallAreas.plist" ofType:nil]];;
    }
    return _areas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 30;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.areas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
   
//    NSDictionary *dict = self.areas[0];
//    NSArray *arr = dict[@"areas"];
//    NSDictionary *dict2 = arr[indexPath.row];
//    cell.textLabel.text = dict2[@"areaName"];
    

    NSDictionary *dict1 = self.areas[indexPath.row];
    cell.textLabel.text = dict1[@"areaName"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#warning 暂时传递给二级,以后再改

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接取城市数组
    if ([self.areaDelegate respondsToSelector:@selector(areaViewController:selectedCities:areaId:areaLevel: title:)]) {
        
        
//        NSArray *cities = self.areas[indexPath.row][@"cities"];
        
        NSArray *cities = self.areas;
        
#warning 暂时传递给二级,以后再改
        NSDictionary *dict = cities[indexPath.row];
        NSString *areaId = dict[@"id"];
        NSString *areaLevel = dict[@"level"];
        NSString *title = dict[@"areaName"];
        
        [self.areaDelegate areaViewController:self selectedCities:cities areaId:areaId areaLevel:areaLevel title:title];
    }
}





@end
