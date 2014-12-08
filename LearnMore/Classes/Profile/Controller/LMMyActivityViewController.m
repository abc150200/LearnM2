//
//  LMMyActivityViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMyActivityViewController.h"
#import "LMMyActivityViewCell.h"
#import "LMActivityViewController.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AFNetworking.h"
#import "AESenAndDe.h"
#import "LMActivityDetailViewController.h"

#import "LMMyActivityViewCell.h"
#import "LMActBook.h"


@interface LMMyActivityViewController ()
@property (strong, nonatomic) IBOutlet UIView *firstView;
/**
 *  存放模型的数组
 */
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation LMMyActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
   
        
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"我的活动";
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"appointment/listActivity.json"];
        
        
        //参数
        NSMutableDictionary *arr = [NSMutableDictionary dictionary];
        arr[@"startIndex"] = @"1";
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
            
            NSArray *favArr = dict[@"courses"];

            self.dataList = [LMActBook objectArrayWithKeyValuesArray:favArr];
            
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
  
    
    self.tableView.rowHeight = 79;
}



- (IBAction)foundBtn:(id)sender {
    
    LMActivityViewController *ac = [[LMActivityViewController alloc] init];
    [self.navigationController pushViewController:ac animated:YES];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMMyActivityViewCell *cell = [LMMyActivityViewCell cellWithTableView:tableView];
    
    cell.actBook = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMActBook *act = self.dataList[indexPath.row];
    LMActivityDetailViewController *ac = [[LMActivityDetailViewController alloc] init];
    ac.id = act.typeId;
    [self.navigationController pushViewController:ac animated:YES];
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
