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
    
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
    UILabel *label  = [[UILabel alloc] init];
    label.width = 100;
    label.height = 40;
    label.centerX = self.view.centerX;
    label.y = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
    moreView.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
    [moreView addSubview:label];
    self.tableView.tableFooterView = moreView;
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

    NSString *title = self.listArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(listViewControllerDidClick: title: row:)]) {
        [self.delegate listViewControllerDidClick:self title:title row:indexPath.row];
    }
    
}


@end
