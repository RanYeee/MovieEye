//
//  MovieListCell.h
//  MovieEye
//
//  Created by Rany on 2017/2/9.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bliiImageView;
@property (weak, nonatomic) IBOutlet QMUILabel *nameLabel;

@property (weak, nonatomic) IBOutlet QMUILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *_3dLabel;
@property (weak, nonatomic) IBOutlet UILabel *iMaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *starLabel;
@property (strong, nonatomic) IBOutlet UILabel *showInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

+(instancetype)createCell;

//创建占位cell
+(instancetype)createPlaceHolderCell;
@end
