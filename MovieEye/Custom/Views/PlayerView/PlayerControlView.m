//
//  PlayerControlView.m
//  MovieEye
//
//  Created by Rany on 17/2/21.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "PlayerControlView.h"
#import <Masonry/Masonry.h>


@interface PlayerControlView()

//缓冲进度条
@property (nonatomic,strong) UIProgressView *bufferProgressView;

//全屏按钮
@property (nonatomic,strong) UIButton *fullScreenButton;

//播放进度条
@property (nonatomic,strong) UISlider *progressSlider;


@end

@implementation PlayerControlView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    
    //初始时间
    self.trackingTimeLabel=[[UILabel alloc]init];
    self.trackingTimeLabel.text=@"00:00";
    self.trackingTimeLabel.textColor=[UIColor whiteColor];
    self.trackingTimeLabel.font=[UIFont systemFontOfSize:13];
    [self addSubview:self.trackingTimeLabel];
    [self.trackingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(40.0f);
        make.left.equalTo(self.mas_left).offset(padding);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        
    }];


    //全屏按钮
    self.fullScreenButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"full_screen"] forState:UIControlStateNormal];
    [self.fullScreenButton addTarget:self action:@selector(scallingChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.fullScreenButton];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(controlHeight, controlHeight));
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    //最大时间
    self.totalTimeLabel=[[UILabel alloc]init];
    self.totalTimeLabel.text = @"10:10";
    self.totalTimeLabel.textColor=[UIColor whiteColor];
    self.totalTimeLabel.font=[UIFont systemFontOfSize:13];
    [self addSubview:self.totalTimeLabel];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(self.trackingTimeLabel);
        make.right.equalTo(self.fullScreenButton.mas_left);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        
    }];

    //进度条
    self.progressSlider=[[UISlider alloc]init];
    [self.progressSlider addTarget:self action:@selector(progressValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.progressSlider.minimumTrackTintColor=[UIColor redColor];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackTintColor:[UIColor clearColor]];
    self.progressSlider.value=0;
    [self addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.trackingTimeLabel.mas_right);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-5);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        
    }];
    
    
    //缓冲进度条
    self.bufferProgressView=[[UIProgressView alloc]init];
    self.bufferProgressView.progressTintColor=[UIColor whiteColor];
    self.bufferProgressView.trackTintColor=[UIColor lightGrayColor];
    [self insertSubview:self.bufferProgressView belowSubview:self.progressSlider];
    [self.bufferProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.progressSlider);
        make.left.right.mas_equalTo(self.progressSlider);
        make.height.mas_equalTo(@1);
        
        
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}
-(void)progressValueChanged:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(sendCurrentValueToPlayer:)]) {
        [self.delegate sendCurrentValueToPlayer:self.progressSlider.value];
    }
}

-(void)setMinValue:(CGFloat)minValue{
    self.progressSlider.minimumValue=minValue;
}
-(void)setMaxValue:(CGFloat)maxValue{
    self.progressSlider.maximumValue=maxValue;
}
-(void)setCurrentValue:(CGFloat)currentValue{
    self.progressSlider.value=currentValue;
}
-(void)setBufferValue:(CGFloat)bufferValue{
    self.bufferProgressView.progress=bufferValue;
}


- (void)scallingChange:(UIButton *)button
{
    button.selected=!button.selected;
    if (button.selected) {
        self.scalling=PlayerControlScallingLarge;
    }else{
        self.scalling=PlayerControlScallingNormal;
    }
}
@end
