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

@interface LMMyCollectionViewController ()
/** 提示用户发现精彩活动的画面 */
@property (strong, nonatomic) IBOutlet UIView *firstView;
/**
 *  存放模型的数组
 */
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation LMMyCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    self.title = @"收藏课程";
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"favorite/listCourse.json"];
        
        
        //参数
        NSMutableDictionary *arr = [NSMutableDictionary dictionary];
        arr[@"startIndex"] = @"1";
        arr[@"count"] = @"5";
        arr[@"time"] = [self timeNow];
    
        NSString *jsonStr = [arr JSONString];
        MyLog(@"%@",jsonStr);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"sid"] = account.sid;
        parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            LogObj(responseObject);
            
            NSString *collectStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
            
            NSDictionary *dict = [collectStr objectFromJSONString];
            
//            MyLog(@"dict===%@",dict);
            
            NSArray *favArr = dict[@"favorites"];
         
            self.dataList = [LMCollectCourse objectArrayWithKeyValuesArray:favArr];
            
            if (self.dataList.count == 0) {
                [self.tableView addSubview:self.firstView];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            } else
            {
                [self.tableView reloadData];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
        }];
    }
    

    
    self.tableView.rowHeight = 88;
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

- (NSString *)timeNow
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0f", a];
}


/** 懒加载 */
- (NSArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSArray array];
    }
    return _dataList;
}


@end
