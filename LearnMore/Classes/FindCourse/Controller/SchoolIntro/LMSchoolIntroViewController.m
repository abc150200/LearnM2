//
//  LMSchoolIntroViewController.m
//  LearnMore
//
//  Created by study on 14-10-9.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMPadding 20
#define LMLeftPadding 15

#import "LMTeacherIntroViewController.h"
#import "LMSchoolIntroViewController.h"
#import "LMSchoolCourseViewCell.h"
#import "LMTeacherButton.h"
#import "LMSchoolCourse.h"
#import "LMSchoolIntroButton.h"
#import "AFNetworking.h"
#import "LMTeachList.h"
#import "HTMLParser.h"
#import "FDLabelView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LMCourseInfo.h"
#import "ACETelPrompt.h"
#import "CLProgressHUD.h"
#import "LMCourseIntroViewController.h"
#import "LMOneSchRecViewController.h"


@interface LMSchoolIntroViewController ()

/** 标记 */
@property (nonatomic, assign) BOOL sign;

/** 头部标题 */
@property (nonatomic, strong) UIView *headView;

@property (strong, nonatomic) IBOutlet UIView *schoolDisplay;

/** 尾部标题 */
@property (strong, nonatomic)  UIView *footView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *schoolImageView;

@property (weak, nonatomic) IBOutlet UILabel *schoolFullNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *contactPhoneBtn;

/** 假数据 */
@property (nonatomic, strong) NSArray *datas;

/** 教学成果 */
@property (weak, nonatomic)  UIView *htmlView;
/** 高度 */
@property (nonatomic, assign) CGFloat currentY;

@property (strong, nonatomic)  UIView *teacherInfo;

@property (strong, nonatomic) IBOutlet UIView *teachView;

/** 电话 */
@property (strong, nonatomic) IBOutlet UIView *phone;

/** 老师列表 */
@property (nonatomic, strong) NSArray *teachers;

/** 更多按钮 */
@property (nonatomic, weak) LMSchoolIntroButton *moreBtn ;

/** 老师的id */
@property (nonatomic, assign) long long teacherId;

/** 电话 */
@property (copy, nonatomic) NSString *phoneNum;

@property (copy, nonatomic) NSString *htmlStr;


@property (weak, nonatomic) IBOutlet UILabel *level1;
@property (weak, nonatomic) IBOutlet UILabel *level2;
@property (weak, nonatomic) IBOutlet UILabel *level3;
@property (weak, nonatomic) IBOutlet UILabel *level4;


@property (weak, nonatomic) IBOutlet UILabel *courseMack;

@property (weak, nonatomic) IBOutlet UILabel *parentRec;

@property (strong, nonatomic) IBOutlet UIView *recHeadView;//点评头部标题
@property (strong, nonatomic) IBOutlet UIView *recFootView;//点评尾部标题

@property (nonatomic, weak) LMOneSchRecViewController *srv;

@end

@implementation LMSchoolIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.title = @"机构信息";
    
