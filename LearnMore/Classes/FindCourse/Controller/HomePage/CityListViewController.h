//
//  CityListViewController.h
//  CityList
//
//  Created by Chen Yaoqiang on 14-3-6.
//
//

#import <UIKit/UIKit.h>
@class CityListViewController;

//自定义代理
@protocol CityListViewControllerDelegate <NSObject>

@optional
- (void)cityListViewController:(CityListViewController * )cityListViewController didSeclectCity:(NSString *)city;
@end

@interface CityListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;

@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, weak) id<CityListViewControllerDelegate> delegate;

@end

