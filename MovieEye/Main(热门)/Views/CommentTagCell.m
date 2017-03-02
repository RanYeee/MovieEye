//
//  CommentTagCell.m
//  MovieEye
//
//  Created by Rany on 17/2/27.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CommentTagCell.h"
#import <Masonry/Masonry.h>

#define kTitleLabelH 44
#define kButtonH 30
#define kSpacing 10

@interface CommentTagCell()

{

    CGFloat _tmpWidth;
    
    NSInteger _row;
    
    UIButton *_currentSelectButton;
    
    NSArray *_tags;
}

@end

@implementation CommentTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI
{
    self.customTitleLabel = [[UILabel alloc]init ];
    self.customTitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.customTitleLabel];
  
    self.customTitleLabel.frame = CGRectMake(kSpacing, 0, SCREEN_WIDTH,kTitleLabelH);
    
    
}

- (void)createTagButtonWithTagArray:(NSArray *)tags
{
    if (_tags) {
        
        return;
    }
    
    _tags = tags;
    
    [tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        //计算文字的size
        NSDictionary *attrs = @{NSFontAttributeName :[UIFont boldSystemFontOfSize:15]};
        CGSize size=[obj sizeWithAttributes:attrs];

        //创建button
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [tagButton setTitle:obj forState:UIControlStateNormal];
        [tagButton setTitleColor:CustomRedColor forState:UIControlStateNormal];
        [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [tagButton setBackgroundImage:[UIImage qmui_imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [tagButton setBackgroundImage:[UIImage qmui_imageWithColor:CustomRedColor] forState:UIControlStateSelected];
        
        if (_buttonStyle == TagCellDefaultButtonStyle) {
         //
            if (idx == self.currentSelectIndex) {
                
                tagButton.selected = YES;
                _currentSelectButton = tagButton;

            }
            
        }else{
            
            if (idx == 0) {
                //默认第一个选中
                tagButton.selected = YES;
                _currentSelectButton = tagButton;
            }
            
        }
        tagButton.tag = idx;
        [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        tagButton.layer.borderColor = CustomRedColor.CGColor;
        tagButton.layer.borderWidth = 0.5;
        [self.contentView addSubview:tagButton];
        
        
        if (_tmpWidth+size.width+kSpacing>=SCREEN_WIDTH) {
            
            _tmpWidth = 0;
            _row+=1;
        }
        
        [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.size.mas_equalTo(CGSizeMake(size.width, kButtonH));
            make.top.equalTo(self.customTitleLabel.mas_bottom).offset(_row*(kSpacing+kButtonH));
            make.left.equalTo(self.contentView.mas_left).offset(_tmpWidth+kSpacing);
            
            
        }];
        
        _tmpWidth += size.width+kSpacing;

  
    }];
}

+ (CGFloat)rowHeightWithTagArray:(NSArray *)tagArray
{
    NSInteger rowCount = 1;
    CGFloat tmpW = 0;
    for (int i = 0; i<tagArray.count; i++) {
        
        //计算文字的size
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
        CGSize size=[tagArray[i] sizeWithAttributes:attrs];
        tmpW+=kSpacing+size.width;

        if (tmpW>=SCREEN_WIDTH){
            rowCount+=1;
            tmpW = 0;
        }

    }

    NSLog(@"rowCount>>> %d",rowCount);
    
    if (IS_IPHONE_5) {
        
        if (rowCount>2) {
            
            rowCount+=1;
        }
        
    }else if (IS_IPHONE_6 || IS_IPHONE_PLUS){
        
        if (rowCount>3) {
            
            rowCount+=1;
        }
    }
   
    
    return rowCount*(kButtonH+kSpacing);
    
    
}

- (void)tagButtonClick:(UIButton *)sender
{
    if (_currentSelectButton == sender) {
        
        return;
    }
    
    _currentSelectButton.selected = !_currentSelectButton.isSelected;
    
    sender.selected = !sender.isSelected;
    
    if (self.delegate) {
 
        [self.delegate commentTagCell:self didClickTagAtIndex:sender.tag];
    }
    
    _currentSelectButton = sender;

}

@end
