//
//  CZProvinceViewController.m
//  08-多控制器表格联动
//
//  Created by apple on 11/07/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "CZProvinceViewController.h"

@interface CZProvinceViewController ()
@property (nonatomic, strong) NSArray *provinces;


@end

@implementation CZProvinceViewController

- (NSArray *)provinces
{
    if (!_provinces) {
        _provinces = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"courseTypes.plist" ofType:nil]];
    }
    return _provinces;
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
    return self.provinces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSDictionary *dict = self.provinces[indexPath.row];
    cell.textLabel.text = dict[@"typeName"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接取城市数组
    if ([self.provinceDelegate respondsToSelector:@selector(provinceViewController:selectedCities: row:)]) {
        NSArray *cities = self.provinces[indexPath.row][@"courseTypes"];
        
        int row = indexPath.row;
        
        [self.provinceDelegate provinceViewController:self selectedCities:cities row:row];
    }
}

@end
