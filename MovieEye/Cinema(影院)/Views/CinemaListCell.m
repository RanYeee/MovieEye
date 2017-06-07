//
//  CinemaListCell.m
//  MovieEye
//
//  Created by Rany on 17/3/7.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaListCell.h"

@implementation CinemaListCell

- (void)awakeFromNib {
    [super awakeFromNib];



}


-(void)setModel:(CinemaListModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.nm;
    self.addressLabel.text = model.addr;
     NSMutableAttributedString *attributedString_price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d元起",model.sellPrice]];
    NSDictionary *attrsDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    [attributedString_price addAttributes:attrsDictionary range:NSMakeRange(attributedString_price.length-2, 2)];
    self.priceLabel.attributedText = attributedString_price;
}

@end
