//
//  BoxOfficeCell.h
//  MovieEye
//
//  Created by Rany on 2017/2/16.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxOfficeCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lastDayRankLabel;//昨日票房排行
@property (weak, nonatomic) IBOutlet UILabel *firstWeekBoxLabel;//每周票房
@property (weak, nonatomic) IBOutlet UILabel *sumBoxLabel;//累计票房

-(void)setInfoWithRequestDict:(id)dict;

@end
