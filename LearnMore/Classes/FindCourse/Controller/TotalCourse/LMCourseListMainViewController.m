//
//  LMCourseListMainViewController.m
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMCourseListMainViewController.h"
#import "LMCourseHeadView.h"
#import "LMCourseIntroViewController.h"
#import "IWPopMenu.h"
#import "CZProvinceViewController.h"
#import "CZCityViewController.h"
#import "LMCourseSearch.h"
#import "LMSearchViewController.h"
#import "AFNetworking.h"
#import "LMCourseList.h"
#import "MJExtension.h"
#import "LMCourseViewCell.h"
#import "MJRefresh.h"
#import "LMlistViewController.h"
#import "LMCityViewController.h"
#import "LMAreaViewController.h"
#import "LMAgeViewController.h"
#import "LMListButton.h"
#import "LMCourseListViewController.h"
#import "LMSchoolListViewController.h"



@interface LMCourseListMainViewController ()<LMCourseHeadViewDelegate,IWPopMenuDelegate,CZProvinceViewControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate,LMAreaViewControllerDelegate,CZCityViewControllerDelegate,LMCityViewControllerDelegate,LMSearchViewControllerDelegate,LMlistViewControllerDelegate,LMAgeViewControllerDelegate>
@property (nonatomic, strong)LMCourseHeadView  *headView;
@property (nonatomic, strong)  CZProvinceViewController *pVc ;
@property (nonatomic, strong) CZCityViewController *cVc;
@property (nonatomic, strong) LMlistViewController *lvc;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, weak) LMCourseSearch *courseSearchBar;
@property (nonatomic, assign) NSInteger index;//记住点击了哪个按钮
@property (nonatomic, strong) NSMutableArray *courseLists;
@property (nonatomic, strong) LMAreaViewController *lac;
@property (nonatomic, strong) LMCityViewController *lcc;
@property (nonatomic, strong) LMAgeViewController *avc;
@property (nonatomic, strong) IWPopMenu *popMenu;
@property (nonatomic, weak) UISegmentedControl *segm;



@property (nonatomic, strong) LMCourseListViewController *clv;
@property (nonatomic, strong) LMSchoolListViewController *slv;

@end

@implementation LMCourseListMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNav];
    
    //创建筛选工具条
    LMCourseHeadView *headView = [[LMCourseHeadView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 43)];
   MyLog(@"name===%@",NSStringFromCGRect(self.headView.frame));
    
    if([[NSString deviceString]  isEqualToString: @"iPhone 4S"])
    {
        headView.y = 0;
    }
    
    
    [self.view addSubview:headView];
    MyLog(@"headView===%@",NSStringFromCGRect(self.headView.frame));
    self.headView = headView;
    self.headView.delegate = self;
   
    
    //创建courseView
    LMCourseListViewController *clv = [[LMCourseListViewController alloc] init];
    self.clv = clv;
    [self addChildViewController:clv];
    self.clv.view.frame = CGRectMake(0, 107, self.view.width,[UIScreen mainScreen].bounds.size.height - 107);
    if ([[NSString deviceString]  isEqualToString: @"iPhone 4S"]) {
        self.clv.view.y = 43;
        self.clv.view.height = [UIScreen mainScreen].bounds.size.height - 43;
    }
    [self.view addSubview:self.clv.view];

    [self loadNewData];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    if(self.courseTitle)
    {
        [self.headView.titleBtn setTitle:self.courseTitle forState:UIControlStateNormal];
    }else
    {
        [self.headView.titleBtn setTitle:@"分  类" forState:UIControlStateNormal];
    }
    
}

/**  设置导航栏 */
- (void)setupNav
{
    //创建课程切换标签
    NSArray *btnName = @[@"课程",@"学校"];
    
    UISegmentedControl *segm = [[UISegmentedControl alloc] initWithItems:btnName];
    self.segm = segm;
    
    segm.frame = CGRectMake(0, 0, 160, 32);
    segm.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segm;
    //添加事件
    [segm addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
//    //右边搜索按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_class_list_search"] style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClick)];

}



- (void)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    MyLog(@"Seg.selectedSegmentIndex:%d",Index);
    
     if (Index == 0) {
         
         //创建courseView
         LMCourseListViewController *clv = [[LMCourseListViewController alloc] init];
         self.clv = clv;
         [self.slv removeFromParentViewController];
         [self addChildViewController:clv];
         [self.view addSubview:self.clv.view];
         [self loadNewData];
         [self.clv loadNewData];
         
     } else
     {
         LMSchoolListViewController *slv = [[LMSchoolListViewController alloc] init];
         self.slv = slv;
         [self.clv removeFromParentViewController];
         [self addChildViewController:slv];
         [self.clv.view removeFromSuperview];
         [self.view addSubview:self.slv.view];
         [self loadNewData];
         [self.slv loadNewData];
     }

}



