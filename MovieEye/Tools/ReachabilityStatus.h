//
//  ReachabilityStatus.h
//  SmartCommunity
//
//  Created by Harvey Huang on 15-3-24.
//  Copyright (c) 2015年 Horizontal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef NS_ENUM(NSInteger, NetworkReachabilityStatus) {
    NetworkReachabilityStatusUnknown          = -1,
    NetworkReachabilityStatusNotReachable     = 0,
    NetworkReachabilityStatusReachableViaWWAN = 1,
    NetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface ReachabilityStatus : NSObject

/**
 *  当前网络状态
 */
@property (readonly, nonatomic, assign) NetworkReachabilityStatus networkReachabilityStatus;

/**
 目前是否有网络
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/**
 *  目前网络是否通过 WWAN(3G/4G) 链接
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/**
 *  目前网络是否通过 WiFi 链接.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;


@property (nonatomic, copy) NSString *IPAddress;


/**
 *  初始化 NetworkManager 单例.
 */
+ (instancetype)sharedInstance;

/**
 *  开始监听网络改变状态
 */
- (void)startMonitoring;

/**
 *  停止监听网络改变状态
 */
- (void)stopMonitoring;


/**
 *  获取IP地址
 */
- (NSString *)getIPAddress:(BOOL)preferIPv4;


/**
 *  获取网路状态回调Block
 */
- (void)setReachabilityStatusChangeBlock:(void (^)(NetworkReachabilityStatus status))block;

extern NSString * const NetworkReachabilityDidChangeNotification;
extern NSString * const NetworkReachabilityNotificationStatusItem;

@end
