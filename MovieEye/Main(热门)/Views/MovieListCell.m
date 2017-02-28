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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
