//
//  CinemaDetailListCell.m
//  MovieEye
//
//  Created by Rany on 2017/5/22.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaDetailListCell.h"
#import "DatesSelectView.h"
@interface CinemaDetailListCell()

@property (weak, nonatomic) IBOutlet UIView *selectItemView;

@property(nonatomic, strong) DatesSelectView *selectView;

@end

@implementation CinemaDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectView = [[DatesSelectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.selectItemView.height)];
    
    
    
    [self.selectItemView addSubview:self.selectView];
}

-(void)setDetailModel:(CinemaDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    self.selectView.itemTitleArray = [self getDates];
}

- (NSArray *)getDates
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (NSDictionary *dict in _detailModel.Dates) {
        
        [tmpArray addObject:dict[@"text"]];
    }
    
    return tmpArray;
}

@end
