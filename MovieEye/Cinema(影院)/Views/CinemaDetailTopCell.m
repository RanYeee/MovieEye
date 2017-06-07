//
//  CinemaDetailTopCell.m
//  MovieEye
//
//  Created by Rany on 2017/5/19.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaDetailTopCell.h"
#import <Masonry/Masonry.h>

@interface CinemaDetailTopCell()<RNImageScrollViewDelegate>
{
    NSArray *_movieModelArray;
}
@property(nonatomic, strong) RNImageScrollView *scrollview;


@end

@implementation CinemaDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.scrollview = [[RNImageScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.imageScrollview.height)];
    
    self.scrollview.delegate = self;
    
    [self.imageScrollview addSubview:self.scrollview];

    self.separatorInset = UIEdgeInsetsMake(0, -30, 0, 0);

}

-(void)setDetailModel:(CinemaDetailModel *)detailModel
{
    if (detailModel == nil) {
        return;
    }
    
    _detailModel = detailModel;
    
    //设置电影海报
    self.scrollview.imageURLArray = [self imageURLArray];
    
    //设置其他电影院详情
    
    [self setDescription];
}



- (NSArray *)imageURLArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    _movieModelArray = [CinemaMovieModel mj_objectArrayWithKeyValuesArray:_detailModel.movies];
    
    for (CinemaMovieModel *model in _movieModelArray) {
        
        [array addObject:model.img];
    }
    
    return array;
}

- (void)setDescription
{
    self.cinameNameLabel.text = _detailModel.cinemaDetailModel[@"nm"];
    
    self.addressLable.text = _detailModel.cinemaDetailModel[@"addr"];
    
    
    
}

-(void)scrollViewDidEndScrollAtIndex:(NSInteger)index
{
    [self setMovieNameAtIndex:index];
    
    if (self.delegate) {
        
        [self.delegate cinemaDetailTopCell:self didSelectMovieAtIndex:index];
    }
}

-(void)setMovieNameAtIndex:(NSInteger )index
{
    
    CinemaMovieModel *currentModel = _movieModelArray[index];
    

     NSMutableAttributedString *attributedString_name_score = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %.1f分",currentModel.nm,currentModel.sc]];
    
    NSDictionary *attrsColorDictionary = @{NSForegroundColorAttributeName:RGB(255, 153, 0)};
    
    NSDictionary *attrsFontDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:9]};
    
     [attributedString_name_score addAttributes:attrsColorDictionary range:NSMakeRange(attributedString_name_score.length-4, 4)];
    
    
    [attributedString_name_score addAttributes:attrsFontDictionary range:NSMakeRange(attributedString_name_score.length-1, 1)];
    
    self.movieNameLabel.attributedText = attributedString_name_score;
    
    self.verLabel.text = currentModel.ver;

}

@end
