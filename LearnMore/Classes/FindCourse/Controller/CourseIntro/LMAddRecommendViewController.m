//
//  LMRecommendViewController.m
//  LearnMore
//
//  Created by study on 14-11-28.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#import "LMAddRecommendViewController.h"
#import "LMComposeView.h"
#import "AFNetworking.h"
#import "LMAccountInfo.h"
#import "LMAccount.h"
#import "NSData+CommonCrypto.h"
#import "FileMD5Hash.h"

#import "GTMBase64.h"
#import "AESenAndDe.h"
#import "AESenAndDe.h"

#import "MBProgressHUD+NJ.h"

#import "TQStarRatingView.h"

#define LMPhotoWH 69

#define LMPhotoLeft 15
#define LMPhotoPadding 5
#define LMPhotoTop 99


#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@interface LMAddRecommendViewController ()<UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    //    AFHTTPClient    *_httpClient;
    //    NSOperationQueue *_queue;
    
}
@property (weak, nonatomic)  UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) LMComposeView *tv;
//@property (weak, nonatomic) IBOutlet UIImageView *iv1;
//@property (weak, nonatomic) IBOutlet UIImageView *iv2;
//@property (weak, nonatomic) IBOutlet UIImageView *iv3;
@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, strong) NSMutableArray *images;
@property (copy, nonatomic) NSString *filePath;

@property (copy, nonatomic) NSString *sessionkey;
@property (copy, nonatomic) NSString *sid;

@property (nonatomic, strong) NSMutableArray *imagesUrl;
@property (nonatomic, strong) NSMutableArray *thumbImagesUrl;

@property (nonatomic, copy) NSString *imagesUrlStr;

@property (copy, nonatomic) NSMutableArray *imageNames;//存储图片名的数组
@property (nonatomic, copy)  NSString *DocumentsPath;

@property (weak, nonatomic) IBOutlet UILabel *star1;
@property (weak, nonatomic) IBOutlet UILabel *star2;

@property (strong, nonatomic) IBOutlet UIButton *picBtn;

@property (weak, nonatomic) IBOutlet UIView *totalRec;//总体评价
@property (weak, nonatomic) IBOutlet UIView *perRec;//每个评价
@property (weak, nonatomic) IBOutlet UIView *commitView;

@property (copy, nonatomic) NSString *TotalValue;
@property (copy, nonatomic) NSString *starValue1;
@property (copy, nonatomic) NSString *starValue2;
@property (copy, nonatomic) NSString *starValue3;
@property (copy, nonatomic) NSString *starValue4;

@end



@implementation LMAddRecommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contentView];
    self.contentView = contentView;
    
    LMComposeView *tv = [[LMComposeView alloc] init];
    tv.backgroundColor = [UIColor whiteColor];
    tv.frame = CGRectMake(15, 5, self.view.width - 30, 99);
    tv.placeholder = @"亲,老师授课如何,环境如何,价格合不合适,是否学到东西了呢";
    [self.contentView addSubview:tv];
    tv.delegate = self;
    self.tv = tv;
    
    /** 添加图片 */
    [self.contentView addSubview:self.picBtn];
    self.picBtn.frame = CGRectMake(15, 99, LMPhotoWH, LMPhotoWH);
    
    self.contentView.x = 0;
    self.contentView.y = CGRectGetMaxY(self.perRec.frame) + 8.5;
    self.contentView.width = self.view.width;
    self.contentView.height = 177.5;
    
    self.commitView.y = CGRectGetMaxY(self.contentView.frame);
    [self.scrollView addSubview:self.commitView];
    
    
    
    
    self.title = @"添加点评";
    
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(99, 18, 190, 30) numberOfStar:5 norImage:@"review_new_normal_flower" highImage:@"review_new_pressed_flower" starSize:30 margin:10];
    [self.totalRec addSubview:starRatingView];

    starRatingView.completion = ^(float score)
    {
         self.TotalValue = [NSString stringWithFormat:@"%0.1f",score * 5];
        MyLog(@"self.TotalValue===%@",self.TotalValue);
    };
    
    TQStarRatingView *starRatingView1 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(92, 3, 190, 30) numberOfStar:5 norImage:@"review_new_normal" highImage:@"review_new_pressed" starSize:30 margin:10];
    [self.perRec addSubview:starRatingView1];
    
    starRatingView1.completion = ^(float score)
    {
         self.starValue1 = [NSString stringWithFormat:@"%0.1f",score * 5];
    };
    
    TQStarRatingView *starRatingView2 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(92, 36, 190, 30) numberOfStar:5 norImage:@"review_new_normal" highImage:@"review_new_pressed" starSize:30 margin:10];
    [self.perRec addSubview:starRatingView2];
    
    starRatingView2.completion = ^(float score)
    {
        self.starValue2 = [NSString stringWithFormat:@"%0.1f",score * 5];
    };
    
    
    TQStarRatingView *starRatingView3 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(92, 69, 190, 30) numberOfStar:5 norImage:@"review_new_normal" highImage:@"review_new_pressed" starSize:30 margin:10];
    [self.perRec addSubview:starRatingView3];
    
    starRatingView3.completion = ^(float score)
    {
        self.starValue3 = [NSString stringWithFormat:@"%0.1f",score * 5];
    };
    
    
    TQStarRatingView *starRatingView4 = [[TQStarRatingView alloc] initWithFrame:CGRectMake(92, 102, 190, 30) numberOfStar:5 norImage:@"review_new_normal" highImage:@"review_new_pressed" starSize:30 margin:10];
    [self.perRec addSubview:starRatingView4];
    
    starRatingView4.completion = ^(float score)
    {
        self.starValue4 = [NSString stringWithFormat:@"%0.1f",score * 5];
    };
  
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 300);
    self.scrollView.delegate = self;
    
}

