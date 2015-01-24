//
//  LMCourseListMainViewController.m
//  LearnMore
//
//  Created by study on 14-10-8.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMResultViewH 30

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
#import "LMlistViewController.h"
#import "LMCityViewController.h"
#import "LMAreaViewController.h"
#import "LMAgeViewController.h"
#import "LMListButton.h"
#import "LMCourseListViewController.h"
#import "LMSchoolListViewController.h"
#import "LMCourseOrder.h"



@interface LMCourseListMainViewController ()<LMCourseHeadViewDelegate,IWPopMenuDelegate,CZProvinceViewControllerDelegate,LMAreaViewControllerDelegate,CZCityViewControllerDelegate,LMCityViewControllerDelegate,LMSearchViewControllerDelegate,LMlistViewControllerDelegate,LMAgeViewControllerDelegate>
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

@property (nonatomic, strong) NSArray  *areaArr;
@property (nonatomic, strong) NSArray *courseOrders;
@property (nonatomic, strong) NSArray *schoolOrders;
@property (nonatomic, strong) NSArray *orderListArr;

@property (nonatomic, weak) UIView *resultView;
@property (nonatomic, assign) NSInteger segmNum;



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
    
    //添加搜索结果显示
    UIView *resultView = [[UIView alloc] init];
    resultView.x = 0;
    resultView.y = CGRectGetMaxY(self.headView.frame);
    resultView.width = self.view.width;
    if (self.from == FromeSearch) {
        resultView.height = LMResultViewH;
    }else
    {
        resultView.height = 0;
    }
    self.resultView = resultView;
    resultView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:resultView];
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 20, LMResultViewH)];
    resultLabel.text = [NSString stringWithFormat:@"当前搜索: %@",self.searchContent];
    resultLabel.textColor = [UIColor darkGrayColor];
    resultLabel.font = [UIFont systemFontOfSize:14];
    [resultView addSubview:resultLabel];

    
    [self segmentAction:self.segm];
    
    [self loadOrder];
    
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
    self.segmNum = Index;
    
     if (Index == 0) {
         
         self.orderListArr = self.courseOrders;
         //创建courseView
         LMCourseListViewController *clv = [[LMCourseListViewController alloc] init];
         self.clv = clv;
         
         //设置宽度
         if ([[NSString deviceString]  isEqualToString: @"iPhone 4S"]) {

             if(self.from == FromeSearch)
             {
                 self.clv.tableView.y = 43 + LMResultViewH;
             }else
             {
                 self.clv.tableView.y = 43;
             }
         }else
         {
             if(self.from == FromeSearch)
             {
                 self.clv.tableView.y = 107 + LMResultViewH;
             }else
             {
                 self.clv.tableView.y = 107;
             }
         }
         
         if(self.from == FromeSearch)
         {
             self.clv.tableView.height = [UIScreen mainScreen].bounds.size.height - 107 - LMResultViewH;
         }else
         {
             self.clv.tableView.height = [UIScreen mainScreen].bounds.size.height - 107;
         }
         
         
         [self.slv removeFromParentViewController];
         [self addChildViewController:clv];
         [self.view addSubview:self.clv.view];
         [self loadParam];
         
     } else
     {
         self.orderListArr = self.schoolOrders;
         LMSchoolListViewController *slv = [[LMSchoolListViewController alloc] init];
         self.slv = slv;
         
         //设置宽度
         if ([[NSString deviceString]  isEqualToString: @"iPhone 4S"]) {
             
             if(self.from == FromeSearch)
             {
                 self.slv.tableView.y = 43 + LMResultViewH;
             }else
             {
                 self.slv.tableView.y = 43;
             }
         }else
         {
             if(self.from == FromeSearch)
             {
                 self.slv.tableView.y = 107 + LMResultViewH;
             }else
             {
                 self.slv.tableView.y = 107;
             }
         }
         
         if(self.from == FromeSearch)
         {
             self.slv.tableView.height = [UIScreen mainScreen].bounds.size.height - 107 - LMResultViewH;
         }else
         {
             self.slv.tableView.height = [UIScreen mainScreen].bounds.size.height - 107;
         }
         
         
         [self.clv removeFromParentViewController];
         [self addChildViewController:slv];
         [self.clv.view removeFromSuperview];
         [self.view addSubview:self.slv.view];
         [self loadParam];
     }

}

