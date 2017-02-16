//
//  BoxOfficeCell.m
//  MovieEye
//
//  Created by Rany on 2017/2/16.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "BoxOfficeCell.h"

@implementation BoxOfficeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setInfoWithRequestDict:(id)dict
{
    self.firstWeekBoxLabel.text = [dict[@"firstWeekBox"]stringValue];
    
    self.lastDayRankLabel.text = [dict[@"lastDayRank"]stringValue];
    
    self.sumBoxLabel.text = [dict[@"sumBox"]stringValue];
}
@end
