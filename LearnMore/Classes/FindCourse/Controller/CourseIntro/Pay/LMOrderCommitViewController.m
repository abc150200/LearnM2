//
//  LMOrderCommitViewController.m
//  LearnMore
//
//  Created by study on 15-1-7.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMOrderCommitViewController.h"
#import "LMPayCommitVC.h"


static  int defaultCount = 1;

@interface LMOrderCommitViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *courseInfoView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;//课程名
@property (weak, nonatomic) IBOutlet UILabel *singlePriceLabel;//单一课价
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;//总课价
@property (weak, nonatomic) IBOutlet UIButton *addNumBtn;//加1
@property (weak, nonatomic) IBOutlet UIButton *plusNumBtn;//减1
@property (weak, nonatomic) IBOutlet UITextField *contactText;//联系人
@property (weak, nonatomic) IBOutlet UITextField *phoneNumText;//手机号
@property (weak, nonatomic) IBOutlet UILabel *contactTitle;//联系人标题
@property (weak, nonatomic) IBOutlet UILabel *tuikuan;//退款
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@end

@implementation LMOrderCommitViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 100);
    self.scrollView.delegate = self;
    [self.contactText becomeFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 100);
 
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"提交订单";
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 100);
    
    self.courseInfoView.layer.cornerRadius = 5;
    self.courseInfoView.clipsToBounds = YES;
    
    self.contactView.layer.cornerRadius = 5;
    self.contactView.clipsToBounds = YES;
    
    self.allPriceLabel.textColor = UIColorFromRGB(0xc92900);
    self.contactText.textColor = UIColorFromRGB(0x222222);
    self.tuikuan.textColor = UIColorFromRGB(0x76a600);
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView =NO;
    [self.scrollView addGestureRecognizer:tapGr];
    
    
    self.courseNameLabel.text = self.productName;
    self.singlePriceLabel.text = [NSString stringWithFormat:@"%d元",self.discountPrice];
    self.allPriceLabel.text = [NSString stringWithFormat:@"%d元",self.discountPrice] ;
    
    [self.countBtn setTitle:[NSString stringWithFormat:@"%d",defaultCount] forState:UIControlStateNormal];


}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.contactText resignFirstResponder];
    [self.phoneNumText resignFirstResponder];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollView endEditing:YES];
}

- (IBAction)commitBtn:(id)sender {
    LMPayCommitVC *pVc = [[LMPayCommitVC alloc] init];
    pVc.courseName = self.productName;
    pVc.count = defaultCount;
    pVc.totalPrice = self.discountPrice * defaultCount;
    pVc.singlePrice = self.discountPrice;
    pVc.productTypeId = self.productTypeId;
    pVc.productId = self.productId;
    if ([self.contactText.text length]) {  
         pVc.contact = self.contactText.text;
    }else
    {
        [self alertWithMessage:@"联系人不能为空"];
        return;
    }
   
    if ([self.phoneNumText.text length]) {
        pVc.phone = self.phoneNumText.text;
    }else
    {
        [self alertWithMessage:@"手机号不能为空"];
        return;
    }
    
    [self.navigationController pushViewController:pVc animated:YES];
    
}

- (IBAction)add:(id)sender {
    
    defaultCount++;
    [self.countBtn setTitle:[NSString stringWithFormat:@"%d",defaultCount] forState:UIControlStateNormal];
    if (defaultCount == 0) {
        self.plusBtn.enabled = NO;
    }else
    {
        self.plusBtn.enabled = YES;
    }
    
    long long allPrice = self.discountPrice * defaultCount;
    
    self.allPriceLabel.text = [NSString stringWithFormat:@"%lli元",allPrice];
}

- (IBAction)plus:(id)sender {
    
    defaultCount--;
    [self.countBtn setTitle:[NSString stringWithFormat:@"%d",defaultCount] forState:UIControlStateNormal];
    if (defaultCount == 0) {
        self.plusBtn.enabled = NO;
    }else
    {
        self.plusBtn.enabled = YES;
    }
    
    long long allPrice = self.discountPrice * defaultCount;
    
    self.allPriceLabel.text = [NSString stringWithFormat:@"%lli元",allPrice];
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
