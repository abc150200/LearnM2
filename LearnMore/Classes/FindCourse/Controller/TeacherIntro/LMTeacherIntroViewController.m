//
//  LMTeacherIntroViewController.m
//  LearnMore
//
//  Created by study on 14-10-11.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//


#import "LMTeacherIntroViewController.h"
#import "LMSchoolCourseViewCell.h"
#import "LMSchoolIntroButton.h"
#import "AFNetworking.h"
#import "LMTeachList.h"
#import "HTMLParser.h"
#import "FDLabelView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LMTeacherCouse.h"
#import "LMTeacherCourseCell.h"
#import "CLProgressHUD.h"
#import "LMCourseIntroViewController.h"



@interface LMTeacherIntroViewController ()

@property (strong, nonatomic) IBOutlet UIView *iconView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *resultTitleView;

@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teacherImageView;

@property (nonatomic, assign) CGFloat currentY;
@property (nonatomic, assign) CGFloat currentY2;

/** 图文混排容器 */
@property (nonatomic, weak) UIView *htmlView;
@property (nonatomic, weak) UIView *htmlView2;
/** 标记 */
@property (nonatomic, assign) BOOL sign;
/** 数据 */
@property (nonatomic, strong) NSArray *datas;
/** 更多按钮 */
@property (nonatomic, weak) UIButton *moreBtn;
@end

@implementation LMTeacherIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title  = @"老师简介";
    
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkBackground;
    hud.shape = CLProgressHUDShapeCircle;
    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
    
    [self loadInfo];
    
    /** 头部标题 */
    UIView *headView = [[UIView alloc] init];
    headView.x = 0;
    headView.y = 0;
    headView.width =self.view.width;
    headView.height = 300;
    self.headView = headView;
    [headView addSubview:self.iconView];
    
    UIView *htmlView = [[UIView alloc] init];
    htmlView.x = 0;
    htmlView.y = self.iconView.height;
    htmlView.width = self.view.width;
    htmlView.height = 202;
    [self.headView addSubview:htmlView];
    self.htmlView = htmlView;
    
    self.tableView.tableHeaderView = self.headView;
    
    /** 尾部标题 */
    UIView *footView = [[UIView alloc] init];
    footView.x = 0;
    footView.y = 0;
    footView.width =self.view.width;
    footView.height = 300;
    self.footView = footView;
    [footView addSubview:self.resultTitleView];
    
    UIView *htmlView2 = [[UIView alloc] init];
    htmlView2.x = 0;
    htmlView2.y = self.resultTitleView.height;
    htmlView2.width = self.view.width;
    htmlView2.height = 200;
    [self.footView addSubview:htmlView2];
    self.htmlView2 = htmlView2;

    self.tableView.tableFooterView = self.footView;
    
    
    self.tableView.rowHeight = 93;
    
    self.tableView.bounces = NO;
    
    
    //加载按钮
    LMSchoolIntroButton *btn = [[LMSchoolIntroButton alloc] init];
    self.moreBtn = btn;
    self.moreBtn.hidden = YES;
    
    //添加下面的展开按钮
    [btn setTitle:@"更多课程" forState:UIControlStateNormal];
    btn.height = 20;
    btn.centerX = self.view.centerX;
    btn.y = 2;
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setImage:[UIImage imageNamed:@"timeline_icon_more_highlighted"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectedCourse:) forControlEvents:UIControlEventTouchUpInside];
    [self.resultTitleView addSubview:btn];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [CLProgressHUD dismiss];
    
   
}

- (void)selectedCourse:(UIButton *)sender {
    _sign = ! _sign;
    
    [self.tableView reloadData];
    
    if (_sign) {
        [sender setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];
    }else
    {
        [sender setImage:[UIImage imageNamed:@"timeline_icon_more_highlighted"] forState:UIControlStateNormal];
    }
    
}

- (void)loadInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"teacher/info.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
//    arr[@"id"] = @"10";
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        NSDictionary *teacherDic = dateDic[@"teacher"];
//        self.datas = courseArr;
//        [self.tableView reloadData];
        LogObj(teacherDic);
        
        
        if([teacherDic[@"mobile"] length])
        {
            self.phoneNum.text = teacherDic[@"mobile"];
        }else
        {
             self.phoneNum.text = @"暂未录入";
        }
        
        self.teacherNameLabel.text =  teacherDic[@"teacherName"];
            
            [self.teacherImageView sd_setImageWithURL:[NSURL URLWithString:teacherDic[@"teacherImage"]] placeholderImage:[UIImage imageNamed:@"app"]];
            self.teacherImageView.layer.cornerRadius  = 38;
            self.teacherImageView.clipsToBounds = YES;
            
            if([teacherDic[@"schoolName"] isKindOfClass:[NSString class]])
            {
                self.schoolNameLabel.text = teacherDic[@"schoolName"];
            }

        
            [CLProgressHUD dismiss];
            
            /** 解析图文混排数据 */
            NSString *htmlstr = teacherDic[@"teacherDes"];
            [self parseHTMLWithhtmlStr:htmlstr];
            MyLog(@"%f",_currentY);
            self.htmlView.height = _currentY;
            self.titleView.frame = CGRectMake(0, _currentY + self.iconView.height, self.view.width, self.titleView.height);
            [self.headView addSubview:self.titleView];
            self.headView.height = _currentY + self.iconView.height +  self.titleView.height;
            self.tableView.tableHeaderView = self.headView;
            
            /** 处理tableView */
            NSArray *courseArr = [LMTeacherCouse objectArrayWithKeyValuesArray:teacherDic[@"courses"]];
            self.datas = courseArr;
            [self.tableView reloadData];
      
            /** 解析图文混排数据 */
            NSString *htmlstr2 = teacherDic[@"teacherAchieve"];
        
