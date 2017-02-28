//
//  BaseViewController.h
//  MovieEye
//
//  Created by Rany on 17/2/20.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//强制横屏
- (void)forceOrientationLandscape;

//强制竖屏
- (void)forceOrientationPortrait;

//是否允许旋转屏幕
-(void)supportedInterfaceOrientations:(BOOL)enable;

@end
