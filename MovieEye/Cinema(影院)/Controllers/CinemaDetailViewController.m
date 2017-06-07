//
//  CinemaDetailViewController.m
//  MovieEye
//
//  Created by Rany on 17/3/8.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaDetailViewController.h"
#import "MovieCollectionView.h"
#import "RNImageScrollView.h"
#import "CinemaMovieModel.h"
#import "CinemaDetailTopCell.h"
#import "CinemaDetailModel.h"
#import "CinemaDetailListCell.h"
#import "CinemaDetailApi.h"
@interface CinemaDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CinemaDetailTopCellDelegate>

@property(nonatomic, strong) RNImageScrollView *collectionView;

@property(nonatomic, strong) NSMutableArray *cinemaDetailModelArray;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) CinemaDetailModel *detailModel;

@end

@implementation CinemaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    self.view.backgroundColor = [UIColor whiteColor];

    [QMUITips showLoadingInView:self.view];
    
    CinemaDetailApi *detailApi = [[CinemaDetailApi alloc]initWithCinemaID:_cinemaID MovieID:@""];
    
    [detailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@">>>>>%@",request.responseJSONObject);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"error>>>>>%@",request.responseJSONObject);

    }];
//    
//    __weak __typeof(self)weakSelf = self;
//    
//    [self getCinemaDataWithMovieID:@"" complete:^(id req) {
//        
//        weakSelf.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
//        
//        weakSelf.tableView.delegate = self;
//        
//        weakSelf.tableView.dataSource = self;
//        
//        [weakSelf.view addSubview:weakSelf.tableView];
//        
//        [QMUITips hideAllToastInView:weakSelf.view animated:YES];
////
//    }];
//
}


-(NSMutableArray *)cinemaDetailModelArray
{
    if (!_cinemaDetailModelArray) {
        
        _cinemaDetailModelArray = [NSMutableArray array];
    }
    
    return _cinemaDetailModelArray;
}

- (void)getCinemaDataWithMovieID:(NSString *)movieId complete:(void(^)(id req))complete
{
    NSString *urlStr = API_CINEMA_DETAIL(_cinemaID, movieId);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",nil];

    //更改解析方式(默认为json解析，此次请求为网址源码)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置对证书的处理方式
    //接受无效证书，默认为NO
    manager.securityPolicy.allowInvalidCertificates = YES;
    //对域名的检测，默认为YES
    manager.securityPolicy.validatesDomainName = NO;
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
         NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        NSLog(@"success---%@",responseDict);
        
        NSDictionary *requestdict = responseDict[@"data"];

        CinemaDetailModel *model = [CinemaDetailModel mj_objectWithKeyValues:requestdict];

        _detailModel = model;

        if (complete) {

            complete(requestdict);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error---%@",error);
    }];
    
    

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

        return 265;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
 
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            static NSString *detailTopCellID = @"detailTopCellid";
            
            [tableView registerNib:[UINib nibWithNibName:@"CinemaDetailTopCell" bundle:nil] forCellReuseIdentifier:detailTopCellID];
            
            CinemaDetailTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"detailTopCellid"];
            
            topCell.delegate = self;
            
            if (!topCell) {
                
                topCell = [[NSBundle mainBundle]loadNibNamed:@"CinemaDetailTopCell" owner:nil options:nil][0];
                

            }
            
            topCell.detailModel = _detailModel;

            
            cell = topCell;
        }else{
            static NSString *listCellID = @"listCellID";
            
            [tableView registerNib:[UINib nibWithNibName:@"CinemaDetailListCell" bundle:nil] forCellReuseIdentifier:listCellID];
            
            CinemaDetailListCell *listCell = [tableView dequeueReusableCellWithIdentifier:listCellID];
            
            if (!listCell) {
                
                listCell = [[NSBundle mainBundle]loadNibNamed:@"CinemaDetailListCell" owner:nil options:nil][0];
                
            }
            
            listCell.detailModel = _detailModel;

            cell = listCell;
           
        }
        
    }else{
        
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.01f;
    }
    
    return 10.0f;
}

#pragma mark - topCellDelegate

-(void)cinemaDetailTopCell:(CinemaDetailTopCell *)topCell didSelectMovieAtIndex:(NSInteger)index
{
    
    NSString *movieID = _detailModel.movies[index][@"id"];
    
    __weak __typeof(self)weakSelf = self;
    
    [self getCinemaDataWithMovieID:movieID complete:^(id req) {
       
//        [NSObject resolveDict:req[@"data"]];
//        
//        NSDictionary *data = req[@"data"];
//        
//        CinemaDetailModel *model = [CinemaDetailModel mj_objectWithKeyValues:data];
//        
//        _detailModel = model;
        
        [weakSelf.tableView reloadData];
        
    }];
}
@end
