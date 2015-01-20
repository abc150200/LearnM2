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
        
        NSString *areaStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"areaKey"];
        NSArray *areaArr = [areaStr objectFromJSONString];
        MyLog(@"areaArr=====%@",areaArr);
        
        NSDictionary *dict = areaArr[0];
        
        NSArray *areaStr1 = dict[@"areas"];
        MyLog(@"areaStr1===%@",areaStr1);
        
        _areas = areaStr1;
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

    NSDictionary *dict1 = self.areas[indexPath.row];
    cell.textLabel.text = dict1[@"areaName"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.areaDelegate respondsToSelector:@selector(areaViewController:selectedCities: row:)]) {
        NSDictionary *areaBig = self.areas[indexPath.row];
        NSString *id = areaBig[@"id"];
        NSString *areaName = areaBig[@"areaName"];
        NSString *level = areaBig[@"level"];
        
        NSArray *cities = self.areas[indexPath.row][@"areas"];
    
        NSMutableArray *arrM = [NSMutableArray array];
        if(![areaName isEqualToString:@"附近"])
        {
            arrM[0] = @{@"id":id,@"areaName":areaName,@"level":level};
        }
        for (NSDictionary *dict in cities) {
            [arrM addObject:dict];
        }
        
        
        
        int row = indexPath.row;
        
        [self.areaDelegate areaViewController:self selectedCities:arrM row:row];
    }
    
    if ([self.areaDelegate respondsToSelector:@selector(areaViewController:didSelectRow:)]) {
        
        [self.areaDelegate areaViewController:self didSelectRow:indexPath.row];
    }
}





@end
