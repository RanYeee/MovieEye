//
//  CinemaListCell.h
//  MovieEye
//
//  Created by Rany on 17/3/7.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaListModel.h"
#import "BaseTableViewCell.h"
@interface CinemaListCell :BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic ,strong) CinemaListModel *model;
@end
