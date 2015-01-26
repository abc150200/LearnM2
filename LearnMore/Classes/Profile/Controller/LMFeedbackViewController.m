//
//  LMFeedbackViewController.m
//  LearnMore
//
//  Created by study on 14-10-14.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMFeedbackViewController.h"
#import "LMComposeView.h"
#import "MBProgressHUD+NJ.h"
#import "AFNetworking.h"

@interface LMFeedbackViewController ()<UITextViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) LMComposeView *tv;
@end

@implementation LMFeedbackViewController

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
    
    self.title = @"意见反馈";
    
    [self setupInputView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 80);
    self.scrollView.delegate = self;
    //主动显示键盘
    [self.tv becomeFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollView endEditing:YES];
}

- (void)setupInputView
{
    LMComposeView *tv = [[LMComposeView alloc] init];
    tv.backgroundColor = [UIColor whiteColor];
    tv.layer.cornerRadius = 5;
    tv.clipsToBounds = YES;
    tv.frame = CGRectMake(15, 10, self.view.width - 30, self.view.height * 0.3);
    tv.placeholder = @"请输入反馈内容";
    [self.scrollView addSubview:tv];
    tv.delegate = self;
    self.tv = tv;
}
- (IBAction)commitBtn:(id)sender {
    
    if (![self.tv.text isEqualToString:@""]) {
        
        if ([self.delegate respondsToSelector:@selector(feedbackViewControllerDidClickButton:)]) {
            [self.delegate feedbackViewControllerDidClickButton:self];
        }
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //url地址
        NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"/commons/suggestion.json"];
        
        //参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"content"] = self.tv.text;
        
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
        parameters[@"version"] = version;
        parameters[@"device"] = deviceInfo;
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LogObj(responseObject);
            
            long long code = [responseObject[@"code"] longLongValue];
            switch (code) {
                case 10001:
                    [MBProgressHUD showSuccess:@"提交成功"];
                    break;
                    
                case 90007:
                    [MBProgressHUD showError:@"用户反馈内容为空"];
                    break;
                    
                case 90008:
                    [MBProgressHUD showError:@"用户反馈内容过长"];
                    break;
            
                    
                default:
                    [MBProgressHUD showError:@"服务器异常"];
                    break;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObj(error.localizedDescription);
            
        }];

        
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [MBProgressHUD showError:@"内容不能为空"];
        return;
    }
    
}
@end
