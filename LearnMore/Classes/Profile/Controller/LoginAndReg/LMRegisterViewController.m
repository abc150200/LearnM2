//
//  LMRegisterViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMRegisterViewController.h"
#import "LMLoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyMD5.h"
#import "NSString+encrypto.h"
#import "MBProgressHUD+NJ.h"
#import "LMSettingViewController.h"

#import "LMAccountTool.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "AESenAndDe.h"
#import "AESenAndDe.h"

#import "AFNetworking.h"

#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

 static  int timeCount = 0;

@interface LMRegisterViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *user;     //用户名
@property (weak, nonatomic) IBOutlet UITextField *pwd;      //密码
@property (weak, nonatomic) IBOutlet UITextField *txtAuth; // 验证码


@property (weak, nonatomic) IBOutlet UIButton *reg;       //注册

@property (nonatomic, strong) NSTimer *countDownTimer; //定时器
/** 获得的salt */
@property (copy, nonatomic) NSString *salt;
/** 获得的sid */
@property (copy, nonatomic) NSString *sid;

@end

@implementation LMRegisterViewController

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
    
    self.title = @"注册";
    
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView =NO;
    [self.scrollView addGestureRecognizer:tapGr];
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.user resignFirstResponder];
    [self.pwd resignFirstResponder];
    [self.txtAuth resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 80);
    [self.user becomeFirstResponder];
}



//登录按钮
- (IBAction)loginBtn {
  
    LMLoginViewController  *loginVc = [[LMLoginViewController alloc] init];
    
    [self.navigationController pushViewController:loginVc animated:YES];
 
}

//验证
- (IBAction)phoneClick:(id)sender {

    if(![self isMobileNumber:self.user.text]){
        [self alertWithMessage:@"请输入正确的手机号"];
    
    }else
    {
        timeCount = 60;
        
        self.reg.enabled = NO;
        
        
        NSTimer *countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        
        self.countDownTimer = countDownTimer;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"reg/mobilecode.json"];
        
        //参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = self.user.text;
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            MyLog(@"responseObject===验证码============%@",responseObject);
            
        long long code = [responseObject[@"code"] longLongValue];
            switch (code) {
                case 10001:
                    [MBProgressHUD showSuccess:@"验证码发送成功"];
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



// 注册
- (IBAction)regBtn:(id)sender {
    
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
   
    [self reginst];
    
}

- (void)reginst
{
   
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"user/mobilecheck.json"];
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = self.user.text;
    
    // 显示一个蒙版(遮盖)
    [MBProgressHUD showMessage:@"正在注册中...."];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MyLog(@"responseObject===注册返回============%@",responseObject);
        
        if([responseObject[@"exist"]intValue] == 1)
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"手机号已被注册"];
            return ;
        }
        
        self.salt = responseObject[@"salt"];
        self.sid = responseObject[@"sid"];
        
        
        
        
        if(self.salt && self.sid)
        {
            
            //发送请求
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            //url地址
            NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"user/reg.json"];
            
            //参数
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"mobile"] = self.user.text;
            
            //密码和salt拼接
            NSString *result = [self.pwd.text stringByAppendingString:self.salt];
            parameters[@"password"] = [[result sha1] lowercaseString];
            MyLog(@"%@密码和salt-has之后==",[[result sha1] lowercaseString]);
            parameters[@"sid"] = self.sid;
            parameters[@"checkCode"] = self.txtAuth.text;

            //    parameters[@"version"] = @"1.0";
            
            
            MyLog(@"%@",parameters);
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                LogObj(responseObject);
                
                long long code = [responseObject[@"code"] longLongValue];
                
                switch (code) {
                    case 10001:
                    {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showMessage:@"注册成功,正在登录..."];
                        
//                        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
//                        dictM[@"userPhone"] = self.user.text;
//                        dictM[@"pwd"] = self.pwd.text;
                        
                        [self aotuLoginWithAccount:self.user.text pwd:self.pwd.text];
                       
                        
//                        [self.navigationController popViewControllerAnimated:YES];
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
                        
                    case 42010:
                    {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"用户帐号已经存在"];
                    }
                        break;
                        
                    default:
                    {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"服务器异常,请稍后再试"];
                    }
                        break;
                }
                
                if ([responseObject[@"code"] longLongValue] == 10001) {
                   
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LogObj(error.localizedDescription);
                
            }];
            
        }else
        {
            [self alertWithMessage:@"手机号已被注册"];
            
            return;
        }
        
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
    }];
    
}

