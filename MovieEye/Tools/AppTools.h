//
//  AppTools.h
//  MovieEye
//
//  Created by Rany on 17/2/21.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AppTools : NSObject


/**
 判断网络

 @param netStatus 返回网络状态
 */
+ (void)judgeNet:(void(^)(AFNetworkReachabilityStatus status))netStatus;

@end
