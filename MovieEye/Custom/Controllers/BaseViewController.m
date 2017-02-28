//
//  BaseViewController.m
//  MovieEye
//
//  Created by Rany on 17/2/20.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//是否允许屏幕旋转
-(void)supportedInterfaceOrientations:(BOOL)enable
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=enable;
    appdelegate.isForcePortrait = enable;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    

}

//强制横屏
- (void)forceOrientationLandscape
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];

    CustomNavigationController *navi = (CustomNavigationController *)self.navigationController;
    navi.interfaceOrientation =   UIInterfaceOrientationLandscapeRight;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

-(void)forceOrientationPortrait
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=NO;
    appdelegate.isForcePortrait=YES;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

@end
