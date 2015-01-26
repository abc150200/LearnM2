//
//  LMProductDetailVC.m
//  LearnMore
//
//  Created by study on 15-1-16.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMProductDetailVC.h"
#import "LMOrderCommitViewController.h"

@interface LMProductDetailVC ()
@property (nonatomic, weak) UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@end

@implementation LMProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"套餐详情";
    
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
   
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.footView.height)];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.learnmore.com.cn/m/productDetail.html?id=%li",self.productId];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    self.webView = webView;
    self.webView.scrollView.bounces = NO;
    
    [self.view addSubview:webView];
    
    
    [self.view addSubview:self.footView];
    self.footView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.footView.height, [UIScreen mainScreen].bounds.size.width, self.footView.height);
   
    }

- (IBAction)buy:(id)sender {

    LMOrderCommitViewController *ov = [[LMOrderCommitViewController alloc] init];
    ov.productId = self.productId;
    ov.discountPrice = self.discountPrice;
    ov.productName = self.productName;
    ov.productTypeId = self.productTypeId;
    [self.navigationController pushViewController:ov animated:YES];
    
}


@end
