//
//  MovieSearchController.m
//  MovieEye
//
//  Created by Rany on 17/2/10.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "MovieSearchController.h"
#import "HotSearchCell.h"
#import "HotSearchModel.h"
#import "SearchHistoryCell.h"

#define kHistorySearchArray @"kHistorySearchArray"

#define kkeyWordSaveNum  4 //搜索记录保存个数

@interface MovieSearchController ()<QMUITableViewDelegate,QMUITableViewDataSource,UISearchBarDelegate,SearchHistoryCellDelegate>
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;
@property (nonatomic,strong) QMUITableView *tableView;
@property (nonatomic,strong) NSMutableArray *hotSearchArray;
@property (nonatomic,strong) QMUISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *keywordArray;
@end

@implementation MovieSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[QMUITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    self.tableView.separatorColor = [UIColor clearColor];
    self.searchBar = [[QMUISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.searchBar.delegate = self;
    //    [self.searchBar becomeFirstResponder];
    self.tableView.tableHeaderView = self.searchBar;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirstResponse)];
    [self.tableView addGestureRecognizer:tapGesture];
    [self getHotSearchArray];
}

- (NSMutableArray *)hotSearchArray
{
    if (!_hotSearchArray) {
        
        _hotSearchArray = [NSMutableArray array];
    }
    
    return _hotSearchArray;
}

- (NSMutableArray *)keywordArray
{
    if (!_keywordArray) {
        
        NSArray *keyWordArray = [[NSUserDefaults standardUserDefaults]objectForKey:kHistorySearchArray];
        
        if (keyWordArray) {
            
            _keywordArray = [NSMutableArray arrayWithArray:keyWordArray];
            
        }else{
            
            _keywordArray = [NSMutableArray array];
        }
        
    }
    
    return _keywordArray;
}

- (void)resignFirstResponse
{
    [self.searchBar resignFirstResponder];
}

- (void)getHotSearchArray
{
    [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_SEARCH_HOTLIST success:^(id request) {
        
        
        for (NSDictionary *dict in request[@"data"]) {
            
            [self.hotSearchArray addObject:[HotSearchModel mj_objectWithKeyValues:dict]];
            
        }

        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

#pragma mark - searchBar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
 
    [searchBar resignFirstResponder];
    
    //保存搜索记录
    
    if (self.keywordArray.count<kkeyWordSaveNum) {
        
        [self.keywordArray insertObject:searchBar.text atIndex:0];
        
        [[NSUserDefaults standardUserDefaults]setObject:self.keywordArray forKey:kHistorySearchArray];
        
        [[NSUserDefaults standardUserDefaults]synchronize];

    }
    
    NSString *apiString = API_MOVIE_SEARCH(@"10", searchBar.text);
        
    [[APIRequestManager shareInstance]getHTTPPath:apiString success:^(id request) {
        NSLog(@">>>>>>%@",request);
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - TableView delegate & Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.keywordArray.count>0) {
        
        return self.keywordArray.count +1;
    }
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = nil;
    
    if (self.keywordArray.count>0) {
        
        if (indexPath.row < self.keywordArray.count) {
            
            //历史搜索的cell
            
            SearchHistoryCell *historyCell = [SearchHistoryCell createFromXIB];
            
            historyCell.indexPath = indexPath;
            
            historyCell.delegate = self;
            
            historyCell.historyKeyLabel.text = self.keywordArray[indexPath.row];
            
            cell = historyCell;
            
        }else{
            
            cell = [self tableviewCell_CreateHotSearchCellAtIndexPath:indexPath];
        }
        
    }else{
        
        cell = [self tableviewCell_CreateHotSearchCellAtIndexPath:indexPath];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    return cell;
}

- (HotSearchCell *)tableviewCell_CreateHotSearchCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    HotSearchCell *cell = [[HotSearchCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    
    cell.hotSearchArray = self.hotSearchArray;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.keywordArray.count>0) {
    
        if (indexPath.row<self.keywordArray.count) {
            
            return 44;
            
        }else{
            
            return 160;
        }
    
    }
    
    return 160;
}

-(void)searchHistoryCell:(SearchHistoryCell *)cell deleteCellAtIndex:(NSIndexPath *)indexPath
{
    [self.keywordArray removeObjectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults]setObject:self.keywordArray forKey:kHistorySearchArray];
    
    [[NSUserDefaults standardUserDefaults]synchronize];

    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


@end
