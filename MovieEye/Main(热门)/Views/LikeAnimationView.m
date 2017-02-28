//
//  LikeAnimationView.m
//  MovieEye
//
//  Created by Rany on 17/2/24.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "LikeAnimationView.h"

@implementation LikeAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI
{
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.textColor = CustomRedColor;
    self.textLabel.text = @"+1";
    self.textLabel.frame = self.bounds;
    [self addSubview:self.textLabel];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.alpha = 0.0f;
}

- (void)startAnimation
{
    self.textLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);

    [UIView animateWithDuration:0.5 animations:^{
        self.textLabel.alpha = 1.0f;
        CGRect tmpFrame = self.textLabel.frame;
        self.textLabel.font = [UIFont systemFontOfSize:26];
        tmpFrame.origin.y-=25;
        tmpFrame.size.width*=1.2;
        tmpFrame.size.height*=1.2;
        [self.textLabel setFrame:tmpFrame];
        self.textLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [self layoutIfNeeded];

    }completion:^(BOOL finished) {
        
        [self.textLabel removeFromSuperview];
        
        [self removeFromSuperview];
        
    }];
}

@end
