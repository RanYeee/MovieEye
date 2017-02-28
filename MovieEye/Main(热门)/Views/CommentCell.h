//
//  CommentCell.h
//  MovieEye
//
//  Created by Rany on 17/2/23.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "HCSStarRatingView.h"
@interface CommentCell : BaseTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIView *separatorLine;

@property (nonatomic ,strong) UIColor *separatorLineColor;

@property (nonatomic ,strong) CommentModel *commentModel;



@end
