//
//  LMMyOrderVC.m
//  LearnMore
//
//  Created by study on 15-1-9.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMMyOrderVC.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AFNetworking.h"
#import "AESenAndDe.h"

@interface LMMyOrderVC ()

@end

@implementation LMMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"收藏课程";
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"pay/orderList.json"];
        
        
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
            
            NSString *collectStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
            
            NSDictionary *dict = [collectStr objectFromJSONString];
            
            MyLog(@"dict===%@",dict);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
        }];
    }
    
    
    self.tableView.rowHeight = 88;
}


@end