//        if (htmlstr2.length) {
//            <#statements#>
//        }
            [self parse2HTMLWithhtmlStr:htmlstr2];
            MyLog(@"%f",_currentY2);
            self.htmlView2.height = _currentY2;
            self.footView.height = _currentY2 + self.resultTitleView.height;
            self.tableView.tableFooterView = self.footView;

      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datas.count > 3) {
        
        self.moreBtn.hidden = NO;
        return (_sign ? self.datas.count : 3);
    }
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LMTeacherCourseCell";
    
    
    LMTeacherCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMTeacherCourseCell" owner:self options:nil] lastObject];
    }
    
    LMTeacherCouse *course = self.datas[indexPath.row];
    
    cell.teachCourse = course;

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMTeacherCouse *tCourse = self.datas[indexPath.row];
    
    long long id = tCourse.id;
    
    
    LMCourseIntroViewController *ci  = [[LMCourseIntroViewController alloc] init];
    ci.id = id;
    
    [self.navigationController pushViewController:ci animated:YES];
    
}






- (void)parseAllChildernHtmlNode:(HTMLNode *) inputNode : (NSMutableArray *) array
{
    for (HTMLNode *node in [inputNode children]) {
        [self parseSingleNode:node :array];
    }
}

- (void)parseSingleNode:(HTMLNode *)node : (NSMutableArray *) array
{
    if (node.nodetype == HTMLImageNode) {
        [array addObject:node];
        
    }
    if (node.nodetype == HTMLTextNode) {
        [array addObject:node];
    }
    
    [self parseAllChildernHtmlNode:node :array];
}



- (void)parseHTMLWithhtmlStr:(NSString *)htmlStr
{
    NSString  *html = [htmlStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        MyLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSMutableArray *result = [NSMutableArray array];
    [self parseAllChildernHtmlNode:bodyNode : result];
    
    
    for (HTMLNode *node in result) {
        if (node.nodetype == HTMLImageNode) {
            [self addSubImageView:[node getAttributeNamed:@"src"]];
        }
       
        if (node.nodetype == HTMLTextNode) {
            
            NSString *text = [node.rawContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            if (text.length > 0) {
                [self addSubText:text];
            }
            
        }
        
    }
    
}

- (void)addSubImageView:(NSString *)imageURL {
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    
    CGFloat height = (self.view.frame.size.width-30)/img.size.width * img.size.height;
    CGRect rect = CGRectMake(15, _currentY, self.view.frame.size.width-30, height);
    _currentY += height + 10;
    _htmlView.size = CGSizeMake(self.view.size.width, _currentY);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    [imageView setImage:img];
    
    CALayer *layer=[imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
    [_htmlView addSubview:imageView];
    
}





//添加文章段落
- (void)addSubText:(NSString *)content {
    
    
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, _currentY, 300, 0)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.00];
    titleView.textColor = [UIColor blackColor];
    titleView.font = [UIFont systemFontOfSize:14];
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.lineHeightScale = 0.80;
    titleView.fixedLineHeight = 20;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [_htmlView addSubview:titleView];
    
    _currentY += titleView.visualTextHeight + 10;
    _htmlView.size = CGSizeMake(self.view.size.width, _currentY);
    
    titleView.debug = NO;
}





- (void)parse2HTMLWithhtmlStr:(NSString *)htmlStr
{
    NSString  *html = [htmlStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        MyLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSMutableArray *result = [NSMutableArray array];
    [self parseAllChildernHtmlNode:bodyNode : result];
    
    
    for (HTMLNode *node in result) {
        if (node.nodetype == HTMLImageNode) {
            [self add2SubImageView:[node getAttributeNamed:@"src"]];
        }
        
        if (node.nodetype == HTMLTextNode) {
            
            NSString *text = [node.rawContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            if (text.length > 0) {
                [self add2SubText:text];
            }
            
        }
        
    }
    
}

- (void)add2SubImageView:(NSString *)imageURL {
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    
    CGFloat height = (self.view.frame.size.width-30)/img.size.width * img.size.height;
    CGRect rect = CGRectMake(15, _currentY2, self.view.frame.size.width-30, height);
    _currentY2 += height + 10;
    _htmlView2.size = CGSizeMake(self.view.size.width, _currentY2);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    [imageView setImage:img];
    
    CALayer *layer=[imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
    [_htmlView2 addSubview:imageView];
    
}





//添加文章段落
- (void)add2SubText:(NSString *)content {
    
    
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, _currentY, 300, 0)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.00];
    titleView.textColor = [UIColor blackColor];
    titleView.font = [UIFont systemFontOfSize:14];
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.lineHeightScale = 0.80;
    titleView.fixedLineHeight = 20;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [_htmlView2 addSubview:titleView];
    
    _currentY2 += titleView.visualTextHeight + 10;
    _htmlView2.size = CGSizeMake(self.view.size.width, _currentY2);
    
    titleView.debug = NO;
}


@end
