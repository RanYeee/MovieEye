//
//  CinemaListViewController.m
//  MovieEye
//
//  Created by Rany on 17/3/7.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaListViewController.h"
#import "CinemaListModel.h"
#import "CinemaListCell.h"
#import "AreaListView.h"
@interface CinemaListViewController ()<UITableViewDelegate,UITableViewDataSource,QMUINavigationTitleViewDelegate>

/** button*/
@property (nonatomic, strong) UIButton *addressButton;

/** tableview*/
@property (nonatomic, strong) UITableView *tableView;

/** 本地区所有影院的字典*/
@property (nonatomic, strong) NSDictionary *areaInfoDict;

/** 地区名数组*/
@property (nonatomic, strong) NSMutableArray *areaNameArray;

/** 影院模型数组*/
@property (nonatomic, strong) NSMutableArray *modelArray;


/** AreaListView*/
@property (nonatomic, strong) AreaListView *arealistView;

@end

@implementation CinemaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影院";
    
    UIView *customView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:customView];
    
    self.addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.addressButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    self.addressButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.addressButton.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
    
    [customView addSubview:self.addressButton];
    
    [self.addressButton addTarget:self action:@selector(chooseArea) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height-44-64) style:UITableViewStyleGrouped];
    self.tableView.top = self.addressButton.bottom;
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [customView addSubview:self.tableView];
    
    self.arealistView = [[AreaListView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 0, SCREEN_WIDTH/3, SCREEN_HEIGHT-64-44)];
    
    self.arealistView.top = self.addressButton.bottom;
    
    [customView insertSubview:self.arealistView atIndex:0];
    
    [self initData];
  
}


- (NSMutableArray *)areaNameArray {
    if (!_areaNameArray) {
        _areaNameArray = [NSMutableArray array];
    }
    return _areaNameArray;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
    }
    return _modelArray;
}

- (void)chooseArea
{
    if (self.addressButton.isSelected) {
        

        [UIView animateWithDuration:0.4 animations:^{
            
            [self.tabBarController.tabBar setHidden:NO];

            self.addressButton.left+=SCREEN_WIDTH/3;
            
            self.tableView.left+=SCREEN_WIDTH/3;
            self.tabBarController.tabBar.left+=SCREEN_WIDTH/3;

        }];
        
    }else{
        
        [UIView animateWithDuration:0.4 animations:^{
            
//            [self.tabBarController.tabBar setHidden:YES];

            self.tabBarController.tabBar.left-=SCREEN_WIDTH/3;
            self.addressButton.left-=SCREEN_WIDTH/3;
            
            self.tableView.left-=SCREEN_WIDTH/3;
            

            
        }];
        
    }
    
    self.addressButton.selected = !self.addressButton.isSelected;

}

#pragma mark - 数据加载

- (void)initData
{
    [QMUITips showLoadingInView:self.view];

    
    [[APIRequestManager shareInstance]getHTTPPath:API_CINEMA_LIST success:^(id request) {
        
        NSLog(@"%@",request[@"data"][@"番禺区"][0]);
        
        self.areaInfoDict = request[@"data"];
        
        [self.areaNameArray addObjectsFromArray:self.areaInfoDict.allKeys];
        
        [NSObject resolveDict:request[@"data"][@"番禺区"][0]];
        
        [self selectAreaToReloadDateModel:self.areaNameArray[0]];
        
        [self.addressButton setTitle:self.areaNameArray[0] forState:UIControlStateNormal];
        
        [QMUITips hideAllToastInView:self.view animated:YES];
        
        self.arealistView.areaNameArray = self.areaNameArray;

    } failure:^(NSError *error) {
        
    }];
}

/**
 选择区域刷新列表

 @param areaName 区域名
 */
- (void)selectAreaToReloadDateModel:(NSString *)areaName
{
    NSLog(@">>> %@",[self.areaInfoDict valueForKey:areaName]);
    
    NSArray *modelArr = [CinemaListModel mj_objectArrayWithKeyValuesArray:self.areaInfoDict[areaName]];
    
    [self.modelArray removeAllObjects];
    
    [self.modelArray addObjectsFromArray:modelArr];
    
    [self.tableView reloadData];
}


#pragma mark - tabelView delegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CinemaListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        
        cell = [CinemaListCell createFromXIB];
        
    }
    
    CinemaListModel *model = self.modelArray[indexPath.row];
    
    cell.model = model;
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