- (void)loadOrder
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"commons/order.json"];
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
    parameters[@"device"] = deviceInfo;
    
    NSString *version = [[NSUserDefaults standardUserDefaults]  objectForKey:@"version"];
    parameters[@"version"] = version;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MyLog(@"responseObject===============%@",responseObject);
        
            NSArray *courseOrders = [LMCourseOrder objectArrayWithKeyValuesArray:responseObject[@"courseOrders"]];
            self.courseOrders = courseOrders;
            self.orderListArr = self.courseOrders;
        
            NSArray *schoolOrders = [LMCourseOrder objectArrayWithKeyValuesArray:responseObject[@"schoolOrders"]];
            self.schoolOrders = schoolOrders;
  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
    
}



/** 参数 */
- (void)loadParam
{

    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    
    if (self.levelId && self.areaId) {
        arr[@"area"] = [NSString stringWithFormat:@"%@_%@",self.levelId,self.areaId];
    }else
    {
        arr[@"area"] = @"4_-9999999";
    }
    
    arr[@"count"] = @"10";
    
    NSString *gpsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"localGps"];
    
    if (gpsStr) {
        arr[@"gps"] = gpsStr;
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
        [self.clv setupRefresh];
    } else
    {
        [self.slv setupRefresh];
    }

}




/** 跳转搜索页面 */
- (void)navBtnClick
{
    LMSearchViewController *lv = [[LMSearchViewController alloc] init];
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
            UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 210)];
            menuView.backgroundColor = [UIColor whiteColor];
            self.menuView = menuView;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, 30)];
            label.text = @"不限";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor darkGrayColor];
            [menuView addSubview:label];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
            btn.backgroundColor = [UIColor clearColor];
            [menuView addSubview:btn];
            [btn addTarget:self action:@selector(allMenu2) forControlEvents:UIControlEventTouchUpInside];
            
            
            LMAreaViewController *lac = [[LMAreaViewController alloc] init];
            lac.view.frame = CGRectMake(0, 30, self.view.width * 0.5, 180);
            [menuView addSubview:lac.view];
            self.lac = lac;
            lac.areaDelegate = self;
            
            LMCityViewController *lcc = [[LMCityViewController alloc] init];
            lcc.view.frame = CGRectMake(150, 30, self.view.width * 0.5, 180);
            [menuView addSubview:lcc.view];
            self.lcc = lcc;
            self.lcc.delegate = self;
        }
        
            break;
            
        case 1:
        {
            //显示菜单
            UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 210)];
            menuView.backgroundColor = [UIColor whiteColor];
            self.menuView = menuView;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, 30)];
            label.text = @"不限";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor darkGrayColor];
            [menuView addSubview:label];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
            btn.backgroundColor = [UIColor clearColor];
            [menuView addSubview:btn];
            [btn addTarget:self action:@selector(allMenu) forControlEvents:UIControlEventTouchUpInside];
            
            
            CZProvinceViewController *pVc = [[CZProvinceViewController alloc] init];
            pVc.view.frame = CGRectMake(0, 30, self.view.width * 0.5, 180);
            [menuView addSubview:pVc.view];
            self.pVc = pVc;
            pVc.provinceDelegate = self;
            
            CZCityViewController *cVc = [[CZCityViewController alloc] init];
            cVc.view.frame = CGRectMake(150, 30, self.view.width * 0.5, 180);
            [menuView addSubview:cVc.view];
            self.cVc = cVc;
            cVc.delegate = self;
            
        }
        
            break;
        case 2:
        {
            //显示菜单
            UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 210)];
            menuView.backgroundColor = [UIColor whiteColor];
            self.menuView = menuView;
            
            LMAgeViewController *avc = [[LMAgeViewController alloc] init];
            avc.view.frame = CGRectMake(0, 0, self.view.width , 210);
            [menuView addSubview:avc.view];
            self.avc = avc;
            avc.delegate = self;
            avc.listArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ageList.plist" ofType:nil]];
            [avc.tableView reloadData];
        }
        
            break;
            
            case 3:
            
        {
            //显示菜单
            UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 210)];
            menuView.backgroundColor = [UIColor whiteColor];
            self.menuView = menuView;
            
            LMlistViewController *lvc = [[LMlistViewController alloc] init];
            lvc.view.frame = CGRectMake(0, 0, self.view.width , 210);
            [menuView addSubview:lvc.view];
            self.lvc = lvc;
            lvc.delegate = self;
            lvc.listArr = self.orderListArr;
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
    self.TypeId = nil;
    
    [self.headView.titleBtn setTitle:@"全  部" forState:UIControlStateNormal];
    [self.headView.titleBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
    
    [self loadParam];
    
    [self.popMenu dismiss];
    
}

