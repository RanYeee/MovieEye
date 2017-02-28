//
//  ShotCommentController.m
//  MovieEye
//
//  Created by Rany on 17/2/27.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "ShotCommentController.h"
#import "CommentTagCell.h"
#import "CommentModel.h"
#import "CommentCell.h"
#define kPageLimit @"10"  //每页个数
#define kTestArray @[@"全部",@"好评11234",@"差评1120",@"购票99877",@"认证作者12",@"同城980"]
static NSString *tagCellID = @"tagCellId";
static NSString *hcmtsCellID = @"hcmtsCellId";
@interface ShotCommentController ()<UITableViewDelegate,UITableViewDataSource,CommentTagCellDelegate>
{
    NSString *_currentTag;
    
    NSInteger _currentOffset;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <NSString *>*tagTitleArray;
@property (nonatomic,strong) NSArray *tagDataArray;
@property (nonatomic,strong) NSMutableArray *hcmtsArray;
@property (nonatomic,strong) NSMutableArray *cmtsArray;
@end

@implementation ShotCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"所有评论";
    [self loadDataWithMovieId:self.movieId Complete:^{
        
        
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        [self.view addSubview:self.tableView];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.tableView  registerClass:[CommentTagCell class] forCellReuseIdentifier:tagCellID];

    }];

    
    
}


- (NSMutableArray<NSString *> *)cmtsArray
{
    if (!_cmtsArray) {
        _cmtsArray = [NSMutableArray array];
        
    }
    
    return _cmtsArray;
}

- (NSMutableArray<NSString *> *)hcmtsArray
{
    if (!_hcmtsArray) {
        _hcmtsArray = [NSMutableArray array];
        
    }
    
    return _hcmtsArray;
}

- (NSMutableArray<NSString *> *)tagTitleArray
{
    if (!_tagTitleArray) {
        _tagTitleArray = [NSMutableArray array];
        
    }
    
    return _tagTitleArray;
}

//加载评论数据（翻页）

- (void)loadMoreCommentWithOffSet:(NSInteger)offset
                              Tag:(NSString *)tag
                         Complete:(void(^)(id comment))complete
{
    [QMUITips showLoadingInView:self.view];
    
    NSString *offsetString = [NSString stringWithFormat:@"%d",offset];
    
    [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_COMMENT_SHOT(_movieId, tag, kPageLimit,offsetString)
                                          success:^(id request) {
        
                                              [QMUITips hideAllToastInView:self.view animated:YES];
                                              
                                              if (complete) {
                                                  complete(request);
                                              }
    
                                          } failure:^(NSError *error) {
        
                                              [QMUITips hideAllToastInView:self.view animated:YES];

                                              [QMUITips showError:error.localizedFailureReason inView:self.view hideAfterDelay:1.5];
    
                                          }];
    
}

//加载基本数据

- (void)loadDataWithMovieId:(NSString *)movieId Complete:(void(^)())complete
{
    [[APIRequestManager shareInstance]getHTTPPath:API_MOVIE_COMMENT_TAG(movieId) success:^(id request) {
        
        self.tagDataArray = request[@"data"];
        
        [self.tagTitleArray addObject:@"全部"];
        
        for (NSDictionary *dict in self.tagDataArray) {
            
            NSString *string = [NSString stringWithFormat:@"%@(%@)",dict[@"tagName"],[dict[@"count"]stringValue]];
            
            [self.tagTitleArray addObject:string];
        }
        
        [self loadMoreCommentWithOffSet:1 Tag:@"0" Complete:^(id comment) {
           //加载所有热门评论
            
            [self.hcmtsArray addObjectsFromArray: [CommentModel mj_objectArrayWithKeyValuesArray:comment[@"hcmts"]]];

            [self.cmtsArray addObjectsFromArray: [CommentModel mj_objectArrayWithKeyValuesArray:comment[@"cmts"]]];

            if (complete) {
                
                complete();
            }
            
        }];
        
     
        
        
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - tabelView delegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([_currentTag integerValue]>0) {
        
        return 2;
    }
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
        
    }else{
        
        if ([_currentTag integerValue]>0) {
            
            return self.cmtsArray.count;

        }else{
            
            if (section == 1) {
                
                return self.hcmtsArray.count;

            }else{
                
                return self.cmtsArray.count;

            }
            
        }

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

  

    if (indexPath.section == 0) {
        
        CommentTagCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCellID];
        
        if (!cell) {
//            cell = [[CommentTagCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tagCellID];
        }
        
        cell.customTitleLabel.text = [NSString stringWithFormat:@"所有评论(%d)",self.allCommentCount];
        
        [cell createTagButtonWithTagArray:self.tagTitleArray];
        
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

        
    }else{
        
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:hcmtsCellID];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:hcmtsCellID];
            cell = [CommentCell createFromXIB];
            
        }
        CommentModel *model = nil;

        if ([_currentTag integerValue]>0) {
            
            model = self.cmtsArray[indexPath.row];

        }else{
            
            if (indexPath.section == 1) {
                
                model = self.hcmtsArray[indexPath.row];
                
            }else{
                
                model = self.cmtsArray[indexPath.row];
                
            }

            
        }
        
        cell.commentModel = model;

        
        return cell;

        
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return [CommentTagCell rowHeightWithTagArray:self.tagTitleArray]+44;

    }
    
    return UITableViewAutomaticDimension;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0.01;
        
    }
    return 25;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 110;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 25);
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-8, 25)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor darkGrayColor];
    
    if ([_currentTag integerValue]>0) {
        
        label.text = @"最新评论";

    }else{
        
        switch (section) {
            case 1:
                label.text = @"热门评论";
            break;
            case 2:
                label.text = @"最新评论";
            break;
            default:
            break;
        }
  
    }
    
    [view addSubview:label];
    
    if (section == 0) {
        
        return nil;
    }
    
    return view;
    
}

#pragma mark - commentTagCell- Delegate

-(void)commentTagCell:(CommentTagCell *)cell didClickTagAtIndex:(NSInteger)index
{
    if (index == 0) {
        
        _currentTag = @"0";
        //加载全部评论
        [self loadMoreCommentWithOffSet:10 Tag:@"0" Complete:^(id comment) {
           
            //重新加载热门评论
            [self.hcmtsArray removeAllObjects];
            
            [self.hcmtsArray addObjectsFromArray:[CommentModel mj_objectArrayWithKeyValuesArray:comment[@"hcmts"]]];
            
            
            //重新加载组最评论
            [self.cmtsArray removeAllObjects];

            [self.cmtsArray addObjectsFromArray: [CommentModel mj_objectArrayWithKeyValuesArray:comment[@"cmts"]]];

            //重置offset
            _currentOffset = 0;
            
            //刷新tableview
            
            [self.tableView reloadData];
            
        }];
        
    }else{
        //筛选(这里只显示最新评论)
        NSString *tagNum = [self.tagDataArray[index-1][@"tag"]stringValue];
        
        _currentTag = tagNum;
        
        [self loadMoreCommentWithOffSet:10 Tag:tagNum Complete:^(id comment) {
          
            
            //重新加载组最评论
            [self.cmtsArray removeAllObjects];
            
            [self.cmtsArray addObjectsFromArray: [CommentModel mj_objectArrayWithKeyValuesArray:comment[@"cmts"]]];
            
            //重置offset
            _currentOffset = 0;
            
            //刷新tableview
            
            [self.tableView reloadData];

            
        }];

        NSLog(@">>>>>>tagNum = %@",tagNum);
    }
  
}

@end
