//
//  HotSearchCell.m
//  MovieEye
//
//  Created by Rany on 17/2/10.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "HotSearchCell.h"
#define kShowItemsNum 6 //显示热门搜索的item个数

@implementation HotSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 25)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor darkGrayColor];
        title.text = @"热门搜索";
        [self.contentView addSubview:title];
        //init floatlayoutView
        self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
        self.floatLayoutView.padding = UIEdgeInsetsMake(8, 8, 8, 8);
        self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
//        self.floatLayoutView.layer.borderWidth = PixelOne;
//        self.floatLayoutView.layer.borderColor = UIColorSeparator.CGColor;
        
        [self.contentView addSubview:self.floatLayoutView];
        
       
        
    }
    return self;
}

-(void)setHotSearchArray:(NSArray *)hotSearchArray
{
    [hotSearchArray enumerateObjectsUsingBlock:^(HotSearchModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (idx<kShowItemsNum) {
            
            QMUIGhostButton *button = [[QMUIGhostButton alloc] initWithGhostType:QMUIGhostButtonColorGray];
            [button setTitle:model.nm forState:UIControlStateNormal];
            button.titleLabel.font = UIFontMake(14);
            button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
            NSLog(@">>>>>>buttonWidth = %f",button.width);
            [self.floatLayoutView addSubview:button];
        }
        
        

    }];


}

-(void)layoutIfNeeded
{
    UIEdgeInsets padding = UIEdgeInsetsMake(35, 10, 10, 10);
    CGFloat contentWidth = CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    CGSize floatLayoutViewSize = [self.floatLayoutView sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    self.floatLayoutView.frame = CGRectMake(padding.left, padding.top, contentWidth, floatLayoutViewSize.height);
}

@end
