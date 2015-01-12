//
//  LMPaySuccessViewController.m
//  LearnMore
//
//  Created by study on 15-1-8.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMPaySuccessViewController.h"

@interface LMPaySuccessViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation LMPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买成功";
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds = YES;
    
}

- (IBAction)commit:(id)sender {
}


@end
