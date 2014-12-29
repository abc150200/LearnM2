//
//  LMLoginViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMLoginViewController.h"
#import "LMRegisterViewController.h"
#import "LMchangePwdViewController.h"
#import "AFNetworking.h"
#import "NSString+encrypto.h"
#import "LMSettingViewController.h"
#import "MBProgressHUD+NJ.h"
#import "LMAccount.h"
#import "LMAccountInfo.h"

#import "GTMBase64.h"
#import "AESenAndDe.h"
#import "AESenAndDe.h"

#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import "LMAccount.h"
#import "LMAccountTool.h"

@interface LMLoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (copy, nonatomic) NSString *salt;
@property (copy, nonatomic) NSString *sid;

@end

@implementation LMLoginViewController

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
    
    self.title = @"登录";
    
    self.scrollView.delegate = self;
    
    
    self.scrollView.backgroundColor = [UIColor colorWithRed:180 green:180 blue:180 alpha:1];
    

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView =NO;
    [self.scrollView addGestureRecognizer:tapGr];
  
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.account resignFirstResponder];
    [self.pwd resignFirstResponder];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 80);
    
    [self.account becomeFirstResponder];
//    self.scrollView.contentOffset = CGPointMake(0, 34);
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.account) {
        [self.account resignFirstResponder];
        [self.pwd becomeFirstResponder];
    }else if (textField==self.pwd){
        [self.pwd resignFirstResponder];
    }
    
    return YES;
}



//登录按钮
- (IBAction)loginBtn:(id)sender {
    
    if(![self isMobileNumber:self.account.text])
    {
        [self alertWithMessage:@"手机号不存在"];
        return;
    }
    
    if( [self.pwd.text isEqualToString:@""] )
    {
        [self alertWithMessage:@"用户名或密码不能空！"];
        
        return;
    }
    
    [self login];


}

- (void)login
{
    
    //发送请求
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"user/salt.json"];
    
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = self.account.text;
    
    // 显示一个蒙版(遮盖)
    [MBProgressHUD showMessage:@"正在登录中...."];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LogObj(responseObject);
        
        self.salt = responseObject[@"salt"];
        self.sid = responseObject[@"sid"];
        
        
        
        if(self.salt && self.sid)
        {
            
            
            /** 登录 */
            AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
            
            //url地址
            NSString *url2 = [NSString stringWithFormat:@"%@%@",RequestURL,@"user/login.json"];
            
            //参数
            NSMutableDictionary *parameters2 = [NSMutableDictionary dictionary];
            parameters2[@"mobile"] = self.account.text;
            parameters2[@"sid"] = self.sid;
            
            NSMutableDictionary *arr = [NSMutableDictionary dictionary];
            
            arr[@"time"] = [self timeNow];
            //        arr[@"password"] = [self getSha1String:self.pwd.text];
            NSString *pwdResult = [self.pwd.text stringByAppendingString:self.salt];
            arr[@"password"] = [pwdResult sha1];
        
            
            NSString *jsonStr = [arr JSONString];
            MyLog(@"%@",jsonStr);
            
            //通讯密钥
            NSString *result = [self.pwd.text stringByAppendingString:self.salt];
            MyLog(@"%@==拼接之后",result);
            //        NSString *key = [[self getSha1String:result]  substringToIndex:16];
            NSString *key = [[[result sha1]  substringToIndex:16] lowercaseString];
            MyLog(@"%@==全部密钥",[[result sha1] lowercaseString] );
            MyLog(@"%@==密钥",key);
            
            
            //        parameters2[@"data"] = [AESCrypt encrypt:jsonStr password:key];
            parameters2[@"data"] = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:key];
            
            MyLog(@"%@===请求参数",parameters2);
            
            [manager2 POST:url2 parameters:parameters2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                LogObj(responseObject);
                
                long long code = [responseObject[@"code"] longLongValue];
                
                switch (code) {
                    case 10001:
                    {
                        // 移除遮盖
                        [MBProgressHUD hideHUD];
                        
                        NSString *dataStr = responseObject[@"data"];
                        
                        NSString *dataJson = [AESenAndDe De_Base64andAESDeToString:dataStr keyValue:key];
                        NSDictionary *dict = [dataJson objectFromJSONString];
                        
                        LogObj(dict);
                        
                        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
                        dictM[@"userPhone"] = self.account.text;
                        dictM[@"pwd"] = self.pwd.text;
                        
                        MyLog(@"name===%@",dictM);
                        
                        
                        //字典转对象
                        LMAccount *account  = [LMAccount accountWithDict:dictM];
                        account.userPhone = self.account.text;
                        account.pwd = self.pwd.text;
                        [LMAccountTool saveAccount:account];
                        
                        
                        
                        [[LMAccountInfo sharedAccountInfo] setAccount:account];
                        LogObj([LMAccountInfo sharedAccountInfo].account);
                        
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        
                    }
                        break;
                        
                    case 30001:
                    {
                        // 移除遮盖
                        [MBProgressHUD hideHUD];
                        [self alertWithMessage:@"用户不存在！"];
                        
                        return ;
                        
                    }
                        break;
                        
                    case 30002:
                    {
                        // 移除遮盖
                        [MBProgressHUD hideHUD];
                        [self alertWithMessage:@"用户未登录或超时！"];
                        
                        return ;
                        
                    }
                        break;
                        
                    case 30006:
                    {
                        // 移除遮盖
                        [MBProgressHUD hideHUD];
                        [self alertWithMessage:@"用户输入错误密码次数，超过允许的最大值！"];
                        
                        return ;
                        
                    }
                        break;
                        
                    case 30003:
                    {
                        // 移除遮盖
                        [MBProgressHUD hideHUD];
                        [self alertWithMessage:@"密码输入错误!"];
                        
                        return ;
                        
                    }
                        break;
                        
                    default:
                    {
                        // 移除遮盖
                        [MBProgressHUD hideHUD];
                        [self alertWithMessage:@"服务器异常,请稍后重试"];
                        return;
                    }
                        break;
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LogObj(error.localizedDescription);
                
            }];
            
        }else
        {
            // 移除遮盖
            [MBProgressHUD hideHUD];
            
            [self alertWithMessage:@"用户不存在！"];
            return;
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
        
    }];
    
}

//注册按钮
- (IBAction)registerBtn {
    
    LMRegisterViewController *rVc = [[LMRegisterViewController alloc] init];
    
    [self.navigationController pushViewController:rVc animated:YES];
    
}
- (IBAction)ChangePwdBtn {
    LMchangePwdViewController *cp = [[LMchangePwdViewController alloc] init];
    
    [self.navigationController pushViewController:cp animated:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollView endEditing:YES];
}



//sha1加密方式
- (NSString *)getSha1String:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}




- (NSString *)timeNow
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0f", a];
}


+(NSString*)byteToString:(NSData*)data
{
    Byte *plainTextByte = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",plainTextByte[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



@end
