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
    NSDictionary *dict = self.listArr[indexPath.row];
    cell.textLabel.text = dict[@"ageName"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.listArr[indexPath.row];
    NSString *title = dict[@"ageName"];
    NSString *ageId = dict[@"ageID"];
   
        if ([self.delegate respondsToSelector:@selector(ageViewController:age: title:)]) {
      
            if(indexPath.row == 0)
            {
                [self.delegate ageViewController:self age:ageId title:@"年  龄"];
            }
            else
            {
                [self.delegate ageViewController:self age:ageId title:title];
            }
            
            
        }
        
    
}

@end
