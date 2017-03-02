//
//  CommentTagCell.h
//  MovieEye
//
//  Created by Rany on 17/2/27.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentTagCell;
@protocol CommentTagCellDelegate <NSObject>

- (void)commentTagCell:(CommentTagCell *)cell didClickTagAtIndex:(NSInteger)index;

@end

typedef enum : NSUInteger {
    TagCellDefaultButtonStyle,
    TagCellSelectedButtonStyle
} TagCellButtonStyle;

@interface CommentTagCell : UITableViewCell


/**
 根据数组个数计算cell高度

 @param tagArray 标签数组
 @return cell高度
 */
+ (CGFloat)rowHeightWithTagArray:(NSArray *)tagArray;

- (void)createTagButtonWithTagArray:(NSArray *)tags;


@property (nonatomic ,strong) UILabel *customTitleLabel;

@property (nonatomic ,assign) NSInteger currentSelectIndex;

@property (nonatomic ,assign) TagCellButtonStyle buttonStyle;

@property (nonatomic ,weak) id <CommentTagCellDelegate> delegate;

@end
