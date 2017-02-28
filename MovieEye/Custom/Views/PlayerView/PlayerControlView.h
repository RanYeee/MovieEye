//
//  PlayerControlView.h
//  MovieEye
//
//  Created by Rany on 17/2/21.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
//控制器条高度
static const NSInteger controlHeight=40;

static const CGFloat padding=10.f;

@protocol PlayerControlDelegate <NSObject>

- (void)sendCurrentValueToPlayer:(CGFloat)value;

@end

typedef NS_ENUM(NSInteger,PlayerControlScalling) {
    PlayerControlScallingNormal,
    PlayerControlScallingLarge,//全屏
};

@interface PlayerControlView : UIView
//进度条最小值
@property (nonatomic,assign) CGFloat minValue;
//进度条最大值
@property (nonatomic,assign) CGFloat maxValue;
//当前值
@property (nonatomic,assign) CGFloat currentValue;
//缓冲值
@property (nonatomic,assign) CGFloat bufferValue;

@property (nonatomic ,strong) UILabel *trackingTimeLabel;

@property (nonatomic ,strong) UILabel *totalTimeLabel;

@property (nonatomic ,weak)id <PlayerControlDelegate>delegate;

@property (nonatomic ,assign) PlayerControlScalling scalling;

@end
