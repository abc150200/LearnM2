//
//  LMMyCollectionViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMyCollectionViewController.h"
#import "LMCourseListMainViewController.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AFNetworking.h"
#import "AESenAndDe.h"
#import "LMCollectCourse.h"
#import "LMMyCollectionViewCell.h"
#import "LMLoginViewController.h"
#import "LMCourseIntroViewController.h"
#import "MJRefresh.h"

@interface LMMyCollectionViewController ()
/** 提示用户发现精彩活动的画面 */
@property (strong, nonatomic) IBOutlet UIView *firstView;
/**
 *  存放模型的数组
 */
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int tCount;

@end

@implementation LMMyCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    
    self.tableView.rowHeight = 88;
    
    //添加下拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    
    //主动显示菊花
    [self.tableView headerBeginRefreshing];
    
    //添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
  
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,40)];
    UILabel *label  = [[UILabel alloc] init];
    label.width = 100;
    label.height = 40;
    label.centerX = self.view.centerX;
    label.y = 0;
    //            label.text = @"已加载全部";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [moreView addSubview:label];
    self.tableView.tableFooterView = moreView;
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}


- (void)loadNewData
{
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"favorite/listCourse.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"startIndex"] = @"0";
    arr[@"count"] = @"10";
    arr[@"time"] = [NSString timeNow];
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sid"] = account.sid;
    parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSString *collectStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
        
        NSDictionary *dict = [collectStr objectFromJSONString];
        
        MyLog(@"dict===%@",dict);
        
        NSArray *favArr = dict[@"favorites"];
        
        int count = [dict[@"tcount"] intValue];
        self.tCount = count;
        
        self.dataList = [LMCollectCourse objectArrayWithKeyValuesArray:favArr];
        
        if (self.dataList.count == 0) {
            [self.tableView addSubview:self.firstView];
           
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        } else
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


- (void)loadMoreData
{
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"favorite/listCourse.json"];
    
    if(self.dataList.count < 10 || self.dataList.count == self.tCount )
    {
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
        return;
        
    }
    
    int count = self.dataList.count + 1;
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"count"] = @"10";
    arr[@"time"] = [NSString timeNow];
    arr[@"startIndex"] = [NSString stringWithFormat:@"%d",count];
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sid"] = account.sid;
    parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSString *collectStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
        
        NSDictionary *dict = [collectStr objectFromJSONString];
        
        MyLog(@"dict===%@",dict);
        
        NSArray *favArr = dict[@"favorites"];
        
        int count = [dict[@"tcount"] intValue];
        self.tCount = count;
        
        NSArray  *newDataList = [LMCollectCourse objectArrayWithKeyValuesArray:favArr];
        [self.dataList addObjectsFromArray:newDataList];
    
        [self.tableView reloadData];
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
    }];
    
}

- (IBAction)foundBtn {
    
    LMCourseListMainViewController *mv = [[LMCourseListMainViewController alloc] init];
    
    [self.navigationController pushViewController:mv animated:YES];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMMyCollectionViewCell *cell = [LMMyCollectionViewCell cellWithTableView:tableView];
    
    cell.collectCourse = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCollectCourse *collectCourse = self.dataList[indexPath.row];
    LMCourseIntroViewController *cvc = [[LMCourseIntroViewController alloc] init];
    cvc.id = collectCourse.typeId;
    
    [self.navigationController pushViewController:cvc animated:YES];
}




/** 懒加载 */
- (NSArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


@end
