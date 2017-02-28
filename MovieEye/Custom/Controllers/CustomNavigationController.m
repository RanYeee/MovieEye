//
//  CustomNavigationController.m
//  MovieEye
//
//  Created by Rany on 17/2/20.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - - orientation
//设置是否允许自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.interfaceOrientationMask;
}

//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.interfaceOrientation;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.childViewControllers.count != 0) { // 非根控制器
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        
    }else{
        
        viewController.hidesBottomBarWhenPushed = NO;
        
    }
    
    [super pushViewController:viewController animated:animated];

}

@end