/** 参数 */
- (void)loadNewData
{
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    
    if (self.levelId && self.areaId) {
        arr[@"area"] = [NSString stringWithFormat:@"%@_%@",self.levelId,self.areaId];
    }else
    {
        arr[@"area"] = @"0_0";
    }
    
    if (self.searchContent) {
        arr[@"keyword"] = self.searchContent;
    }
    
    if(self.TypeId)
    {
        arr[@"category"] = self.TypeId;
    }
    
    if(self.ageId)
    {
        arr[@"age"] = self.ageId;
    }
    if (self.orderId) {
        arr[@"order"] = [NSString stringWithFormat:@"%d",self.orderId];
    }

    self.clv.arr = arr;
    self.slv.arr = arr;
    
    if (self.segm.selectedSegmentIndex == 0) {
        [self.clv loadNewData];
    } else
    {
        [self.slv loadNewData];
    }

}




/** 跳转搜索页面 */
- (void)navBtnClick
{
    LMSearchViewController *lv = [[LMSearchViewController alloc] init];
    lv.from = FromeTotal;
    lv.delegate =self;
    [self.navigationController pushViewController:lv animated:NO];
}

/** 搜索界面的代理 */
- (void)searchViewController:(LMSearchViewController *)searchViewController content:(NSString *)content
{
    self.searchContent = content;
    
    [self.headView removeFromSuperview];
    
    self.TypeId = nil;
    
    [self viewDidLoad];
    
 
}



