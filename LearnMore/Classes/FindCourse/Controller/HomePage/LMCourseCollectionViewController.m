//
//  LMCourseCollectionViewController.m
//  LearnMore
//
//  Created by study on 14-9-29.
//  Copyright (c) 2014年 youxuejingxuan. All rights reserved.
//

#define LMProductCellID @"product"
#import "LMProductCell.h"
#import "LMProduct.h"

#import "LMCourseCollectionViewController.h"
#import "LMCourseListMainViewController.h"

@interface LMCourseCollectionViewController ()

//标题数组
@property (nonatomic, strong) NSArray *titles;

@end

@implementation LMCourseCollectionViewController




- (id)init
{
    //1,流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2,每个cell的尺寸
    layout.itemSize = CGSizeMake(55, 75);
    // 3.设置cell之间的水平间距
    layout.minimumInteritemSpacing = 20;
    // 4.设置cell之间的垂直间距
    layout.minimumLineSpacing = 10;
  
    // 5.设置四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 10, 20);
    
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    // 1.注册cell(告诉collectionView将来创建怎样的cell)
    UINib *nib = [UINib nibWithNibName:@"LMProductCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:LMProductCellID];
    
    
   
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.获得cell
    LMProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LMProductCellID forIndexPath:indexPath];
    
    //取出模型
    LMProduct *product = self.titles[indexPath.row];
    cell.product = product;
    
    return cell;
}

#pragma mark - 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取出模型
    LMProduct *product = self.titles[indexPath.row];
      NSLog(@"点击了------%@",product.title);

    if ([self.delegate respondsToSelector:@selector(courseCollectionViewController:title:)]) {
        
        
        
        [self.delegate courseCollectionViewController:self title:product.title];
    }

}

#pragma mark - 懒加载
- (NSArray *)titles
{
    if (_titles == nil) {

        //获取全路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"totalCourse.plist" ofType:nil];
        //加载数组
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
        
        //字典转模型
        NSMutableArray *productArr = [NSMutableArray array];
        for (NSDictionary *dict in dictArr) {
            LMProduct *proudct = [LMProduct productWithDict:dict];
            [productArr addObject:proudct];
        }
        _titles = productArr;

    }
    return _titles;
}
@end
