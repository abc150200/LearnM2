//
//  LMAgeViewController.m
//  LearnMore
//
//  Created by study on 14-11-20.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMAgeViewController.h"

@interface LMAgeViewController ()

@end

@implementation LMAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.rowHeight = 30;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.listArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == 0) {
        if ([self.delegate respondsToSelector:@selector(ageViewController:age: title:)]) {
            [self.delegate ageViewController:self age:0 title:@"0岁"];
        }
    }else
    {
        if ([self.delegate respondsToSelector:@selector(ageViewController:age: title:)]) {
            
            int age = [self.listArr[indexPath.row] intValue];
            NSString *title = [NSString stringWithFormat:@"%d岁",age];
            
            if(indexPath.row == 0)
            {
                [self.delegate ageViewController:self age:age title:@"年  龄"];
            }
            else
            {
                [self.delegate ageViewController:self age:age title:title];
            }
            
            
        }
        
    }
}

@end
