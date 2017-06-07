//
//  CinemaDetailTopCell.h
//  MovieEye
//
//  Created by Rany on 2017/5/19.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNImageScrollView.h"
#import "CinemaMovieModel.h"
#import "CinemaDetailModel.h"
@class CinemaDetailTopCell;
@protocol  CinemaDetailTopCellDelegate <NSObject>

- (void)cinemaDetailTopCell:(CinemaDetailTopCell *)topCell didSelectMovieAtIndex:(NSInteger)index;

@end

@interface CinemaDetailTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imageScrollview;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *cinameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *verLabel;

@property(nonatomic, strong) CinemaDetailModel *detailModel;

@property(nonatomic, weak) id <CinemaDetailTopCellDelegate>delegate;

@end
