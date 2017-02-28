//
//  RNAppMacro.h
//  MovieEye
//
//  Created by Rany on 2017/2/8.
//  Copyright © 2017年 Rany. All rights reserved.
//


#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif


#ifdef  DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#define debugMethod()    NSLog(@"%s", __func__)
#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
#else
#define debugLog(...)
#define debugMethod()
#define debugError()
#endif

#define RNLog(x)    NSLog(@#x)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)


//UI设置
#define kWindow [UIApplication sharedApplication].keyWindow
#define RGBA(r,g,b,a)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define BoldSystemFont(size)  [UIFont boldSystemFontOfSize:size]
#define systemFont(size)      [UIFont systemFontOfSize:size]
#define STATUSBAR_HEIGHT      [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVBAR_HEIGHT         (44.f + ((SYSTEM_VERSION >= 7) ? STATUSBAR_HEIGHT : 0))

#define CustomRedColor        [UIColor colorWithRed:0.93 green:0.27 blue:0.25 alpha:1.00]

// 创建图片

#define IMAGE(imageName)        ([UIImage imageNamed:imageName])

//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0

//系统相关
#define SYSTEM_VERSION        [[[UIDevice currentDevice] systemVersion] floatValue]
#define WS(self)    __weak __typeof(&*self)weakSelf = self;
#define RNWeakSelf(type)  __weak typeof(type) weak##type = type;

#define kStatusBarStyleDefault [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault]

#define kStatusBarStyleLightContent [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent]

