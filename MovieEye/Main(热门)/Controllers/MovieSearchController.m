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
#import "MovieInfoModel.h"
#import "MovieListCell.h"
#import "SearchResultModel.h"
#import "MovieDetailController.h"
#define kHistorySearchArray @"kHistorySearchArray"

#define kkeyWordSaveNum  4 //搜索记录保存个数

@interface MovieSearchController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SearchHistoryCellDelegate,CommentTagCellDelegate,UIGestureRecognizerDelegate>
{
    BOOL _isInSearch; //是否在搜索过程中
}
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *hotSearchArray;
@property (nonatomic,strong) NSMutableArray <NSString *>*hotSearchNameArray;
@property (nonatomic,strong) NSMutableArray <SearchResultModel *>*searchResultArray;

@property (nonatomic,strong) QMUISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *keywordArray;

@property (nonatomic, assign) NSInteger inputCount;     //用户输入次数，用来控制延迟搜索请求

@end

@implementation MovieSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    self.tableView.separatorColor = [UIColor clearColor];
    self.searchBar = [[QMUISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    //    [self.searchBar becomeFirstResponder];
    self.tableView.tableHeaderView = self.searchBar;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirstResponse)];
    tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
    [self getHotSearchArray];
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSArray *keyWordArray = [[NSUserDefaults standardUserDefaults]objectForKey:kHistorySearchArray];
    
    if (keyWordArray) {
        
        [self.keywordArray addObjectsFromArray:keyWordArray];
        
    }
    
}

- (NSMutableArray *)hotSearchArray
{
    if (!_hotSearchArray) {
        
        _hotSearchArray = [NSMutableArray array];
    }
    
    return _hotSearchArray;
}

-(NSMutableArray<SearchResultModel *> *)searchResultArray
{
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
        
    }
    
    return _searchResultArray;
}

-(NSMutableArray<NSString *> *)hotSearchNameArray
{
    if (!_hotSearchNameArray) {
        
        _hotSearchNameArray = [NSMutableArray array];
        
    }
    
    return _hotSearchNameArray;
}

