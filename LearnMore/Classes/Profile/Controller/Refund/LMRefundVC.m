//
//  LMrefundVC.m
//  LearnMore
//
//  Created by study on 15-1-15.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMRefundVC.h"
#import "AFNetworking.h"
#import "LMRefundType.h"
#import "LMRefundTypeListVC.h"
#import "LMRefundReasonListVC.h"
#import "LMRefundReason.h"
#import "LMRefundReasonCell.h"
#import "AFNetworking.h"
#import "LMAccount.h"
#import "LMAccountInfo.h"
#import "AESenAndDe.h"
#import "MBProgressHUD+NJ.h"

@interface LMRefundVC ()
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) LMRefundTypeListVC *tl;
@property (nonatomic, strong) LMRefundReasonListVC *rl;
@property (strong, nonatomic) IBOutlet UIView *refundSeasonTitle;
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (strong, nonatomic) IBOutlet UIView *btnView;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation LMRefundVC

- (void)viewDidLoad {
    
    self.title  = @"申请退款";
    
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    self.scrollView.backgroundColor = UIColorFromRGB(0xe1e1e1);
    self.scrollView.bounces = NO;
    
    [self.scrollView addSubview:self.headView];
  
    MyLog(@"self.headView.frame===%@",NSStringFromCGRect(self.headView.frame));
    
    //添加退款方式
    LMRefundTypeListVC *tl = [[LMRefundTypeListVC alloc] initWithStyle:UITableViewStylePlain];
    tl.view.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), self.view.width, 44);
    [self.scrollView addSubview:tl.view];
    self.tl = tl;
    
    //退款原因标题
    [self.scrollView addSubview:self.refundSeasonTitle];
    self.refundSeasonTitle.frame = CGRectMake(0, CGRectGetMaxY(self.tl.view.frame), self.view.width, 44);
    
    //退款原因
    LMRefundReasonListVC *rl = [[LMRefundReasonListVC alloc] initWithStyle:UITableViewStylePlain];
    rl.view.frame = CGRectMake(0, CGRectGetMaxY(self.refundSeasonTitle.frame), self.view.width, 44 * 7);
    [self.scrollView addSubview:rl.view];
    self.rl = rl;
    
    [self.scrollView addSubview:self.btnView];
    self.btnView.frame = CGRectMake(0, CGRectGetMaxY(self.rl.view.frame) + 70,self.view.width,self.btnView.height);
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.btnView.frame) + 60 );
    
    [self refundData];
    
    
    //部分数据
    self.courseNameLabel.text = self.courseName;
    self.productNameLabel.text = self.productName;
    NSInteger totalPrice = self.discountPrice * self.productCount;
    self.moneyLabel.text = [NSString stringWithFormat:@"%d",totalPrice];
    
}


- (void)refundData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"commons/refund.json"];
    
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);
        
        //类型列表
        NSArray *typeArr = [LMRefundType objectArrayWithKeyValuesArray:responseObject[@"refundTypeList"]];
        self.tl.typeArr = typeArr;
        [self.tl.tableView reloadData];
        
        self.tl.view.height = 44 * (typeArr.count);
        self.refundSeasonTitle.y = CGRectGetMaxY(self.tl.view.frame);
        
        //原因列表
        NSArray *reasonArr = [LMRefundReason objectArrayWithKeyValuesArray:responseObject[@"refundReasonList"]];
        self.rl.reasonArr  = reasonArr;
        [self.rl.tableView reloadData];
        
        self.rl.view.height = 44 * (reasonArr.count);
        
        self.btnView.y = CGRectGetMaxY(self.rl.view.frame) + 70;
        
        self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.btnView.frame) + 60 );

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];

}

- (IBAction)btnClick:(id)sender {
    
    [MBProgressHUD showMessage:@"正在处理..."];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.rl.reasonArr.count; i++) {
        LMRefundReasonCell *reaSonCell = (LMRefundReasonCell *)[self.rl.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (reaSonCell.btn.selected) {
            MyLog(@"name===%d",reaSonCell.id);
            [array addObject:@(reaSonCell.id)];
        }
    }
    NSString *resonStr = [array componentsJoinedByString:@","];
    MyLog(@"resonStr===%@",resonStr);
    
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    if (account) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"pay/refundOrder.json"];
        
        
        //参数
        NSMutableDictionary *arr = [NSMutableDictionary dictionary];
        arr[@"orderId"] = self.orderId;
        arr[@"refundType"] = @"1";
        arr[@"refundReason"] = resonStr;
        arr[@"time"] = [NSString timeNow];
        arr[@"refundFee"] = [NSString stringWithFormat:@"%d",self.refundFee];
        
        NSString *jsonStr = [arr JSONString];
        MyLog(@"jsonStr=============%@",jsonStr);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"sid"] = account.sid;
        parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];

        MyLog(@"parameters==============%@",parameters);
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            MyLog(@"responseObject===============%@",responseObject);
            
            NSInteger code = [responseObject[@"code"] longValue];
            if (code == 10001 ) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"申请成功"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
        }];
    }
    
}



@end
