//
//  AppDelegate.m
//  MovieEye
//
//  Created by Rany on 2017/2/8.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    
    config.baseUrl = @"http://m.maoyan.com";
    
    [QMUIConfigurationTemplate setupConfigurationTemplate];
    
//    [QMUIConfigurationManager renderGlobalAppearances];

//    [QMUIConfigurationManager sharedInstance].navBarTitleColor = [UIColor whiteColor];

     [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor  whiteColor]} forState:UIControlStateNormal];
    
       [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:CustomRedColor} forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:CustomRedColor];
    
    //返回按钮的箭头颜色
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //设置返回样式图片
    
    UIImage *image = [UIImage imageNamed:@"back"];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [UINavigationBar appearance].backIndicatorImage = image;
    
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
    
    return YES;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    if (self.isForcePortrait && self.isForceLandscape) {
        
        return  UIInterfaceOrientationMaskAll;
    }
    
    if (self.isForceLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }else if (self.isForcePortrait){
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
