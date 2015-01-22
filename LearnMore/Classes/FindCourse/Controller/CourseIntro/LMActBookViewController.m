//
//  LMActBookViewController.m
//  LearnMore
//
//  Created by study on 14-11-19.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMActBookViewController.h"
#import "LMActivityDetailViewController.h"

@interface LMActBookViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (copy, nonatomic) NSString *sexInfo;
@end

@implementation LMActBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        self.contentView.layer.cornerRadius = 5;
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.sex == 1) {
        self.sexInfo = @"男";
    }else
    {
        self.sexInfo = @"女";
    }
    
    self.infoLabel.text = [NSString stringWithFormat:@"   你已经为%@(%@，%d岁)报名了%@组织的活动--%@。",self.stuName,self.sexInfo, self.age,self.schoolName,self.actTitle];
    
    self.contactLabel.text = [NSString stringWithFormat:@"  %@的工作人员会在1-2个工作日内与你联系,沟通活动相关信息,你也可以在《我的-报名活动》中查看已报名的活动信息。",self.schoolName];
}

- (IBAction)share:(id)sender {
    
    MyLog(@"分享课程===");
}


- (IBAction)finish:(id)sender {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LMActivityDetailViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
////    LMActivityDetailViewController *ld = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//    LMActivityDetailViewController *ld = (LMActivityDetailViewController *)self.navigationController.viewControllers[1];
//    
////    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popToViewController:ld animated:YES];
}

@end
