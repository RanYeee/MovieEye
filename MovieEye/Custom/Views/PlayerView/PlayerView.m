//
//  PlayerView.m
//  MovieEye
//
//  Created by Rany on 17/2/21.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "PlayerView.h"
#import <Masonry/Masonry.h>
#import "ReachabilityStatus.h"
#import "PlayerControlView.h"

@interface PlayerView ()<PlayerControlDelegate>
{
    NSURL *_url;
    NSTimer *_timer;
    
   
}

@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *item;
//总时长
@property (nonatomic,assign) CGFloat totalDuration;

//转换后的时间
@property (nonatomic,copy) NSString *totalTime;

//当前播放位置
@property (nonatomic,assign) CMTime currenTime;

//是否正在播放
@property (nonatomic,assign)  BOOL isPlaying;

//监听播放值
@property (nonatomic,strong) id playbackTimerObserver;

@property (nonatomic,strong) UIButton *playPausedButton;

@property (nonatomic,strong) PlayerControlView *playControlView;
//全屏控制器
@property (nonatomic,strong) UIViewController *fullVC;
//全屏播放器
@property (nonatomic,strong) PlayerView *fullScreenPlayer;
@end

@implementation PlayerView

- (instancetype)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url=url;
        [self initAsset];
        [self setupPlayer];
    }
    return self;
}

- (instancetype)initWithURLAsset:(AVURLAsset *)asset{
    self=[super init];
    if (self) {
        self.assert=asset;
        [self setupPlayer];
    }
    return self;
}

-(void)setupPlayer{
    [self configPlayer];
    [self addPlayPausedButton];
    [self addPlayerControlView];
    [self addGesture];
    [self addNotification];
    [self addKVO];
 
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame=self.bounds;
}


#pragma mark - ConfigPlayer
-(void)initAsset{
    if (_url) {
        self.assert=[[AVURLAsset alloc]initWithURL:_url options:nil];
    }
}
//配置播放器
-(void)configPlayer{
    self.backgroundColor=[UIColor blackColor];
    self.item=[AVPlayerItem playerItemWithAsset:self.assert];
    self.player=[[AVPlayer alloc]init];
    self.player.usesExternalPlaybackWhileExternalScreenIsActive=YES;
    self.playerLayer=[[AVPlayerLayer alloc]init];
    self.playerLayer.backgroundColor=[UIColor blackColor].CGColor;
    self.playerLayer.player=self.player;
    self.playerLayer.frame=self.bounds;
    [self.playerLayer displayIfNeeded];
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    self.playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;

    [AppTools judgeNet:^(AFNetworkReachabilityStatus status) {
       
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            //使用移动流量
        
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您现在使用的是移动流量，是否继续播放" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [[self getCurrentViewController].navigationController popViewControllerAnimated:YES];
                
            }];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
                [self.player replaceCurrentItemWithPlayerItem:self.item];
                [self.player play];
                _isPlaying = YES;
            }];

            [alertController addAction:cancleAction];
            
            [alertController addAction:sureAction];
            
            [[self getCurrentViewController]presentViewController:alertController animated:YES completion:nil];
            
            
        }else{
            [self.player replaceCurrentItemWithPlayerItem:self.item];
            [self.player play];
            _isPlaying = YES;
            
        }
        
        [QMUITips showLoadingInView:self];

        
    }];
    
}
//添加手势
-(void)addGesture{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

//点击播放器手势事件
-(void)tapAction:(UITapGestureRecognizer *)gesture{

        [self hideOrShowPauseView];
}

//显示或者隐藏暂停按键
-(void)hideOrShowPauseView{
    if (!_isPlaying) {
        [self.playPausedButton setHidden:YES];
        [self.player play];
    }else{
        [self.playPausedButton setHidden:NO];
        [self.player pause];
    }
    
    _isPlaying = !_isPlaying;
}

- (void)addPlayerControlView
{
    self.playControlView = [[PlayerControlView alloc]init];
    self.playControlView.backgroundColor=[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:0.5];
    self.playControlView.delegate = self;
    [self addSubview:self.playControlView];
    
    [self.playControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).priorityHigh();
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(@(controlHeight));
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];

}

//添加播放、暂停按钮
- (void)addPlayPausedButton
{
    self.playPausedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.playPausedButton.hidden = YES;
    
    [self.playPausedButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    
    self.playPausedButton.frame = CGRectMakeWithSize(CGSizeMake(45, 45));
    
    [self.playPausedButton setImage:IMAGE(@"stop") forState:UIControlStateNormal];
    
    [self addSubview:self.playPausedButton];
    
    [self.playPausedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)pause{
    if (self.player!=nil ) {
        
        self.playPausedButton.hidden = _isPlaying;
        
        if (_isPlaying) {
            
            [self.player pause];

        }else{
            
            [self.player play];
        }
        
        _isPlaying = !_isPlaying;
    }
}

-(void)play{
    if (self.player!=nil ) {
        [self.playerLayer isReadyForDisplay];
        [self.player play];
       
        self.playPausedButton.hidden = !self.playPausedButton.isHidden;
    }
}

-(void)stop{
    [self.item seekToTime:kCMTimeZero];
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];

}

//推入全屏
-(UIViewController *)pushToFullScreen{

    UIViewController *vc = [[UIViewController alloc]init];
    [[self getCurrentViewController] prefersStatusBarHidden];
    self.fullScreenPlayer=[[PlayerView alloc]initWithURLAsset:self.assert];
    [vc.view addSubview:self.fullScreenPlayer];
    [self.fullScreenPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(vc.view);
    }];
    
    if (_isPlaying) {
        [self.fullScreenPlayer play];
//        [self.fullScreenPlayer.playPausedView hide];
    }else{
        [self.fullScreenPlayer pause];
    }


    return vc;
}
#pragma mark - SBPlayerControlSliderDelegate

