//
//  LMchangePwdViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMchangePwdViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+NJ.h"

 static  int timeCount = 0;

@interface LMchangePwdViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *user;     //用户名
@property (weak, nonatomic) IBOutlet UITextField *pwd;      //密码
@property (weak, nonatomic) IBOutlet UITextField *txtAuth; // 验证码


@property (weak, nonatomic) IBOutlet UIButton *auth;       //提交

@property (nonatomic, strong) NSTimer *countDownTimer; //定时器

@end

@implementation LMchangePwdViewController

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
    
    self.title = @"找回密码";
    
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor colorWithRed:180 green:180 blue:180 alpha:1];
    
    [self.user endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 100);
    [self.user becomeFirstResponder];
    
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollView endEditing:YES];
}

//验证
- (IBAction)phoneClick:(id)sender {
    
    timeCount = 60;
    
    self.auth.userInteractionEnabled = NO;
    
    
    NSTimer *countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
    
    self.countDownTimer = countDownTimer;
    
    
    if(![self isMobileNumber:self.user.text]){
        [self alertWithMessage:@"请输入正确的手机号"];
        
    }else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"reg/mobilecode.json"];
        
        //参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = self.user.text;
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LogObj(responseObject);
            
            long long code = [responseObject[@"code"] longLongValue];
            switch (code) {
                case 10001:
                    [MBProgressHUD showSuccess:@"发送成功"];
                    break;
                    
                case 42014:
                    [MBProgressHUD showError:@"手机号码格式不正确/空"];
                    break;
                    
                case 42021:
                    [MBProgressHUD showError:@"短信验证失败"];
                    break;
                    
                case 42022:
                    [MBProgressHUD showError:@"间隔时间太短,请5分钟之后再验证"];
                    break;
                    
                default:
                    [MBProgressHUD showError:@"服务器异常"];
                    break;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
            
        }];
        
    }
    
    
    
}


- (IBAction)commit:(id)sender {
    
    
    
    if(![self isMobileNumber:self.user.text])
    {
        [self alertWithMessage:@"手机号不存在"];
        return;
    }
    
    if( [self.pwd.text isEqualToString:@""]  )
    {
        [self alertWithMessage:@"用户名或密码不能空！"];
        
        return;
    }
    
    [MBProgressHUD showMessage:@"正在登录中...."];
    
    //发送请求
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"user/forget.json"];
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = self.user.text;
    parameters[@"newPwd"] = self.pwd.text;
    parameters[@"checkCode"] = self.txtAuth.text;
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LogObj(responseObject);
        
        long long code = [responseObject[@"code"] longLongValue];
        
        switch (code) {
            case 10001:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"提交成功,请登录"];
                [self.navigationController popViewControllerAnimated:YES];
            }
                
                break;
                
            case 30001:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"用户不存在"];
            }
                break;
                
            case 30005:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"验证码不正确"];
            }
                
                break;
                
            case 42008:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"验证码不能为空"];
            
            }
                
                break;
                
            case 42009:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"验证码不匹配"];
            }

                break;
                
            default:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"服务器异常,请稍后再试"];
            
            }
                
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
    }];
    
    
}


- (void)timerFireMethod
{
    timeCount--;
     [self.auth setTitle:[NSString stringWithFormat:@"%d秒",timeCount] forState:UIControlStateNormal];
    if (timeCount == 0 ) {
        [self.auth setTitle:@"验证" forState:UIControlStateNormal];
        self.auth.userInteractionEnabled = YES;
        [self.countDownTimer invalidate];
    }
}



//判断是否是电话号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//弹警告框
- (void)alertWithMessage:(NSString *)string{
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"提示", nil)
                              message:NSLocalizedString(string, nil)
                              delegate:self
                              cancelButtonTitle:@"确定！"
                              otherButtonTitles:nil,
                              nil];
    alertView.delegate = self;
    [alertView show];
}

@end
