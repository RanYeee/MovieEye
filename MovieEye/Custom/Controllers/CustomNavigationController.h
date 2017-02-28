//
//  CustomNavigationController.h
//  MovieEye
//
//  Created by Rany on 17/2/20.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationController : UINavigationController
//旋转方向 默认竖屏
@property (nonatomic , assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic , assign) UIInterfaceOrientationMask interfaceOrientationMask;

@end
