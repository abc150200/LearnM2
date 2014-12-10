//
//  LMReserveViewController.m
//  LearnMore
//
//  Created by study on 14-10-13.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMReserveViewController.h"
#import "LMAccount.h"
#import "LMAccountInfo.h"
#import "AESenAndDe.h"
#import "MBProgressHUD+NJ.h"
#import "AFNetworking.h"
#import "LMReserveOverViewController.h"
#import "LMActBookViewController.h"
#import "LMLoginViewController.h"


@interface LMReserveViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *ageLabel;//年龄
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;//名称
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;//手机
@property (weak, nonatomic) IBOutlet UITextField *contactNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *stuMan;
@property (weak, nonatomic) IBOutlet UIButton *stuWoman;

@property (weak, nonatomic) IBOutlet UIButton *parMan;
@property (weak, nonatomic) IBOutlet UIButton *parWoman;

@property (nonatomic, strong) UIButton *stuSelectedBtn;

@property (nonatomic, strong) UIButton *parSelectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookStuInfo;

@end

@implementation LMReserveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.delegate = self;
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
    
    self.phoneLabel.text = account.userPhone;
    
    self.bookTitle.text = self.courseName;
    
    if (self.from == FromeAct) {
        
        self.bookStuInfo.text = @"报名学生信息";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 170);
}

- (IBAction)stuMan:(id)sender {
    
     self.stuMan.selected = YES;
    self.stuWoman.selected = NO;
    
    self.stuSelectedBtn = self.stuMan;
}

- (IBAction)stuWoman:(id)sender {
 
    self.stuWoman.selected = YES;
    
    self.stuMan.selected = NO;
    
    self.stuSelectedBtn = self.stuWoman;
}

- (IBAction)parMan:(id)sender {
    self.parMan.selected = YES;
    self.parWoman.selected = NO;
    
    self.parSelectedBtn = self.parMan;
}

- (IBAction)parWoman:(id)sender {
    self.parWoman.selected = YES;
    self.parMan.selected = NO;
    
    self.parSelectedBtn = self.parWoman;
}


/** scrollView的代理方法 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollView endEditing:YES];
}

- (IBAction)commit:(id)sender {
    
    LMAccount *account = [LMAccountInfo sharedAccountInfo ].account;
   
    if (account) {
        
        
        if (self.from == FromCourse) {
        
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            
            //url地址
            NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"appointment/bookCourse.json"];
            
            
            //参数
            NSMutableDictionary *arr = [NSMutableDictionary dictionary];
            arr[@"id"] = [NSString stringWithFormat:@"%lli",self.id];
            arr[@"name"] = self.nameLabel.text;
#warning 需要调整
            arr[@"sex"] = [NSString stringWithFormat:@"%d",self.stuSelectedBtn.tag];
            MyLog(@"===需要调整====%d",self.stuSelectedBtn.tag);
            arr[@"age"] = self.ageLabel.text;
            arr[@"contactName"] = self.contactNameLabel.text;
            arr[@"contactSex"] = [NSString stringWithFormat:@"%d",self.parSelectedBtn.tag];
            arr[@"mobile"] = self.phoneLabel.text;
            
            NSString *jsonStr = [arr JSONString];
            MyLog(@"%@",jsonStr);
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"sid"] = account.sid;
            parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                LogObj(responseObject);
                
                long long code = [responseObject[@"code"] longLongValue];
                
                switch (code) {
                    case 10001:
                    {
                        [MBProgressHUD showSuccess:@"预约成功"];
                        LMReserveOverViewController *bv = [[LMReserveOverViewController alloc] init];
                        bv.title = @"介绍";
                        bv.stuName = self.nameLabel.text;
                        bv.age = [self.ageLabel.text intValue];
                        bv.schoolName = self.schoolName;
                        bv.courseName = self.courseName;
                        bv.setting = @"免费试听预约";
                        bv.sex = self.stuSelectedBtn.tag;
                        [self.navigationController pushViewController:bv animated:YES];
                    }
                        
                        break;
                        
                    case 30002:
                        [MBProgressHUD showError:@"用户未登录或超时,请重新登录"];
                        break;
                        
                    case 61002:
                        [MBProgressHUD showError:@"用户已收藏"];
                        break;
                        
                    case 42005:
                        [MBProgressHUD showError:@"联系人名字不能为空"];
                        break;
                        
                    case 42018:
                        [MBProgressHUD showError:@"联系人性别错误"];
                        break;
                        
                    case 42014:
                        [MBProgressHUD showError:@"联系人手机号码格式不正确/空"];
                        break;
                        
                    default:
                        [MBProgressHUD showError:@"服务器异常,报名失败"];
                        break;
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LogObj(error.localizedDescription);
            }];

        } else
        {

            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            
            //url地址
            NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"appointment/bookActivity.json"];
            
            
            //参数
            NSMutableDictionary *arr = [NSMutableDictionary dictionary];
            arr[@"id"] = [NSString stringWithFormat:@"%lli",self.id];
            arr[@"name"] = self.nameLabel.text;
            arr[@"sex"] = [NSString stringWithFormat:@"%d",self.stuSelectedBtn.tag];
            arr[@"age"] = self.ageLabel.text;
            arr[@"contactName"] = self.contactNameLabel.text;
            arr[@"contactSex"] =[NSString stringWithFormat:@"%d",self.parSelectedBtn.tag];
            arr[@"mobile"] = self.phoneLabel.text;
            
            
            NSString *jsonStr = [arr JSONString];
            MyLog(@"%@",jsonStr);
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"sid"] = account.sid;
            parameters[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                LogObj(responseObject);
                
                long long code = [responseObject[@"code"] longLongValue];
                
                switch (code) {
                    case 10001:
                    {
                        
                        [MBProgressHUD showSuccess:@"报名成功"];
                        LMActBookViewController *bv = [[LMActBookViewController alloc] init];
                        bv.title = @"活动报名";
                        bv.stuName = self.nameLabel.text;
                        bv.age = [self.ageLabel.text intValue];
                        bv.actTitle = self.courseName;
                        bv.sex = self.stuSelectedBtn.tag;
                        bv.schoolName = self.schoolName;
                        [self.navigationController pushViewController:bv animated:YES];
                    }
                        
                        break;
                        
                    case 30002:
                        [MBProgressHUD showError:@"用户未登录或超时,请重新登录"];
                        break;
                        
                    case 61001:
                        [MBProgressHUD showError:@"活动人数已报满"];
                        break;
                        
                    case 61002:
                        [MBProgressHUD showError:@"重复报名"];
                        break;
                        
                    case 42005:
                        [MBProgressHUD showError:@"联系人名字不能为空"];
                        break;
                        
                    case 42018:
                        [MBProgressHUD showError:@"联系人性别错误"];
                        break;
                        
                    case 42014:
                        [MBProgressHUD showError:@"联系人手机号码格式不正确/空"];
                        break;
                        
                    default:
                        [MBProgressHUD showError:@"服务器异常,报名失败"];
                        break;
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LogObj(error.localizedDescription);
            }];

        }
        
        
        
        
    }else
    {
        LMLoginViewController *lg = [[LMLoginViewController alloc] init];
        [self.navigationController pushViewController:lg animated:YES];
    }
    
}


@end
