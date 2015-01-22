//
//  LMMyRecViewController.m
//  LearnMore
//
//  Created by study on 14-12-15.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMyRecViewController.h"
#import "AFNetworking.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AESenAndDe.h"
#import "LMMyRec.h"
#import "LMMyRecFrame.h"
#import "LMMyRecViewCell.h"
#import "LMCourseIntroViewController.h"
#import "MJRefresh.h"
#import "LMSchoolIntroViewController.h"
#import "LMCourseListMainViewController.h"

@interface LMMyRecViewController ()
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (nonatomic, strong) NSMutableArray *recomFrames;
@property (nonatomic, assign) int tCount;
@end

@implementation LMMyRecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的点评";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    //添加下拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    
    //主动显示菊花
    [self.tableView headerBeginRefreshing];
    
    //添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
}


- (void)loadNewData
{
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/userCommentList.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"startIndex"] = @"0";
    arr[@"count"] = @"5";
    arr[@"time"] = [NSString timeNow];
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sid"] = account.sid;
    parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSString *actStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
        
        NSDictionary *dict = [actStr objectFromJSONString];
        LogObj(dict);
        
        NSArray *recomArr = [LMMyRec objectArrayWithKeyValuesArray:dict[@"comments"]];
        NSMutableArray *frameModels = [NSMutableArray arrayWithCapacity:recomArr.count];
        for (LMMyRec *recom in recomArr) {
            LMMyRecFrame *recomFrame = [[LMMyRecFrame alloc] init];
            recomFrame.myRec = recom;
            [frameModels addObject:recomFrame];
        }
        
        self.recomFrames = frameModels;
        
        int count = [dict[@"tcount"] intValue];
        self.tCount = count;
        
        if (self.recomFrames.count == 0) {
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
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/userCommentList.json"];
    
    if (self.recomFrames.count < 10 || self.recomFrames.count == self.tCount ) {
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
        return;
    }
    
    int count = self.recomFrames.count + 1;
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"count"] = @"5";
    arr[@"time"] = [NSString timeNow];
    arr[@"startIndex"] = [NSString stringWithFormat:@"%d",count];
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sid"] = account.sid;
    parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSString *actStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
        
        NSDictionary *dict = [actStr objectFromJSONString];
        LogObj(dict);
        
        NSArray *recomArr = [LMMyRec objectArrayWithKeyValuesArray:dict[@"comments"]];
        NSMutableArray *frameModels = [NSMutableArray arrayWithCapacity:recomArr.count];
        for (LMMyRec *recom in recomArr) {
            LMMyRecFrame *recomFrame = [[LMMyRecFrame alloc] init];
            recomFrame.myRec = recom;
            [frameModels addObject:recomFrame];
        }
        
        [self.recomFrames addObjectsFromArray: frameModels];
        
        
        [self.tableView reloadData];
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
    }];
    
}

- (IBAction)foundBtn:(id)sender {
    
    LMCourseListMainViewController *mv = [[LMCourseListMainViewController alloc] init];
    
    [self.navigationController pushViewController:mv animated:YES];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recomFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 1.创建cell
    LMMyRecViewCell *cell = [LMMyRecViewCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    LMMyRecFrame *recF = self.recomFrames[indexPath.row];
    cell.recFrame = recF;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 3.返回cell
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMMyRecFrame *recF = self.recomFrames[indexPath.row];
    return recF.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LMMyRecViewCell *cell = (LMMyRecViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    int commentType = cell.commentType;
    
    #warning commentType = 1;搞清楚!!!
    if (commentType == 1) {
        LMCourseIntroViewController *li = [[LMCourseIntroViewController alloc] init];
        li.id = cell.typeId;
        [self.navigationController pushViewController:li animated:YES];
    }else if (commentType == 3)
    {
        LMSchoolIntroViewController *si = [[LMSchoolIntroViewController alloc] init];
        si.id = cell.typeId;
        [self.navigationController pushViewController:si animated:YES];
    }
    


}


- (NSMutableArray *)recomFrames
{
    if (_recomFrames == nil) {
        _recomFrames = [NSMutableArray array];
    }
    return _recomFrames;
}


@end
