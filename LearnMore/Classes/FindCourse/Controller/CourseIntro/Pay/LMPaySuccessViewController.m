//
//  LMPaySuccessViewController.m
//  LearnMore
//
//  Created by study on 15-1-8.
//  Copyright (c) 2015年 youxuejingxuan. All rights reserved.
//

#import "LMPaySuccessViewController.h"
#import "LMCourseIntroViewController.h"

@interface LMPaySuccessViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation LMPaySuccessViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //重写返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"public_nav_black" target:self sel:@selector(goBack)];
    
}

- (void)goBack
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LMCourseIntroViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买成功";
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds = YES;
    
    
    self.courseNameLabel.text = self.courseName;
    self.contactLabel.text = self.contact;
    self.phoneLabel.text = self.phone;
    
}

- (IBAction)commit:(id)sender {
}


@end
