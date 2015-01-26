//
//  LMSettingViewController.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMBaseTableViewController.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"

@interface LMBaseTableViewController ()

@end

@implementation LMBaseTableViewController

- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置tableView
    [self setupTableView];
   
}

- (void)setupTableView
{
    //设置分组间隙
    self.tableView.sectionHeaderHeight = 15;
    self.tableView.sectionFooterHeight = 0;
    
//    //设置tableView的额外滚动区域
//    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    
}


#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LMCommonGroup *group = self.groups[section];
    
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    LMCommonCell *cell = [LMCommonCell cellWithTableView:tableView];
    
    LMCommonGroup *group = self.groups[indexPath.section];
    
    // 2.给cell传递模型
    cell.item = group.items[indexPath.row];
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出选中的行模型
    LMCommonGroup *group = self.groups[indexPath.section];
    LMCommonItem *item = group.items[indexPath.row];
    
    //判断是否有目标控制器
    if (item.destVc) {
        UIViewController *destVc = [[item.destVc alloc] init];
        [self.navigationController pushViewController:destVc animated:YES];
    }
    
    //判断模型中是否有指定的代码
    if (item.option) {
        item.option();
    }
    
}

- (LMCommonGroup *)addGroup
{
    LMCommonGroup *group = [LMCommonGroup group];
    [self.groups addObject:group];
    return group;
}

/** 懒加载 */

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}
@end
