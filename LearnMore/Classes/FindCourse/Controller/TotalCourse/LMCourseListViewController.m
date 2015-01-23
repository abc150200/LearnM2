//
//  LMCourseListViewController.m
//  LearnMore
//
//  Created by study on 14-11-27.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCourseListViewController.h"
#import "LMCourseViewCell.h"
#import "LMCourseIntroViewController.h"
#import "AFNetworking.h"
#import "LMCourseList.h"
#import "MJExtension.h"
#import "LMCourseViewCell.h"
#import "MJRefresh.h"
#import "LMAccount.h"
#import "LMAccountInfo.h"
#import "MTA.h"

@interface LMCourseListViewController ()
@property (nonatomic, weak) UIView *moreView;
@property (nonatomic, assign) int tCount;

@end

@implementation LMCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //下拉刷新控件
    [self setupRefresh];
    
    
  
}


//下拉刷新
- (void)setupRefresh
{
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
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"course/list.json"];
    /** http://api.manytu.com/course/list.json?param={"area":"0_0"} */

    self.arr[@"startIndex"] = @"0";
    NSString *jsonStr = [self.arr JSONString];
    MyLog(@"jsonStr=下拉刷新=============%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
#warning 在sid失效的时候会崩!
    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    if(account)
    {
        parameters[@"sid"] = account.sid;
        
    }
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *courseDic = [responseObject[@"data"] objectFromJSONString];
                MyLog(@"%@",courseDic);
        
        NSArray *courseList = courseDic[@"courseList"];
        
        
        
        self.courseLists = (NSMutableArray *)[LMCourseList objectArrayWithKeyValuesArray:courseList];
        
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
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"course/list.json"];
    
    if(self.courseLists.count < 10 || self.courseLists.count == self.tCount )
    {
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
        return;
        
    }
    
    int count = self.courseLists.count + 1;
    
    self.arr[@"startIndex"] = [NSString stringWithFormat:@"%d",count];
    
    
    NSString *jsonStr = [self.arr JSONString];
    MyLog(@"==课程上拉刷新参数%@=======",jsonStr);
    
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
        

        NSArray *courseList = courseDic[@"courseList"];
        
        NSArray *newListArr = [LMCourseList objectArrayWithKeyValuesArray:courseList];
        
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
    
    LMCourseViewCell *cell = [LMCourseViewCell cellWithTableView:tableView];
    
    cell.courselist = self.courseLists[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCourseViewCell *cell = (LMCourseViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    int needBook = cell.needBook;
    
    LMCourseIntroViewController *li = [[LMCourseIntroViewController alloc] init];
    
    li.title = @"课程介绍";
    li.needBook = needBook;
    li.id = cell.id;
    li.toSchoolId = cell.schoolId;
    
    //行为分析
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    NSDictionary *dict = nil;
    if (account) {
        NSString *userPhone = account.userPhone;
        dict = @{@"phone":userPhone,@"device":deviceInfo,@"course":[NSString stringWithFormat:@"%lli",cell.id],@"school":[NSString stringWithFormat:@"%d",cell.schoolId]};
    }else
    {
        dict = @{@"device":deviceInfo,@"course":[NSString stringWithFormat:@"%lli",cell.id],@"school":[NSString stringWithFormat:@"%d",cell.schoolId]};
    }
    [MTA trackCustomKeyValueEvent:@"event_course_list_click" props:dict];
    
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
