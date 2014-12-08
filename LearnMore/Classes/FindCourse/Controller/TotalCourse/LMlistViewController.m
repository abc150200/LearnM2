//
//  LMlistViewController.m
//  LearnMore
//
//  Created by study on 14-11-10.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMlistViewController.h"

@interface LMlistViewController ()

@end

@implementation LMlistViewController

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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *title = self.listArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(listViewControllerDidClick: title:)]) {
        [self.delegate listViewControllerDidClick:self title:title];
    }
    
}


@end
