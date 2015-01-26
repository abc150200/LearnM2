//
//  LMMyReserveViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMMyReserveViewController.h"
#import "LMMyReserveViewCell.h"
#import "LMActivityViewController.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AFNetworking.h"
#import "AESenAndDe.h"
#import "LMCourseBook.h"
#import "LMCourseListMainViewController.h"
#import "LMCourseIntroViewController.h"

@interface LMMyReserveViewController ()
@property (strong, nonatomic) IBOutlet UIView *firstView;

/**
 *  存放模型的数组
 */
@property (nonatomic, strong) NSArray *dataList;
@end

@implementation LMMyReserveViewController

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
    
    
//    if (!self.dataList.count) {
//        [self.tableView addSubview:self.firstView];
//        
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//    }else
//    {
//        [self.firstView removeFromSuperview];
//    }
//    
//    [self.tableView registerNib:[UINib nibWithNibName:@"LMMyReserveViewCell" bundle:nil] forCellReuseIdentifier:@"reserveViewCell"];
//    
//    self.tableView.rowHeight = 70;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"免费预约试听";
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"appointment/listCourse.json"];
        
        
        //参数
        NSMutableDictionary *arr = [NSMutableDictionary dictionary];
#warning 这些怎么用的
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
            
            NSString *bookStr = [AESenAndDe De_Base64andAESDeToString:responseObject[@"data"] keyValue:account.sessionkey];
            
            NSDictionary *dict = [bookStr objectFromJSONString];
            
            LogObj(dict);
            
            NSArray *courseArr = dict[@"courses"];
            
            self.dataList = [LMCourseBook objectArrayWithKeyValuesArray:courseArr];
            
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
    
    self.tableView.rowHeight = 70;
}

- (IBAction)foundBtn:(id)sender {
    
    LMCourseListMainViewController *lv = [[LMCourseListMainViewController alloc] init];
    
    [self.navigationController pushViewController:lv animated:YES];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMMyReserveViewCell *cell = [LMMyReserveViewCell cellWithTableView:tableView];
    
    cell.courseBook = self.dataList[indexPath.row];
  
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCourseBook *courseBook = self.dataList[indexPath.row];
    LMCourseIntroViewController *cvc = [[LMCourseIntroViewController alloc] init];
    cvc.id = courseBook.typeId;
    
    [self.navigationController pushViewController:cvc animated:YES];
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
