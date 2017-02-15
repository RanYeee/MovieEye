//
//  DetailHeaderCell.h
//  MovieEye
//
//  Created by Rany on 17/2/13.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "MovieDetailInfoModel.h"
@class DetailHeaderCell;
@protocol DetailHeaderCellDelegate <NSObject>

- (void)detailHeaderCell:(DetailHeaderCell*)headerCell readMoreClickWithTextHeight:(CGFloat)textHeight;

@end

@interface DetailHeaderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (strong, nonatomic) IBOutlet UIImageView *movieImageView;

@property (strong, nonatomic) IBOutlet UILabel *nmLabel;//中文名
@property (strong, nonatomic) IBOutlet UILabel *enmLabel;//英文名
@property (strong, nonatomic) IBOutlet UILabel *scLabel;//评分
@property (strong, nonatomic) IBOutlet UILabel *snumLabel;//评论人数
@property (weak, nonatomic) IBOutlet UILabel *catLabel; //电影类型
@property (strong, nonatomic) IBOutlet UILabel *_3dLabel;//3dLabel

@property (strong, nonatomic) IBOutlet UILabel *wishLabel;

@property (weak, nonatomic) IBOutlet UILabel *imaxLabel; //imaxLabel
@property (strong, nonatomic) IBOutlet UILabel *durLabel; //影片播放时间
@property (strong, nonatomic) IBOutlet UILabel *frtLabel;//上映日期
@property (strong, nonatomic) IBOutlet QMUITextView*draTextView;

@property (nonatomic ,strong) MovieDetailInfoModel *infoModel;

@property (nonatomic ,weak) id <DetailHeaderCellDelegate> delegate;

+ (instancetype)createFromXIB;

- (void)setInfoDisplayWithDetailInfoModel:(MovieDetailInfoModel *)model;


@end