- (IBAction)camera:(id)sender {
    UIActionSheet *mySheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从相册中选取", nil];
    
    [mySheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        MyLog(@"取消");
    }
    
    switch (buttonIndex) {
        case 0:
        [self takePhoto];
        break;
        
        case 1:
        [self localPhoto];
        break;
        
        default:
        break;
    }
}

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}




#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MyLog(@"info = %@", info);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    
    //设置image的尺寸
    CGSize imagesize = image.size;
    imagesize.height =320;
    imagesize.width =320;
    //对图片大小进行压缩--
    image = [self imageWithImage:image scaledToSize:imagesize];
    NSData *data = UIImageJPEGRepresentation(image,3);
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    self.DocumentsPath = DocumentsPath;
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[NSString timeNow]];//图片名
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingPathComponent:imageName] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    self.filePath = [DocumentsPath stringByAppendingPathComponent:imageName];
    
    [self.imageNames addObject:imageName];

    MyLog(@"self.filePath===%@",self.filePath);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.images addObject:image];
    
    
    int totalCols = 4;
    for (int i = 0; i < self.images.count; i++) {
        UIImageView *iv = [[UIImageView alloc] init];
        //计算行号和列号
        int col = i % totalCols;
        int row = i / totalCols;
        
        iv.x = LMPhotoLeft + col * (LMPhotoWH + LMPhotoPadding);
        iv.y = LMPhotoTop + row * (LMPhotoWH + LMPhotoPadding);
        iv.width = LMPhotoWH;
        iv.height = LMPhotoWH;
        
        iv.image = self.images[i];
        
        [self.contentView addSubview:iv];
       
    }
    int count = self.imageNames.count;
    
    self.picBtn.x = LMPhotoLeft + ((count + 4) % totalCols) * (LMPhotoWH + LMPhotoPadding);
    self.picBtn.y = LMPhotoLeft + ((count + 4) / totalCols) * (LMPhotoWH + LMPhotoPadding) + 9.5;
    
    
    self.contentView.height = LMPhotoTop + LMPhotoWH * ((self.images.count)/totalCols + 1) + 9.5;
    
    self.commitView.y = CGRectGetMaxY(self.contentView.frame);
    
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


- (IBAction)commit:(id)sender {
    
    
    
    //获取账号信息
    LMAccount *account = [LMAccountInfo sharedAccountInfo].account;
    self.sessionkey = account.sessionkey;
    self.sid = account.sid;
    
    [MBProgressHUD showMessage:@"正在上传..."];
    
    if (self.imageNames.count)
    {
        
        for (int i = 0; i < self.imageNames.count; i++) {
            
            NSString *imgName = self.imageNames[i];
            
            NSString *fullPath = [self.DocumentsPath stringByAppendingPathComponent:imgName];
            
            //文件的MD5
            NSString *MD5Data = [FileMD5Hash computeMD5HashOfFileInPath:fullPath];
            
            
            //获取文件的大小
            NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            
            
            //data参数
            NSMutableDictionary *arr = [NSMutableDictionary dictionary];
            arr[@"md5"] = MD5Data;
            arr[@"fname"]= imgName;
            arr[@"time"] = [NSString timeNow];
            arr[@"size"] = dic[NSFileSize];
            MyLog(@"name===%@",arr[@"size"]);
            
            /** 转成json字符串 */
            NSString *jsonStr = [arr JSONString];
            MyLog(@"%@",jsonStr);
            /** AES加密 */
            NSString *dataJson = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:account.sessionkey];
            
            //上传的参数
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"data"] = dataJson ;
            parameters[@"sid"] = account.sid;
            
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:fullPath];
            NSData *imageData = UIImagePNGRepresentation(image);
            
            [self upload:@"file" filename:imgName mimeType:@"image/png" data:imageData parmas:parameters];
            
        }
    }else
    {
        [self sendRecommend];
    }
    
    
    
}