- (void)courseHeadView:(LMCourseHeadView *)courseHeadView didClickBtnIndex:(NSInteger)index
{
//    MyLog(@"%d",index);
    
    self.index = index;
    
    
    switch (index) {
        case 0:
        {
            //显示菜单
            UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
            menuView.backgroundColor = [UIColor whiteColor];
            self.menuView = menuView;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            label.text = @"不限";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [menuView addSubview:label];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
            btn.backgroundColor = [UIColor clearColor];
            [menuView addSubview:btn];
            [btn addTarget:self action:@selector(allMenu) forControlEvents:UIControlEventTouchUpInside];
            
            
            CZProvinceViewController *pVc = [[CZProvinceViewController alloc] init];
            pVc.view.frame = CGRectMake(0, 30, self.view.width * 0.5, 170);
            [menuView addSubview:pVc.view];
            self.pVc = pVc;
            pVc.provinceDelegate = self;
            
            CZCityViewController *cVc = [[CZCityViewController alloc] init];
            cVc.view.frame = CGRectMake(150, 30, self.view.width * 0.5, 170);
            [menuView addSubview:cVc.view];
            self.cVc = cVc;
            cVc.delegate = self;
            
        }
            break;
        case 1:
        {
            //显示菜单
            UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
            menuView.backgroundColor = [UIColor whiteColor];
            self.menuView = menuView;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            label.text = @"不限";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [menuView addSubview:label];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
            btn.backgroundColor = [UIColor clearColor];
            [menuView addSubview:btn];
            [btn addTarget:self action:@selector(allMenu2) forControlEvents:UIControlEventTouchUpInside];
            
            
            LMAreaViewController *lac = [[LMAreaViewController alloc] init];
            lac.view.frame = CGRectMake(0, 30, self.view.width * 0.5, 170);
            [menuView addSubview:lac.view];
            self.lac = lac;
            lac.areaDelegate = self;
            
            LMCityViewController *lcc = [[LMCityViewController alloc] init];
            lcc.view.frame = CGRectMake(150, 30, self.view.width * 0.5, 170);
            [menuView addSubview:lcc.view];
            self.lcc = lcc;
            self.lcc.delegate = self;
            
        }
            break;
        case 2:
        {
            //显示菜单
            UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
            menuView.backgroundColor = [UIColor whiteColor];
            self.menuView = menuView;
            
            LMAgeViewController *avc = [[LMAgeViewController alloc] init];
            avc.view.frame = CGRectMake(0, 0, self.view.width , 200);
            [menuView addSubview:avc.view];
            self.avc = avc;
            avc.delegate = self;
            avc.listArr = @[@"全部",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18"];
            [avc.tableView reloadData];
        }
        
            break;
            
            case 3:
            
        {
            //显示菜单
            UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
            menuView.backgroundColor = [UIColor whiteColor];
            self.menuView = menuView;
            
            LMlistViewController *lvc = [[LMlistViewController alloc] init];
            lvc.view.frame = CGRectMake(0, 0, self.view.width , 200);
            [menuView addSubview:lvc.view];
            self.lvc = lvc;
            lvc.delegate = self;
            lvc.listArr = @[@"默认排序",@"最新发布",@"收藏最多",@"免费试听"];
            [lvc.tableView reloadData];
        }
        
            break;
            
        default:
            break;
    }
    
    
    IWPopMenu *popMenu = [[IWPopMenu alloc] initWithContentView:self.menuView];
    popMenu.delegate = self;
    self.popMenu = popMenu;
    [popMenu showRect:CGRectMake(0, 107, 320, 230)];

    
}

- (void)allMenu
{
    self.areaId = @"0";
    self.levelId = @"0";
    
    [self loadNewData];
    
    [self.popMenu dismiss];
    
}

- (void)allMenu2
{
    self.areaId = @"0";
    self.levelId = @"0";
    
    [self loadNewData];
    
    [self.popMenu dismiss];
}

// 选中课程大类的代理方法
- (void)provinceViewController:(CZProvinceViewController *)controller selectedCities:(NSArray *)cities row:(int)row
{
    self.cVc.cities = cities;
    self.cVc.row = row;
}

// 选中区域大类的代理方法
- (void)areaViewController:(LMAreaViewController *)controller selectedCities:(NSArray *)cities areaId:(NSString *)areaId areaLevel:(NSString *)areaLevel title:(NSString *)title
{
    self.lcc.cities = cities;
    
    self.lcc.id  = areaId;
    self.lcc.level = areaLevel;
    
    [self.headView.cityBtn setTitle:title forState:UIControlStateNormal];
    [self.headView.cityBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
}

//选中区域小类的代理

- (void)cityViewController:(LMCityViewController *)cityViewController level:(NSString *)level id:(NSString *)id
{
    self.areaId = id;
    self.levelId = level;
    
    [self loadNewData];
    
    [self.popMenu dismiss];
}

//传递分类数据的代理
- (void)cityViewController:(CZCityViewController *)cityViewController didSeclctedItem:(NSNumber *)item title:(NSString *)title
{
    self.TypeId = item;
    
    [self.headView.titleBtn setTitle:title forState:UIControlStateNormal];
    [self.headView.titleBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
    
    [self loadNewData];
    
    [self.popMenu dismiss];
    
}

//年龄代理
- (void)ageViewController:(LMAgeViewController *)ageViewController age:(int)age title:(NSString *)title
{
    self.ageId = [NSString stringWithFormat:@"%d_%d",age,(age + 1)];
    
    [self.headView.ageBtn setTitle:title forState:UIControlStateNormal];
    [self.headView.ageBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
    
    [self loadNewData];
    
    [self.popMenu dismiss];
}

//筛选代理
- (void)listViewControllerDidClick:(LMlistViewController *)listViewController title:(NSString *)title row:(int)row
{
    self.orderId = row;
    [self.headView.selectedBtn setTitle:title forState:UIControlStateNormal];
    [self.headView.selectedBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
    
    [self loadNewData];
    
    [self.popMenu dismiss];
}


- (void)popMenudidDismiss:(IWPopMenu *)popMenu
{
    UIButton *btn = self.headView.buttons[self.index];
    [btn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];

}



- (NSMutableArray *)courseLists
{
    if (_courseLists == nil) {
        _courseLists = [NSMutableArray array];
    }
    return _courseLists;
}
 

@end
