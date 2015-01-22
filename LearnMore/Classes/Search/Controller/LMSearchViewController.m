//
//  LMSearchViewController.m
//  LearnMore
//
//  Created by study on 14-10-23.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//
#define Padding  5

#import "LMSearchViewController.h"
#import "LMSearchBar.h"
#import "LMCourseListMainViewController.h"

@interface LMSearchViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
/** 导航栏标题 */
@property (nonatomic, strong) UIView *titleView;

@property (strong, nonatomic) IBOutlet UIView *headView;
/** 搜索历史数组 */
@property (nonatomic, strong) NSMutableArray *historyList;

/** 搜索单元数组 */
@property (nonatomic, strong) NSArray *btnList;

/** 搜索单元视图 */
@property (nonatomic, weak) UIView *BtnView;

@property (nonatomic, weak) LMSearchBar *searchBar;
@end

@implementation LMSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     _btnList = @[@"国学",@"舞蹈",@"艺术",@"绘画",@"创意",@"街舞",@"象棋",@"围棋",@"英语"];
    int totalCount = _btnList.count;
    MyLog(@"name===%d",_btnList.count);
    int top = 37;
    int left = 10;
    int totalCol = 3;
//    创建九宫格
    for (int i = 0; i < totalCount; i++) {
        UIButton *btn = [[UIButton alloc] init];
        
        CGFloat btnW = (self.view.width - left * 2 - Padding * (totalCol - 1) ) / totalCol;
        CGFloat btnH = 40;
        
        int row =  i / totalCol;
        int col =  i % totalCol;
        
       CGFloat btnX = left + (btnW + Padding) * col;
       CGFloat btnY = top + (btnH + Padding) * row;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [self.headView addSubview:btn];
        
        [btn setTitle:self.btnList[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
         btn.backgroundColor  = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClickSearch:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    self.tableView.tableHeaderView = self.headView;
    self.tableView.backgroundColor = self.headView.backgroundColor;
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 60, 30)];
    // 将自定义的titleView 设置为导航栏的titleView
    self.navigationItem.titleView = self.titleView;
    
    
    //设置搜索框
    LMSearchBar *searchBar = [[LMSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 70, 30)];
    searchBar.background = [UIImage resizableImageWithName:@"class_list_search_case"];
    searchBar.placeholder = @"请输入关键字";
    searchBar.font = [UIFont systemFontOfSize:14];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    [self.titleView addSubview:searchBar];
    
//    //设置右边的取消按钮
//    // 初始化按钮
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBar.frame) + 20 , 0, 30, 30)];
//    // 设置按钮的文字
//    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
//    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    // 添加监听事件
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.titleView addSubview:backBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    //创建尾部清除按钮
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    #warning 暂时禁掉
//    [btn setTitle:@"清除搜索记录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.tableFooterView = btn;
    
#warning 分割线为何不出来
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    //退出键盘手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGr];
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.searchBar resignFirstResponder];
 
}
                        


- (void)btnClickSearch:(UIButton *)btn
{
    MyLog(@"23323===%@",btn.currentTitle);
    
    [self.historyList addObject:btn.currentTitle];
    
    LMCourseListMainViewController *lv = [[LMCourseListMainViewController alloc] init];
    lv.from = FromeSearch;
    [self.navigationController pushViewController:lv animated:YES];
    lv.searchContent = btn.currentTitle;
    self.searchBar.text = nil;

}

// 取消按钮点击事件
- (void)back
{
    [self.searchBar endEditing:YES];
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏系统的3个按钮,后面自己定义
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

#warning 还要存在数据库里面
- (void)btnClick
{
    self.historyList = nil;
    [self.tableView reloadData];
    [self.tableView.tableFooterView removeFromSuperview];
}

//点击了搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.historyList addObject:textField.text];
    

    LMCourseListMainViewController *lv = [[LMCourseListMainViewController alloc] init];
    lv.from = FromeSearch;
    [self.navigationController pushViewController:lv animated:YES];
    lv.searchContent = self.searchBar.text;
    self.searchBar.text = nil;

    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning 暂时禁掉
//    return self.historyList.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *ID = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.historyList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    LMCourseListMainViewController *lv = [[LMCourseListMainViewController alloc] init];
    lv.from = FromeSearch;
    [self.navigationController pushViewController:lv animated:YES];
    lv.searchContent = cell.textLabel.text;
    self.searchBar.text = nil;

}


- (NSMutableArray *)historyList
{
    if (_historyList == nil) {
        _historyList = [NSMutableArray array];
    }
    return _historyList;
}


@end
