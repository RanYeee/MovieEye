//
//  CommentCell.m
//  MovieEye
//
//  Created by Rany on 17/2/23.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CommentCell.h"
#import "UIImage+WebP.h"
#import "LikeAnimationView.h"
#import <DateTools/DateTools.h>
@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.height/2;
    
    self.separatorLine.backgroundColor = [QMUIConfigurationManager sharedInstance].tableViewSeparatorColor;
    
//    self.separatorLine.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCommentModel:(CommentModel *)commentModel
{
    _commentModel = commentModel;
    
    self.contentLabel.text = commentModel.content;
    
    self.userNameLabel.text = commentModel.nick;
    
    self.starView.value = commentModel.score/1.0f;
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",commentModel.approve] forState:UIControlStateNormal];
    
    NSDate *dateTime = [NSDate dateWithString:commentModel.time formatString:@"yyyy-MM-dd hh:mm"];
    
    NSString *timeStr = [NSDate timeAgoSinceDate:dateTime];
    
    self.timeLabel.text = timeStr;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.avatarurl]];
    
}
- (IBAction)likeButtonClick:(UIButton *)sender {
    
    if (sender.isSelected) {
        
        [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [sender setImage:IMAGE(@"likeUp") forState:UIControlStateNormal];
        
        NSInteger currentApprove = [sender.currentTitle integerValue]-1;
        
        [sender setTitle:[NSString stringWithFormat:@"%d",currentApprove] forState:UIControlStateNormal];

        
    }else{
        
        LikeAnimationView *likeView = [[LikeAnimationView alloc]initWithFrame:self.likeButton.frame];
        [self addSubview:likeView];
        [likeView startAnimation];

        [sender setTitleColor:CustomRedColor forState:UIControlStateNormal];

        [sender setImage:IMAGE(@"likeUp_hightLight") forState:UIControlStateNormal];
        
        NSInteger currentApprove = [sender.currentTitle integerValue]+1;
        
        [sender setTitle:[NSString stringWithFormat:@"%d",currentApprove] forState:UIControlStateNormal];

    }
    
    sender.selected = !sender.isSelected;
    
    
    
}


-(void)setSeparatorLineColor:(UIColor *)separatorLineColor
{
    _separatorLineColor = separatorLineColor;
    
    self.separatorLine.backgroundColor = separatorLineColor;
}

@end
