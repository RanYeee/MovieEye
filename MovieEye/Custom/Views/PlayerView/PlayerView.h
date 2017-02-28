//
//  PlayerView.h
//  MovieEye
//
//  Created by Rany on 17/2/21.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIView
//urlAsset
@property (nonatomic,strong) AVURLAsset *assert;

- (instancetype)initWithUrl:(NSURL *)url;

- (instancetype)initWithURLAsset:(AVURLAsset *)asset;

- (void)stop;
@end
