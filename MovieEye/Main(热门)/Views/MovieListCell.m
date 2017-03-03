//
//  MovieListCell.m
//  MovieEye
//
//  Created by Rany on 2017/2/9.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "MovieListCell.h"

@implementation MovieListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)createCell
{
    return [[NSBundle mainBundle]loadNibNamed:@"MovieListCell" owner:self options:nil][0];
}

+(instancetype)createPlaceHolderCell
{
    return [[NSBundle mainBundle]loadNibNamed:@"MovieListCell" owner:self options:nil][1];
}

+(instancetype)createSearchResultCell
{
    return [[NSBundle mainBundle]loadNibNamed:@"MovieListCell" owner:self options:nil][2];

}

-(void)setSearchResultModel:(SearchResultModel *)searchResultModel
{
    _searchResultModel = searchResultModel;
    self.nameLabel.text = searchResultModel.nm;
    self.typeLabel.text = searchResultModel.cat;
    self.iMaxLabel.hidden = YES;
    if (isEmptyString(searchResultModel.ver)) {
        
        self._3dLabel.hidden = YES;
    }
    self._3dLabel.text = searchResultModel.ver;
    self.showInfoLabel.text = searchResultModel.pubDesc;
    self.starLabel.hidden = YES;
    self.scoreLabel.textColor = searchResultModel.sc>0?RGB(255, 153, 0):[UIColor lightGrayColor];
    //    self.scoreLabel.text = model.sc>0?[NSString stringWithFormat:@"%.1f分",model.sc]:@"暂无评分";
    NSMutableAttributedString *attributedString_score = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f分",searchResultModel.sc]];
    NSMutableAttributedString *attributedString_none = [[NSMutableAttributedString alloc] initWithString:@"暂未评分"];
    NSDictionary *attrsDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:9]};
    [attributedString_score addAttributes:attrsDictionary range:NSMakeRange(3, 1)];
    self.scoreLabel.attributedText = searchResultModel.sc>0?attributedString_score:attributedString_none;
    NSString *imgURLString = [searchResultModel.img stringByReplacingOccurrencesOfString:@"w.h" withString:@"156.220"];
    [self.bliiImageView sd_setImageWithURL:[NSURL URLWithString:imgURLString]];

}
-(void)setModel:(MovieInfoModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.nm;
    self.typeLabel.text = model.cat;
    self.iMaxLabel.hidden = !model.imax;
    self._3dLabel.text = model.is3d?@"3D":@"2D";
    self.showInfoLabel.text = model.showInfo;
    self.starLabel.text = [NSString stringWithFormat:@"主演:%@",model.star];
    self.scoreLabel.textColor = model.sc>0?RGB(255, 153, 0):[UIColor lightGrayColor];
    //    self.scoreLabel.text = model.sc>0?[NSString stringWithFormat:@"%.1f分",model.sc]:@"暂无评分";
    NSMutableAttributedString *attributedString_score = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f分",model.sc]];
    NSMutableAttributedString *attributedString_none = [[NSMutableAttributedString alloc] initWithString:@"暂未评分"];
    NSDictionary *attrsDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:9]};
    [attributedString_score addAttributes:attrsDictionary range:NSMakeRange(3, 1)];
    self.scoreLabel.attributedText = model.sc>0?attributedString_score:attributedString_none;
    [self.bliiImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];

}
@end