- (void)allMenu2
{
    self.areaId = @"0";
    self.levelId = @"0";
    [self.headView.cityBtn setTitle:@"全  城" forState:UIControlStateNormal];
    [self.headView.cityBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
    [self loadParam];
    
    [self.popMenu dismiss];
}

// 选中课程大类的代理方法
- (void)provinceViewController:(CZProvinceViewController *)controller selectedCities:(NSArray *)cities row:(int)row
{
    self.cVc.cities = cities;
    self.cVc.row = row;
}

//传递分类数据的代理
- (void)cityViewController:(CZCityViewController *)cityViewController didSeclctedItem:(NSNumber *)item title:(NSString *)title
{
    self.TypeId = item;
    
    [self.headView.titleBtn setTitle:title forState:UIControlStateNormal];
    [self.headView.titleBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
    
    [self loadParam];
    
    [self.popMenu dismiss];
    
}

// 选中区域大类的代理方法

- (void)areaViewController:(LMAreaViewController *)controller selectedCities:(NSArray *)cities row:(int)row
{
    self.lcc.cities = cities;
    self.lcc.row = row;
}

//选中区域小类的代理

- (void)cityViewController:(LMCityViewController *)cityViewController level:(NSString *)level id:(NSString *)id title:(NSString *)title
{
    self.areaId = id;
    self.levelId = level;
    
    [self.headView.cityBtn setTitle:title forState:UIControlStateNormal];
    [self.headView.cityBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];

    [self loadParam];

    [self.popMenu dismiss];
}

//传递区域大类的index
- (void)areaViewController:(LMAreaViewController *)controller didSelectRow:(int)row
{
    self.lcc.row = row;
}




//年龄代理
- (void)ageViewController:(LMAgeViewController *)ageViewController age:(NSString *)age title:(NSString *)title
{
    self.ageId = [NSString stringWithFormat:@"%@",age];
    
    [self.headView.ageBtn setTitle:title forState:UIControlStateNormal];
    [self.headView.ageBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
    
    [self loadParam];
    
    [self.popMenu dismiss];
}

//筛选代理
- (void)listViewControllerDidClick:(LMlistViewController *)listViewController title:(NSString *)title row:(int)row
{
    self.orderId = row;
    [self.headView.selectedBtn setTitle:title forState:UIControlStateNormal];
    [self.headView.selectedBtn setImage:[UIImage imageNamed:@"btn_class_list_classify_normal"] forState:UIControlStateNormal];
    
    [self loadParam];
    
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


- (NSArray *)areaArr
{
    if (_areaArr == nil) {
        
        NSString *areaStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"areaKey"];
        NSArray *areaArr = [areaStr objectFromJSONString];
        
        NSDictionary *dict = areaArr[0];
        
        NSArray *areaStr1 = dict[@"areas"];
        
        _areaArr = areaStr1;
    }
    return _areaArr;
}


- (NSArray *)courseOrders
{
    if (_courseOrders == nil) {
        _courseOrders = [NSArray array];
    }
    return _courseOrders;
}

- (NSArray *)schoolOrders
{
    if (_schoolOrders == nil) {
        _schoolOrders = [NSArray array];
    }
    return _schoolOrders;
}

- (NSArray *)orderListArr
{
    if (_orderListArr == nil) {
        _orderListArr = [NSArray array];
    }
    return _orderListArr;
}

@end
