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

@interface LMMyRecViewController ()
@property (nonatomic, strong) NSMutableArray *recomFrames;
@end

@implementation LMMyRecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDate];
    
    }


- (void)loadDate
{
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/userCommentList.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
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
        
        
        [self.tableView reloadData];

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
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


- (NSMutableArray *)recomFrames
{
    if (_recomFrames == nil) {
        _recomFrames = [NSMutableArray array];
    }
    return _recomFrames;
}


@end
