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
#import "BoxOfficeCell.h"
#import "FilmStillCell.h"
#import "CustomNavigationController.h"
#import "AppDelegate.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "SDAutoLayout.h"
#import "ShotCommentController.h"
@interface MovieDetailController ()<UITableViewDelegate,UITableViewDataSource,DetailHeaderCellDelegate>
{
    CGFloat _textHeight;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MovieDetailInfoModel *headerInfoModel;
@property (nonatomic,strong) NSMutableArray *actorsList;//演员表
@property (nonatomic,strong) NSDictionary *mboxDict;//票房数据
@property (nonatomic,strong) NSArray *commentModelArray;//演员表
@property (nonatomic,strong) NSString *commentTotalCount; //评论总数

@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [QMUITips showLoadingInView:self.view];

    [self loadMovieDetailWithMovieID:self.movieId complete:^{
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableView.separatorColor = RGB(216, 216, 216);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.estimatedRowHeight = 110;
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        [self.view addSubview:self.tableView];
        [QMUITips hideAllToastInView:self.view animated:YES];

    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self forceOrientationPortrait];
}

- (void)loadMovieDetailWithMovieID:(NSString *)movieId complete:(void(^)())complete
{
    //头部信息
    [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_DETAIL(movieId) success:^(id request) {
        
//        [NSObject resolveDict:request[@"data"][@"movie"]];
        
        self.headerInfoModel = [MovieDetailInfoModel mj_objectWithKeyValues:request[@"data"][@"movie"]];
        //演员信息
        
        [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_PERFORMER(movieId) success:^(id request) {
            
            self.actorsList= [NSMutableArray arrayWithObject:request[@"data"][@"directors"][0]];
            
            [self.actorsList addObjectsFromArray:request[@"data"][@"actors"]];
            //票房信息
            [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_BOXOFFICE(movieId) success:^(id request) {
                
                self.mboxDict = request[@"mbox"];

                //最新的三个评论信息
                [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_COMMENT_SHOT(movieId, @"0", @"1", @"0") success:^(id request) {

                    self.commentTotalCount = [request[@"total"]stringValue];
                    //热门评论
                    NSArray *hcmtsArray = request[@"hcmts"];
//

                    self.commentModelArray = [CommentModel mj_objectArrayWithKeyValuesArray:hcmtsArray];
//
                    if (complete) {
                        
                        complete();
                    }
                    
                } failure:nil];
                
           
            } failure:^(NSError *error) {
                
            }];
            
         
            
        } failure:^(NSError *error) {
            
        }];
        
    } failure:^(NSError *error) {
        
    }];
    
 
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section<4) {
        
        return 1;

    }else{
        
        if (self.commentModelArray.count>3) {
            
            return 3;
        }
        
        return self.commentModelArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailHeaderCellID = @"detailHeaderCellID";
    static NSString *performerCellID = @"performerCellID";
    static NSString *boxOfficeCellID = @"boxOfficeCellID";
    static NSString *filmStillCellID = @"filmStillCellID";
    static NSString *commentCellID = @"commentCellID";

    if (indexPath.section == 0) {
        
  
         
        DetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:detailHeaderCellID];
        
        if (!cell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"DetailHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:detailHeaderCellID];
            cell = [DetailHeaderCell createFromXIB];

        }
        
        cell.delegate = self;
        
        [cell setInfoDisplayWithDetailInfoModel:self.headerInfoModel];

        return cell;
        
    }else if (indexPath.section == 1){
        

        
        PerformerCell *cell = [tableView dequeueReusableCellWithIdentifier:performerCellID];
        
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"PerformerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:performerCellID];
            cell = [PerformerCell createFromXIB];
            

        }
        [cell addPerformerInfoWithDatas:self.actorsList];

        return cell;
        
    }else if (indexPath.section == 2){
   
        
        BoxOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:boxOfficeCellID];
        if (!cell) {
                 [tableView registerNib:[UINib nibWithNibName:@"BoxOfficeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:boxOfficeCellID];
            cell = [BoxOfficeCell createFromXIB];
            

        }
        [cell setInfoWithRequestDict:self.mboxDict];

        return cell;
    }else if (indexPath.section == 3){
        

        FilmStillCell *cell = [tableView dequeueReusableCellWithIdentifier:filmStillCellID];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"FilmStillCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:filmStillCellID];
            cell = [FilmStillCell createFromXIB];

        }
        
        NSMutableArray *photoArray = [NSMutableArray arrayWithArray:self.headerInfoModel.photos];
        [photoArray insertObject:self.headerInfoModel.videoImg atIndex:0];
        [cell setStagePhotoWithPhotos:photoArray];
        cell.mp4_Url = self.headerInfoModel.videourl;
        return cell;
    }else{
        
        [tableView setSeparatorInset:UIEdgeInsetsMake(0,43,0,0)];

        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:commentCellID];
            cell = [CommentCell createFromXIB];
            
        }
        
        cell.separatorLineColor = [UIColor clearColor];
        
        CommentModel *model = self.commentModelArray[indexPath.row];
        
        cell.commentModel = model;

        return cell;

    }
 
//    return nil;
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 110;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 330.0f+(_textHeight>0?_textHeight:0);

    }else if (indexPath.section == 1){
        
        return 188;
        
    }else if (indexPath.section == 2){
        
        return 100;
    }else if (indexPath.section == 3){
        
        return 145;
        
    }else{
        
        return UITableViewAutomaticDimension;
    }
    
//    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.01f;
    }else if (section == 4){
        
        return 44.0f;
    }
    
    return 10.0f;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 3) {
        
        return 10.0f;
    }else if (section == 4){
        
        return 44.0f;
    }
    
        return 0.01f;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = tableView.separatorColor;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2, 44)];
        label.textColor = [UIColor blackColor];
        label.text = @"观众评论";
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        [view addSubview:line];
        
        return view;
        
        
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        footView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:footView.bounds];
        [button setTitle:[NSString stringWithFormat:@"查看全部%@条观众评论",self.commentTotalCount] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreCommentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:CustomRedColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [footView addSubview:button];
        return footView;
    }
    
    return nil;
}


-(void)moreCommentButtonClick
{
    ShotCommentController *commentVC = [[ShotCommentController alloc]init];
    commentVC.movieId = _movieId;
    commentVC.allCommentCount = [_commentTotalCount integerValue];
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - DetailHeaderCell-Delegate
-(void)detailHeaderCell:(DetailHeaderCell *)headerCell readMoreClickWithTextHeight:(CGFloat)textHeight
{
    _textHeight = textHeight;
    
    [self.tableView reloadData];
    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