-(void)sendCurrentValueToPlayer:(CGFloat)value{
    //获取进度条所在位置值的时间
    self.currenTime=CMTimeMake(value*self.item.duration.timescale, self.item.duration.timescale);
    [self.player seekToTime:self.currenTime];
}

#pragma mark - 通知者

//添加通知
- (void)addNotification
{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//添加KVO
-(void)addKVO{
    //监听状态属性
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听网络加载情况属性
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监听播放的区域缓存是否为空
    [self.item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //缓存可以播放的时候调用
    [self.item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    //监听暂停或者播放中
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    [self.playControlView addObserver:self forKeyPath:@"scalling" options:NSKeyValueObservingOptionNew context:nil];
//    [self.playPausedView addObserver:self forKeyPath:@"backBtnTouched" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status=[[change objectForKey:NSKeyValueChangeNewKey]integerValue];
        switch (status) {
            case AVPlayerStatusUnknown:{
                NSLog(@"未知状态");
//                self.state=SBPlayerStateBuffering;
            }
                break;
            case AVPlayerStatusReadyToPlay:{
                
                [QMUITips hideAllToastInView:self animated:YES];

                NSLog(@"开始播放状态");
//                self.state=SBPlayerStatePlaying;
//                //总时长
                self.totalDuration=self.item.duration.value/self.item.duration.timescale;
//                //转换成时间格式的总时长
                self.totalTime=[self convertTime:self.totalDuration];
//                //总时间
                self.playControlView.totalTimeLabel.text=self.totalTime;
//                self.playPausedView.totalTime.text=self.totalTime;
//                //设置播放控制器进度最大值和最小值
                self.playControlView.minValue=0;
                self.playControlView.maxValue=self.totalDuration;
                [self addTimer];
//                if (self.loadingView) {
//                    [self.loadingView hide];
//                    [self.loadingView removeFromSuperview];
//                }
            }
                break;
            case AVPlayerStatusFailed:
//                self.state=SBPlayerStateFailed;
                
                NSLog(@"播放失败");
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
//        self.state=SBPlayerStateBuffering;
        NSLog(@"缓冲不足暂停");
        [self.player pause];
        [QMUITips showLoadingInView:self];

        
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
         NSLog(@"缓冲达到可播放");

        [QMUITips hideAllToastInView:self animated:YES];
        [self.playerLayer isReadyForDisplay];
        [self.player play];
        
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {  //监听播放器的下载进度
        NSArray *loadedTimeRanges = [self.item loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
        CMTime duration = self.item.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        //缓冲值
        NSLog(@"缓冲值>> %.2f", timeInterval / totalDuration);
    }else if ([keyPath isEqualToString:@"scalling"]){
        
        NSLog(@">>>>>>hahah");
        
        if (SCREEN_WIDTH>SCREEN_HEIGHT) {
            //处于横屏状态
            
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
            
        }else{
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];

        }
        
 

       
    }else if ([keyPath isEqualToString:@"rate"]){//当rate==0时为暂停,rate==1时为播放,当rate等于负数时为回放
        if ([[change objectForKey:NSKeyValueChangeNewKey]integerValue]==0) {
            _isPlaying=false;
        }else{
            _isPlaying=true;
        }
    }
}


- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIInterfaceOrientation _interfaceOrientation=[[UIApplication sharedApplication]statusBarOrientation];
    switch (_interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {

//            self.fullVC=[self pushToFullScreen];
//            [self.player pause];
//            [self.fullScreenPlayer seekToTime:self.item.currentTime];
//            [[self getCurrentViewController] presentViewController:self.fullVC animated:NO completion:nil];
            NSLog(@"UIInterfaceOrientationLandscapeRight");
            [[self getCurrentViewController].navigationController setNavigationBarHidden:YES animated:YES];


            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(SCREEN_WIDTH));
                make.height.equalTo(@(SCREEN_HEIGHT));
            }];
            [self layoutIfNeeded];
            
            [self setNeedsLayout];
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
        {
            NSLog(@"UIInterfaceOrientationPortrait");

            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(SCREEN_WIDTH));
                make.height.equalTo(@(SCREEN_HEIGHT));
            }];
            
            [[self getCurrentViewController].navigationController setNavigationBarHidden:NO animated:YES];

            [self layoutIfNeeded];
            
            [self setNeedsLayout];
       
        }
            break;
        case UIInterfaceOrientationUnknown:
            NSLog(@"UIInterfaceOrientationLandscapePortial");
            break;
    }
}

-(void)seekToTime:(CMTime)time{
    [self.item seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

//获取当前时间
-(CMTime)currentTime{
    return self.item.currentTime;
}

//监听视频播放时间
-(void)addTimer{
    //设置间隔时间
    CMTime interval=CMTimeMake(1.f, 1.f);
    __weak typeof(self) weakSelf=self;
    self.playbackTimerObserver=[weakSelf.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //使进度条跟着视频播放前进
        CGFloat currentValue=self.item.currentTime.value/self.item.currentTime.timescale;
        self.playControlView.currentValue=currentValue;
        self.playControlView.trackingTimeLabel.text=[self convertTime:currentValue];
        NSLog(@"%f",currentValue);
    }];
}

//将数值转换成时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}


//旋转方向
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    if (orientation == UIInterfaceOrientationLandscapeRight||orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
    }
}


- (void)remove
{
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player removeObserver:self forKeyPath:@"timeControlStatus"];
    [self.playControlView removeObserver:self forKeyPath:@"scalling"];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    self.player = nil;
    self.playerLayer.player=nil;
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.playerLayer removeFromSuperlayer];
}


-(void)dealloc
{
    [self remove];
}

@end
