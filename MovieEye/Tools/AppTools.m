
//
//  AppTools.m
//  MovieEye
//
//  Created by Rany on 17/2/21.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "AppTools.h"

@interface AppTools ()



@end

@implementation AppTools



+ (void)judgeNet:(void(^)(AFNetworkReachabilityStatus status))netStatus
{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (netStatus) {
            
            netStatus(status);
        }
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {

                NSLog(@"网络不可用");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                //                [weakSelf loadMessage:@"Wifi已开启"];
                NSLog(@"Wifi已开启");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //                [weakSelf loadMessage:@"你现在使用的流量"];
                NSLog(@"你现在使用的流量");
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown: {
                //                [weakSelf loadMessage:@"你现在使用的未知网络"];
                NSLog(@"你现在使用的未知网络");
                break;
            }
                
            default:
                break;
        }
    }];
    
}

@end
