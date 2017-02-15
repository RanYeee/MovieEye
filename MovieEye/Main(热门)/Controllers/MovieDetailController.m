//
//  MovieDetailController.m
//  MovieEye
//
//  Created by Rany on 17/2/10.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "MovieDetailController.h"
#import "DetailHeaderCell.h"
#import "MovieDetailInfoModel.h"
#import "PerformerCell.h"
@interface MovieDetailController ()<UITableViewDelegate,UITableViewDataSource,DetailHeaderCellDelegate>
{
    CGFloat _textHeight;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MovieDetailInfoModel *headerInfoModel;
@property (nonatomic,strong) NSMutableArray *actorsList;//演员表
@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [QMUITips showLoadingInView:self.view];

    [self loadMovieDetailWithMovieID:self.movieId complete:^{

        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        [self.view addSubview:self.tableView];
        [QMUITips hideAllToastInView:self.view animated:YES];

    }];
    
}


- (void)loadMovieDetailWithMovieID:(NSString *)movieId complete:(void(^)())complete
{
    //头部信息
    [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_DETAIL(movieId) success:^(id request) {
        
        [NSObject resolveDict:request[@"data"][@"movie"]];
        
        self.headerInfoModel = [MovieDetailInfoModel mj_objectWithKeyValues:request[@"data"][@"movie"]];
        //演员信息
        
        [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_PERFORMER(movieId) success:^(id request) {
            
            self.actorsList= [NSMutableArray arrayWithObject:request[@"data"][@"directors"][0]];
            
            [self.actorsList addObjectsFromArray:request[@"data"][@"actors"]];
            
            
            if (complete) {
                
                complete();
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } failure:^(NSError *error) {
        
    }];
    
 
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DetailHeaderCell *cell = [DetailHeaderCell createFromXIB];
        
        [cell setInfoDisplayWithDetailInfoModel:self.headerInfoModel];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        return cell;
    }else if (indexPath.section == 1){
        
        PerformerCell *cell = [PerformerCell createFromXIB];
        [cell addPerformerInfoWithDatas:self.actorsList];
        return cell;
    }
 
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 330.0f+(_textHeight>0?_textHeight:0);

    }else if (indexPath.section == 1){
        
        return 188;
    }
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.01f;
    }
    
    return 10.0f;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.01f;
    }
    
    return 10.0f;
}

-(void)detailHeaderCell:(DetailHeaderCell *)headerCell readMoreClickWithTextHeight:(CGFloat)textHeight
{
    _textHeight = textHeight;
    
    [self.tableView reloadData];
}

@end
