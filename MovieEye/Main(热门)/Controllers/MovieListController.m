//
//  ViewController.m
//  MovieEye
//
//  Created by Rany on 2017/2/8.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "MovieListController.h"
#import "APIRequestManager.h"
#import "UIImageView+WebCache.h"
#import "MovieListCell.h"
#import "MovieInfoModel.h"
#import "MovieSearchController.h"
#import "MovieDetailController.h"
@interface MovieListController ()<QMUITableViewDelegate,QMUITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) QMUITableView *tableView;
@property (nonatomic,strong) NSMutableArray *movieListArray;
@end

@implementation MovieListController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门电影";
    self.tableView = [[QMUITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    QMUISearchBar *searchBar = [[QMUISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    [self.navigationController.navigationBar setBarTintColor:CustomRedColor];
    kStatusBarStyleLightContent;
    [self loadData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(NSMutableArray *)movieListArray
{
    if (!_movieListArray) {
        
        _movieListArray = [NSMutableArray array];
    }
    
    return _movieListArray;
}

#pragma mark - loadData
- (void)loadData
{
    [QMUITips showLoadingInView:self.view];

    
    [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_LIST(@"hot", @"0", @"100") success:^(id request) {
        

        NSArray *movies = request[@"data"][@"movies"];
        
        for (NSDictionary *dict in movies) {
            
            [self.movieListArray addObject:[MovieInfoModel mj_objectWithKeyValues:dict]];
            
        }
        
        [self.tableView reloadData];
        
        [QMUITips hideAllToastInView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@">>>>%@",error);
    }];
}

#pragma mark - searchBar delegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@">>>>>>searchBarShouldBeginEditing");
    MovieSearchController *searchVC = [[MovieSearchController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

#pragma mark - tableview Delegate&Datasouce


-(BOOL)shouldShowSearchBarInTableView:(QMUITableView *)tableView
{
    return YES;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.movieListArray.count > 0) {
        return self.movieListArray.count;

    }
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    
    MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        if (self.movieListArray.count>0) {
            cell = [MovieListCell createCell];

        }else{
            
            cell = [MovieListCell createPlaceHolderCell];
        }
        
    }
    
    if (self.movieListArray.count > 0) {
        
        MovieInfoModel *model = self.movieListArray[indexPath.row];
        
        cell.nameLabel.text = model.nm;
        cell.typeLabel.text = model.cat;
        cell.iMaxLabel.hidden = !model.imax;
        cell._3dLabel.text = model.is3d?@"3D":@"2D";
        cell.showInfoLabel.text = model.showInfo;
        cell.starLabel.text = [NSString stringWithFormat:@"主演:%@",model.star];
        cell.scoreLabel.textColor = model.sc>0?RGB(255, 153, 0):[UIColor lightGrayColor];
        //    cell.scoreLabel.text = model.sc>0?[NSString stringWithFormat:@"%.1f分",model.sc]:@"暂无评分";
        NSMutableAttributedString *attributedString_score = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f分",model.sc]];
        NSMutableAttributedString *attributedString_none = [[NSMutableAttributedString alloc] initWithString:@"暂未评分"];
        NSDictionary *attrsDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:9]};
        [attributedString_score addAttributes:attrsDictionary range:NSMakeRange(3, 1)];
        cell.scoreLabel.attributedText = model.sc>0?attributedString_score:attributedString_none;
        [cell.bliiImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieInfoModel *model = self.movieListArray[indexPath.row];
    
    MovieDetailController *detailVC = [[MovieDetailController alloc]init];
    
    detailVC.movieId = [NSString stringWithFormat:@"%d",model._id];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
