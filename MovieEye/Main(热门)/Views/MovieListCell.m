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
