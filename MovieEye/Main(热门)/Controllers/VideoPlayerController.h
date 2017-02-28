//
//  VideoPlayerController.h
//  MovieEye
//
//  Created by Rany on 2017/2/18.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayerController : BaseViewController

@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, copy) NSString *mp4_URLString;

@end