//    CLProgressHUD *hud = [CLProgressHUD shareInstance];
//    hud.type = CLProgressHUDTypeDarkBackground;
//    hud.shape = CLProgressHUDShapeCircle;
//    [hud showInView:[UIApplication sharedApplication].keyWindow withText:@"正在加载"];
//    [CLProgressHUD dismiss];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 375)];
    headView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.headView = headView;
    self.tableView.tableHeaderView = self.headView;
    
    [self.headView addSubview:self.schoolDisplay];
    self.schoolDisplay.frame = CGRectMake(0, 0, self.view.width, self.schoolDisplay.height);
    
   
    //添加点评
    LMOneSchRecViewController *srv = [[LMOneSchRecViewController alloc] init];
    self.srv = srv;
    srv.view.x = 0;
    srv.view.y = CGRectGetMaxY(self.schoolDisplay.frame) + 20;
    srv.view.width = self.view.width;
    
    srv.tableView.tableHeaderView = self.recHeadView;
    srv.tableView.tableFooterView = self.recFootView;
    
    [self.headView addSubview:srv.view];
    
    self.srv.view.height = 152 ;
 
    
    self.tableView.bounces = NO;

    self.tableView.tableHeaderView = self.headView;
    
    UIView *footView = [[UIView alloc] init];
    footView.x = 0;
    footView.y = 0;
    footView.width = self.view.width;
    footView.backgroundColor = [UIColor whiteColor];
    footView.height = 200 + 45 + 60;
    
    
    self.footView = footView;

    
    [self.footView addSubview:self.teachView];
    
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
    [self.teachView addSubview:btn];

    
    [self.teachView addSubview:self.scrollView];
    
    
    self.scrollView.contentSize = CGSizeMake(550, 80);
   
    
    self.tableView.rowHeight = 93;
    
    self.tableView.sectionFooterHeight = 0;
    
    
    UIView *htmlView = [[UIView alloc] init];
    htmlView.x = 0;
    htmlView.y = 250;
    htmlView.width = self.view.width;
    htmlView.height = 200;
    [self.footView addSubview:htmlView];
    _htmlView = htmlView;
    
    self.tableView.tableFooterView = footView;
    
    [self loadSchoolRec];
    
    [self loadData];
 
    [self loadCourse];
    
    [self loadTeacher];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [CLProgressHUD dismiss];
    
}


/** 学校点评 */
- (void)loadSchoolRec
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];


    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/list.json"];


    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",self.id];
    arr[@"type"] = @"3";
    arr[@"time"] = [NSString timeNow];
    arr[@"count"] = @"1";

    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;


    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        LogObj(responseObject);

        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        MyLog(@"%@",dateDic);

//        NSArray *recomArr = [LMRecommend objectArrayWithKeyValuesArray:dateDic[@"comments"]];
//        NSMutableArray *frameModels = [NSMutableArray arrayWithCapacity:recomArr.count];
//        for (LMRecommend *recom in recomArr) {
//            LMRecommedFrame *recomFrame = [[LMRecommedFrame alloc] init];
//            recomFrame.recommend = recom;
//            [frameModels addObject:recomFrame];
//        }
//
//        self.recomFrames = frameModels;
//
//
//
//        [self.tableView reloadData];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}

- (void)loadTeacher
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"teacher/list.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"school"] = [NSString stringWithFormat:@"%lli",_id];
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        self.teachers = [LMTeachList objectArrayWithKeyValuesArray:dateDic[@"teacherList"]];
        
        //添加教师头部图片
        for (int i = 0; i < self.teachers.count; i++) {
            LMTeachList *teacher = self.teachers[i];
//             = teacher.id;
//            MyLog(@"%lli=======老师id",self.teacherId);
            LMTeacherButton *btn = [LMTeacherButton buttonWithType:UIButtonTypeCustom];
            btn.tag = (int)teacher.id;
            btn.frame = CGRectMake(15+i*80, 2, 56, 80);
            [btn setTitle:[NSString stringWithFormat:@"%@",teacher.teacherName] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            btn.imageView.layer.cornerRadius = 28;
            btn.imageView.clipsToBounds = YES;
            
            LogObj(teacher.teacherImage);
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:teacher.teacherImage]];
            [btn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            
            [self.scrollView addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}

- (void)loadCourse
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"course/list.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"school"] = [NSString stringWithFormat:@"%lli",_id];
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        NSArray *courseArr = [LMCourseInfo objectArrayWithKeyValuesArray:dateDic[@"courseList"]];
        self.datas = courseArr;
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}