- (NSMutableArray *)keywordArray
{
    if (!_keywordArray) {
     
        
        _keywordArray = [NSMutableArray array];
        
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
            
            [self.hotSearchArray addObject:[MovieInfoModel mj_objectWithKeyValues:dict]];
            
            [self.hotSearchNameArray addObject:dict[@"nm"]];
        }

        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

-(void)searchWithKeyWord:(NSString *)keyWord
{
    NSString *apiString = API_MOVIE_SEARCH(@"10", keyWord);
    
    
    [[APIRequestManager shareInstance]getHTTPPath:apiString success:^(id request) {
        
        _isInSearch = YES;
        
        NSArray *listArray = request[@"data"];
        
        for (int i = 0; i<[listArray count]; i++) {
            
            NSInteger listType = [listArray[i][@"type"]integerValue];
            
            if (listType == 0) {
                //电影信息
                NSArray *list = listArray[i][@"list"];
                NSLog(@"datas = %@",list);
                [self.searchResultArray removeAllObjects];
                
                [self.searchResultArray addObjectsFromArray:[SearchResultModel mj_objectArrayWithKeyValuesArray:list]];
                
                [self.tableView reloadData];
                
                [self.searchBar resignFirstResponder];
                
                //保存搜索记录
                
                if (self.keywordArray.count<kkeyWordSaveNum) {
                    
                    if (![self.keywordArray containsObject:self.searchBar.text]) {
                        
                        [self.keywordArray insertObject:self.searchBar.text atIndex:0];
                        
                        [[NSUserDefaults standardUserDefaults]setObject:self.keywordArray forKey:kHistorySearchArray];
                        
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
           
                    
                }
                
                
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];

}

//搜索
- (void)searchWithInputCount:(NSNumber *)inputCount{
    

    
    
    if (self.inputCount == [inputCount integerValue]) {
        
 
        if(isEmptyString(self.searchBar.text)){
            
            return;
        }
        
      
        [self searchWithKeyWord:self.searchBar.text];
    }
    
    
}

#pragma mark - searchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    self.inputCount ++;
    
    if (searchText.length == 0) {
        _isInSearch = NO;
        [self.searchResultArray removeAllObjects];
        [self.tableView reloadData];
        
    }
    
    [self performSelector:@selector(searchWithInputCount:) withObject:@(self.inputCount) afterDelay:1.0f];

    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


#pragma mark - TableView delegate & Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchResultArray.count>0) {
        
        return self.searchResultArray.count;
        
    }else{
        
        if (self.keywordArray.count>0) {
            
            return self.keywordArray.count +1;
            
        }else{
            
            return 1;

        }
    }
    

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (_isInSearch) {
        //正在搜索
        MovieListCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieListCellID"];
        
        if (!movieCell) {
           

            movieCell = [MovieListCell createSearchResultCell];

        }
        
        
        SearchResultModel *model = (SearchResultModel *)self.searchResultArray[indexPath.row];

        movieCell.searchResultModel = model;
        
        return movieCell;
        
    }else{
        
        if (self.keywordArray.count>0) {
            
            if (indexPath.row == self.keywordArray.count) {
                
                return [self tableviewCell_CreateHotSearchCellWithTableView:tableView AtIndexPath:indexPath];

            }else{
                //历史搜索的cell
                
                SearchHistoryCell *historyCell = [SearchHistoryCell createFromXIB];
                
                historyCell.indexPath = indexPath;
                
                historyCell.delegate = self;
                
                historyCell.historyKeyLabel.text = self.keywordArray[indexPath.row];
                
                return  historyCell;

                
            }
            

        }else{
            
            return  [self tableviewCell_CreateHotSearchCellWithTableView:tableView AtIndexPath:indexPath];
            
        }
        

        
    }
    


}

- (HotSearchCell *)tableviewCell_CreateHotSearchCellWithTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath
{
    
    HotSearchCell *cell = [[HotSearchCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HotSearchCellId"];
    
//    if (!cell) {
    
//    }
    cell.delegate = self;
    
    cell.customTitleLabel.text = @"热门搜索";
    
    cell.currentSelectIndex = -1;
    
    [cell createTagButtonWithTagArray:self.hotSearchNameArray];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isInSearch) {
        
        return 120;
        
    }else{
        
        if (self.keywordArray.count>0) {
            
            if (indexPath.row<self.keywordArray.count) {
                
                return 44;
                
            }else{
                
                return [HotSearchCell rowHeightWithTagArray:self.hotSearchNameArray]+88;
            }
            
        }else{
            
            return [HotSearchCell rowHeightWithTagArray:self.hotSearchNameArray]+88;

        }
        
    }
    

   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isInSearch) {
        
        SearchResultModel *model = self.searchResultArray[indexPath.row];
        
        [self pushToDetailVCWithMovieId:[NSString stringWithFormat:@"%d",model._id]];

    }else{
        
        if (self.keywordArray.count>0 && indexPath.row < self.keywordArray.count) {
            
            [self.searchBar resignFirstResponder];
            
            [self searchWithKeyWord:self.keywordArray[indexPath.row]];
            
            self.searchBar.text = self.keywordArray[indexPath.row];
            
        }else{
            
            return;
        }
        
    }
}


-(void)searchHistoryCell:(SearchHistoryCell *)cell deleteCellAtIndex:(NSIndexPath *)indexPath
{


    [self.keywordArray removeObjectAtIndex:indexPath.row];
    NSLog(@">>>keywordArray = %@",self.keywordArray);

    
    
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [[NSUserDefaults standardUserDefaults]setObject:self.keywordArray forKey:kHistorySearchArray];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - TagClickAction

-(void)commentTagCell:(CommentTagCell *)cell didClickTagAtIndex:(NSInteger)index
{
    MovieInfoModel *model = self.hotSearchArray[index];
    
    [self pushToDetailVCWithMovieId:[NSString stringWithFormat:@"%d",model._id]];
    
}

#pragma mark - 

- (void)pushToDetailVCWithMovieId:(NSString *)movieId
{
    MovieDetailController *detailVC = [[MovieDetailController alloc]init];
    
    detailVC.movieId = movieId;
    
    [self.navigationController pushViewController:detailVC animated:YES];

}



@end
