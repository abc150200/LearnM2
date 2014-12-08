//
//  LMDetailRecommendViewController.m
//  LearnMore
//
//  Created by study on 14-12-2.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMDetailRecommendViewController.h"
#import "AFNetworking.h"
#import "LMRecommend.h"
#import "LMRecommedFrame.h"
#import "LMDetailRecommendViewCell.h"
#import "LMPhotosView.h"
#import "TQStarRatingDisplayView.h"
#import "MJRefresh.h"

@interface LMDetailRecommendViewController ()
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;

@property (copy, nonatomic) NSString *levelTotal;
@property (weak, nonatomic) IBOutlet UILabel *level1Label;
@property (weak, nonatomic) IBOutlet UILabel *level2Label;
@property (weak, nonatomic) IBOutlet UILabel *level3Label;
@property (weak, nonatomic) IBOutlet UILabel *level4Label;

@property (copy, nonatomic) NSString *totalScore;

@property (nonatomic, strong) NSMutableArray *recomArr;

@property (nonatomic, strong) NSMutableArray *recomFrames;
@end

@implementation LMDetailRecommendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"点评详情";
    
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = self.footView;
    
    self.mainTitleLabel.text = self.mainTitle;
    
    self.levelTotal = self.courseScoreDic[@"avgTotalLevel"];
    self.level1Label.text = self.courseScoreDic[@"avgLevel1"];
    self.level2Label.text= self.courseScoreDic[@"avgLevel2"];
    self.level3Label.text = self.courseScoreDic[@"avgLevel3"];
    self.level4Label.text = self.courseScoreDic[@"avgLevel4"];
    
    //添加下拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    
    //主动显示菊花
    [self.tableView headerBeginRefreshing];
    
    //添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
//    [self loadData];
    
    TQStarRatingDisplayView *star = [[TQStarRatingDisplayView alloc] initWithFrame:CGRectMake(83,53,70, 14)  numberOfStar:5 norImage:@"public_review_small_normal" highImage:@"public_review_small_pressed" starSize:14 margin:0 score:self.levelTotal];
    
    [self.headView addSubview:star];
}


- (void)loadNewData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/list.json"];
    
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
    arr[@"type"] = @"1";
    arr[@"time"] = [NSString timeNow];
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"%@",dateDic);
        
        NSArray *recomArr = [LMRecommend objectArrayWithKeyValuesArray:dateDic[@"comments"]];
        NSMutableArray *frameModels = [NSMutableArray arrayWithCapacity:recomArr.count];
        for (LMRecommend *recom in recomArr) {
            LMRecommedFrame *recomFrame = [[LMRecommedFrame alloc] init];
            recomFrame.recommend = recom;
            [frameModels addObject:recomFrame];
        }
        
        self.recomFrames = frameModels;
       

        [self.tableView reloadData];
        
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/list.json"];
    
    if (self.recomFrames.count < 20) {
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
        return;
    }
    
    int count = self.recomFrames.count + 1;
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
    arr[@"type"] = @"1";
    arr[@"time"] = [NSString timeNow];
    arr[@"startIndex"] = [NSString stringWithFormat:@"%d",count];
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"%@",dateDic);
        
        NSArray *recomArr = [LMRecommend objectArrayWithKeyValuesArray:dateDic[@"comments"]];
        NSMutableArray *frameModels = [NSMutableArray arrayWithCapacity:recomArr.count];
        for (LMRecommend *recom in recomArr) {
            LMRecommedFrame *recomFrame = [[LMRecommedFrame alloc] init];
            recomFrame.recommend = recom;
            [frameModels addObject:recomFrame];
        }

         [self.recomFrames addObjectsFromArray:frameModels];
        
        [self.tableView reloadData];
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
        // 3.关闭菊花
        [self.tableView footerEndRefreshing];
    }];
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recomFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    // 1.创建cell
    LMDetailRecommendViewCell *cell = [LMDetailRecommendViewCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    LMRecommedFrame *recF = self.recomFrames[indexPath.row];
    cell.recommendFrame = recF;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 3.返回cell
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMRecommedFrame *recF = self.recomFrames[indexPath.row];
    return recF.cellHeight;
}



- (NSMutableArray *)recomArr
{
    if (_recomArr == nil) {
        _recomArr = [NSMutableArray array];
    }
    return _recomArr;
}


- (NSMutableArray *)recomFrames
{
    if (_recomFrames == nil) {
        _recomFrames = [NSMutableArray array];
    }
    return _recomFrames;
}

@end
