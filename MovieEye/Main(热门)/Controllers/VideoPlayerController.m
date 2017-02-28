//
//  VideoPlayerController.m
//  MovieEye
//
//  Created by Rany on 2017/2/18.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "VideoPlayerController.h"
#import <AVKit/AVKit.h>
#import "PlayerView.h"
#import <Masonry/Masonry.h>

@interface VideoPlayerController ()
@property (strong,nonatomic) PlayerView *player;
@end

@implementation VideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.player = [[PlayerView alloc]initWithUrl:[NSURL URLWithString:_mp4_URLString]];
    
    [self.view addSubview:self.player ];
    
    [self.player  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];

}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self supportedInterfaceOrientations:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [self forceOrientationPortrait];
    
    [self.player stop];
    
    [self.player removeFromSuperview];
    
    self.player = nil;
}

-(void)dealloc
{
    [self.player stop];

}

@end