- (void)timerFireMethod
{
    timeCount--;
    
    [self.reg setTitle:[NSString stringWithFormat:@"%d秒后重新获取",timeCount] forState:UIControlStateNormal];
    
    if (timeCount == 0 ) {
        [self.reg setTitle:@"验证" forState:UIControlStateNormal];
        self.reg.enabled = YES;
        [self.countDownTimer invalidate];
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.user) {
        [self.user resignFirstResponder];
        [self.pwd becomeFirstResponder];
    }else if (textField==self.txtAuth){
        [self.txtAuth resignFirstResponder];
        [self.pwd becomeFirstResponder];
    }else if (textField==self.pwd){
        [self.pwd resignFirstResponder];
    }
    
    return YES;
}

//判断是否是电话号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString *common = @"^1[0-9]{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", common];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
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



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollView endEditing:YES];
}

//自动登录
- (void)aotuLoginWithAccount:(NSString *)account pwd:(NSString *)pwd
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"user/salt.json"];
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = account;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LogObj(responseObject);
        
        self.salt = responseObject[@"salt"];
        self.sid = responseObject[@"sid"];
        
        /** 登录 */
        AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
        
        //url地址
        NSString *url2 = [NSString stringWithFormat:@"%@%@",RequestURL,@"user/login.json"];
        
        //参数
        NSMutableDictionary *parameters2 = [NSMutableDictionary dictionary];
        parameters2[@"mobile"] = account;
        parameters2[@"sid"] = self.sid;
        
        NSMutableDictionary *arr = [NSMutableDictionary dictionary];
        
        arr[@"time"] = [NSString timeNow];
        NSString *pwdResult = [pwd stringByAppendingString:self.salt];
        arr[@"password"] = [pwdResult sha1];
        
        
        NSString *jsonStr = [arr JSONString];
        MyLog(@"jsonStr=============%@",jsonStr);
        
        //通讯密钥
        NSString *result = [pwd stringByAppendingString:self.salt];
        MyLog(@"%@==拼接之后",result);
        
        NSString *key = [[[result sha1]  substringToIndex:16] lowercaseString];
        MyLog(@"%@==全部密钥",[[result sha1] lowercaseString] );
        MyLog(@"%@==密钥",key);
        
        
        parameters2[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:key];
        
        MyLog(@"%@===请求参数",parameters2);
        
        [manager2 POST:url2 parameters:parameters2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            MyLog(@"responseObject===============%@",responseObject);
            
            long long code = [responseObject[@"code"] longLongValue];
            
            if(code == 10001)
            {
                NSString *dataStr = responseObject[@"data"];
                
                NSString *dataJson = [AESenAndDe De_Base64andAESDeToString:dataStr keyValue:key];
                NSDictionary *dict = [dataJson objectFromJSONString];
                
                
                
                NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
                dictM[@"userPhone"] = account;
                dictM[@"pwd"] = pwd;
                
                MyLog(@"name===%@",dictM);
                
                
                //字典转对象
                LMAccount *account  = [LMAccount accountWithDict:dictM];
                [LMAccountTool saveAccount:account];
                
                
                [[LMAccountInfo sharedAccountInfo] setAccount:account];
                LogObj([LMAccountInfo sharedAccountInfo].account);
                
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"登录成功"];
                
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[LMSettingViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
                
            }
            
           
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
    }];
    
    

}





@end
