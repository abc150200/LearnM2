//
//  LMSchoolListViewController.m
//  LearnMore
//
//  Created by study on 14-11-27.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMSchoolListViewController.h"
#import "LMSchoolIntroViewController.h"
#import "AFNetworking.h"
#import "LMSchoolList.h"
#import "MJExtension.h"
#import "LMSchoolViewCell.h"
#import "MJRefresh.h"
#import "LMAccount.h"
#import "LMAccountInfo.h"

@interface LMSchoolListViewController ()
@property (nonatomic, weak) UIView *moreView;
@property (nonatomic, strong) NSMutableArray *courseLists;
@property (nonatomic, strong) NSMutableArray *schoolList;

@property (nonatomic, strong) NSMutableArray *keyArr;
@property (nonatomic, assign) int tCount;

@end

@implementation LMSchoolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加下拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    
    //主动显示菊花
    [self.tableView headerBeginRefreshing];
    
    //添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}


//下拉刷新
- (void)loadNewData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"school/list.json"];
    /** http://api.manytu.com/course/list.json?param={"area":"0_0"} */
    
    NSString *jsonStr = [self.arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    if(account)
    {
        parameters[@"sid"] = account.sid;
    }
    
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *courseDic = [responseObject[@"data"] objectFromJSONString];
                MyLog(@"%@",courseDic);
        
        NSArray *courseList = courseDic[@"schoolList"];
        
        
        self.courseLists = (NSMutableArray *)[LMSchoolList objectArrayWithKeyValuesArray:courseList];

        int count = [courseDic[@"tcount"] intValue];
        self.tCount = count;
        
    
        if(self.courseLists.count == 0)
        {
            UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
            self.moreView  = moreView;
            UILabel *label  = [[UILabel alloc] init];
            label.width = 100;
            label.height = 40;
            label.centerX = self.view.centerX;
            label.y = 0;
            label.text = @"暂无数据";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
            moreView.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
            [moreView addSubview:label];
            self.tableView.tableFooterView = moreView;
            [self.tableView reloadData];
            
        }else if (self.courseLists.count == count)
        {
            
            UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
            self.moreView  = moreView;
            UILabel *label  = [[UILabel alloc] init];
            label.width = 100;
            label.height = 40;
            label.centerX = self.view.centerX;
            label.y = 0;
//            label.text = @"已加载全部";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
            moreView.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
            [moreView addSubview:label];
            self.tableView.tableFooterView = moreView;
            [self.tableView reloadData];
        }else
        {
            [self.tableView reloadData];
        }
        
        // 3.关闭菊花
        [self.tableView headerEndRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
        // 3.关闭菊花
        [self.tableView headerEndRefreshing];
        
    }];
    
}

//上拉刷新
- (void)loadMoreData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"school/list.json"];
    
    if(self.courseLists.count < 20 || self.courseLists.count == self.tCount )
    {
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
        return;
        
    }
    
    int count = self.courseLists.count + 1;
    
    
    self.arr[@"startIndex"] = [NSString stringWithFormat:@"%d",count];
    
    
    NSString *jsonStr = [self.arr JSONString];
    MyLog(@"%@=======",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    if(account)
    {
        parameters[@"sid"] = account.sid;
    }
    
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *courseDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"%@",courseDic);
        
        NSArray *courseList = courseDic[@"schoolList"];
        
        
        
        NSArray *newListArr = [LMSchoolList objectArrayWithKeyValuesArray:courseList];
        
        [self.courseLists addObjectsFromArray:newListArr];
        
        int count = [courseDic[@"tcount"] intValue];
        
        if (self.courseLists.count == count)
        {
            
            UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
            self.moreView  = moreView;
            UILabel *label  = [[UILabel alloc] init];
            label.width = 100;
            label.height = 40;
            label.centerX = self.view.centerX;
            label.y = 0;
//            label.text = @"已加载全部";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
            moreView.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:1];
            [moreView addSubview:label];
            self.tableView.tableFooterView = moreView;
            [self.tableView reloadData];
            
        }else
        {
            [self.tableView reloadData];
        }
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
    }];

}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    LMSchoolViewCell *cell = [LMSchoolViewCell cellWithTableView:tableView];
    
    cell.schoolList = self.courseLists[indexPath.row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMSchoolViewCell *cell = (LMSchoolViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    LMSchoolIntroViewController *li = [[LMSchoolIntroViewController alloc] init];
    
    MyLog(@"id===%lli",li.id);
   
    li.id = cell.id;
    
    
    
    [self.navigationController pushViewController:li animated:YES];
}


- (NSMutableArray *)courseLists
{
    if (_courseLists == nil) {
        _courseLists = [NSMutableArray array];
    }
    return _courseLists;
}




@end