- (void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"school/info.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
    
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"param"] = jsonStr;
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dateDic = [responseObject[@"data"] objectFromJSONString];
        
        
        /** 取出字典 */
        NSDictionary *schoolInfoDic = dateDic[@"school"];
        LogObj(dateDic[@"school"]);
        
        self.phoneNum = schoolInfoDic[@"contactPhone"];
        
     
            self.addressLabel.text = schoolInfoDic[@"address"];
            
            
            if ([schoolInfoDic[@"schoolImage"] isKindOfClass:[NSString class]] )
            {
                [self.schoolImageView sd_setImageWithURL:[NSURL URLWithString:schoolInfoDic[@"schoolImage"]] placeholderImage:[UIImage imageNamed:@"activity"]];
            }
            
          
            
            self.schoolFullNameLabel.text = schoolInfoDic[@"schoolFullName"];
            
            
            NSString *htmlStr = schoolInfoDic[@"discription"];
            self.htmlStr = htmlStr;
            LogObj(schoolInfoDic[@"discription"]);
            
        
        
            if (htmlStr.length) {
                [self parseHTMLWithhtmlStr:htmlStr];
            }else
            {
               
                UILabel *label = [[UILabel alloc] init];
                label.text = @"暂未录入";
                label.font = [UIFont systemFontOfSize:14];
                label.frame = CGRectMake(15, 247, 100, 60);
                [self.footView addSubview:label];
                
                self.htmlView.height = _currentY ;
                
                self.footView.height = _currentY + 245 + 60;
                
                self.tableView.tableFooterView = self.footView;
            }
            
            
            LogObj(self.htmlView);
            
            MyLog(@"%f",_currentY);
            
//            self.htmlView.height = _currentY;
//            
//            self.footView.height = _currentY + 245 ;
//            
//            self.tableView.tableFooterView = self.footView;
            

        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}


- (IBAction)call:(id)sender {
    
    if (self.phoneNum.length) {
        
        [ACETelPrompt callPhoneNumber:self.phoneNum call:^(NSTimeInterval duration) {
            
        } cancel:^{
            
        }];
    }
    
}

- (void)btnClick:(UIButton *)btn
{
    MyLog(@"%@",btn.currentTitle);
    
    LMTeacherIntroViewController *ti = [[LMTeacherIntroViewController alloc] init];
    ti.id = btn.tag;
    MyLog(@"%lli===========ti.id====",ti.id);
    [self.navigationController pushViewController:ti animated:YES];
    ti.title = @"老师介绍";
    
    
     
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
    static NSString *ID = @"LMSchoolCourseViewCell";
    
    
    LMSchoolCourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LMSchoolCourseViewCell" owner:self options:nil] lastObject];
    }
    
    LMCourseInfo *course = self.datas[indexPath.row];
    
    cell.course = course;
   
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCourseInfo *tCourse = self.datas[indexPath.row];
    
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
    
   
    __block UIImage *img;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 10;
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat height = (self.view.frame.size.width-30)/img.size.width * img.size.height;
            CGRect rect = CGRectMake(15, _currentY, self.view.frame.size.width-30, height);
            _currentY += height + 10;
            _htmlView.size = CGSizeMake(self.view.size.width, _currentY);
            MyLog(@"_currentxxxxx = %f",_currentY);
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
            [imageView setImage:img];
            CALayer *layer=[imageView layer];
            [layer setMasksToBounds:YES];
            [layer setCornerRadius:10.0];
            [layer setBorderWidth:1];
            [layer setBorderColor:[[UIColor blackColor] CGColor]];
            [_htmlView addSubview:imageView];
            
            self.htmlView.height = _currentY;
            
            self.footView.height = _currentY + 245 ;
            
            self.tableView.tableFooterView = self.footView;
//            if(self.html2.length)
//            {
//                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.resultView.frame));
//            }else
//            {
//                self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.teacherView.frame));
//            }
        });
        
    }];
    
    [queue addOperation:operation1];


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
    
    self.htmlView.height = _currentY;
    
    self.footView.height = _currentY + 245 ;
    
    self.tableView.tableFooterView = self.footView;
}


@end