/** 上传方法 */
- (void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params
{
    
    NSString *urlS = [NSString stringWithFormat:@"%@%@",RequestURL,@"file/fileUpload.json"];
    // 文件上传
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
    /***************文件参数***************/
    // 参数开始的标志
    [body appendData:YYEncode(@"--YY\r\n")];
    // name : 指定参数名(必须跟服务器端保持一致)
    // filename : 文件名
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:YYEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:YYEncode(type)];
    
    [body appendData:YYEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:YYEncode(@"\r\n")];
    
    /***************普通参数***************/
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 参数开始的标志
        [body appendData:YYEncode(@"--YY\r\n")];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:YYEncode(disposition)];
        
        [body appendData:YYEncode(@"\r\n")];
        [body appendData:YYEncode(obj)];
        [body appendData:YYEncode(@"\r\n")];
    }];
    
    /***************参数结束***************/
    // YY--\r\n
    [body appendData:YYEncode(@"--YY--\r\n")];
    request.HTTPBody = body;
    
    // 设置请求头
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    // 声明这个POST请求是个文件上传
    [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            MyLog(@"%@", dict);
            
            long long code = [dict[@"code"] longLongValue];
            
            switch (code) {
                
                case 10001:
                {
                    NSString *data = [AESenAndDe De_Base64andAESDeToString:dict[@"data"] keyValue:self.sessionkey];
                    NSDictionary *dict2 = [data objectFromJSONString];
                    
                    NSString *url = dict2[@"url"];//缩略图
                    [self.imagesUrl addObject:url];
                    MyLog(@"self.imagesUrl===%@",self.imagesUrl);
                    
                    NSString *thumbUrl = dict2[@"thumbUrl"];//大图
                    [self.thumbImagesUrl addObject:thumbUrl];
                    MyLog(@"self.thumbImagesUrl===%@",self.thumbImagesUrl);
                    
                    if(self.imagesUrl.count == self.images.count )
                    {
                         NSString *str = [self.imagesUrl componentsJoinedByString:@","];
                        self.imagesUrlStr = str;
                        [self sendRecommend];
                    }
                }
                break;
                
                
                case 30002:
                {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"用户未登录或超时,请重新登录"];
                }
                break;
                
                default:
                break;
            }
            
        } else {
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"上传失败"];
            
            }
            
        }
    }];
}

//发送点评
- (void)sendRecommend
{
    if(self.tv.text.length < 10)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"评论不得少于10个字!"];
        return;
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //url地址
    NSString *url = [NSString stringWithFormat:@"%@%@",RequestURL,@"comment/courseComment.json"];
    
    
    //参数
    NSMutableDictionary *arr = [NSMutableDictionary dictionary];
    arr[@"id"] = [NSString stringWithFormat:@"%lli",_id];
    arr[@"level"] = self.TotalValue;
    MyLog(@"level===%@",self.TotalValue);
    arr[@"level1"] = self.starValue1;
     MyLog(@"level1===%@",self.starValue1);
    arr[@"level2"] = self.starValue2;
    arr[@"level3"] = self.starValue3;
    arr[@"level4"] = self.starValue4;
    if (self.images.count) {
         arr[@"imgs"] = self.imagesUrlStr;
    }
   
    arr[@"text"] = self.tv.text;
    
    NSString *jsonStr = [arr JSONString];
    MyLog(@"%@",jsonStr);
    
    //加密
    NSString *dataJson = [AESenAndDe En_AESandBase64EnToString:jsonStr keyValue:self.sessionkey];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"data"] = dataJson;
    parameters[@"sid"] = self.sid;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogObj(responseObject);

        long long code2 = [responseObject[@"code"] longLongValue];
        
        switch (code2) {
            case 10001:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"上传成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            break;
            
            case 64001:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"点评内容不能为空"];
            }
            
            break;
            
            case 64002:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"综合点评等级不能为空或超出评分范围"];
            }
            break;
            
            case 64101:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"教学质量不能为空或超出评分范围"];
            }
            break;
            
            case 64102:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"师资力量不能为空或超出评分范围"];
            
            }
            break;
            
            case 64103:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"校区环境不能为空或超出评分范围"];
            }
            break;
            
            case 64104:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"交通便利不能为空或超出评分范围"];
            }
            break;
           
            
            default:
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"上传失败"];
            }
            break;
        }
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObj(error.localizedDescription);
    }];
}



- (NSMutableArray *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}


//- (NSMutableArray *)imageViews
//{
//    if (_imageViews == nil) {
//        _imageViews = @[self.iv1,self.iv2,self.iv3];
//    }
//    return _imageViews;
//}

- (NSMutableArray *)imagesUrl
{
    if (_imagesUrl == nil) {
        _imagesUrl = [NSMutableArray array];
    }
    return _imagesUrl;
}


- (NSMutableArray *)thumbImagesUrl
{
    if (_thumbImagesUrl == nil) {
        _thumbImagesUrl = [NSMutableArray array];
    }
    return _thumbImagesUrl;
}

- (NSMutableArray *)imageNames
{
    if (_imageNames == nil) {
        _imageNames = [NSMutableArray array];
    }
    return _imageNames;
}


@end
