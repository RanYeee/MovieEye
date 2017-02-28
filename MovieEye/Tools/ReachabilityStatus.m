//
//  ReachabilityStatus.m
//  SmartCommunity
//
//  Created by Harvey Huang on 15-3-24.
//  Copyright (c) 2015年 Horizontal. All rights reserved.
//

#import "ReachabilityStatus.h"
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


NSString * const NetworkReachabilityDidChangeNotification = @"NetworkReachabilityDidChangeNotification";
NSString * const NetworkReachabilityNotificationStatusItem = @"NetworkReachabilityNotificationStatusItem";

typedef void (^NetworkReachabilityStatusBlock)(NetworkReachabilityStatus status);

typedef NS_ENUM(NSUInteger, NetworkReachabilityAssociation) {
    NetworkReachabilityForAddress     = 1,
    NetworkReachabilityForAddressPair = 2,
    NetworkReachabilityForName        = 3,
};

static NetworkReachabilityStatus AFNetworkReachabilityStatusForFlags(SCNetworkReachabilityFlags flags) {
    
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    NetworkReachabilityStatus status = NetworkReachabilityStatusUnknown;
    if (isNetworkReachable == NO) {
        status = NetworkReachabilityStatusNotReachable;
    }
    
#if	TARGET_OS_IPHONE
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        status = NetworkReachabilityStatusReachableViaWWAN;
    }
#endif
    else {
        status = NetworkReachabilityStatusReachableViaWiFi;
    }
    
    return status;
}

static void AFNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    NetworkReachabilityStatus status = AFNetworkReachabilityStatusForFlags(flags);
    NetworkReachabilityStatusBlock block = (__bridge NetworkReachabilityStatusBlock)info;
    if (block) {
        block(status);
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:NetworkReachabilityDidChangeNotification object:nil userInfo:@{NetworkReachabilityNotificationStatusItem: @(status) }];
    });
    
}


static const void * NetworkReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void NetworkReachabilityReleaseCallback(const void *info) {
    if (info) {
        Block_release(info);
    }
}



@interface ReachabilityStatus ()

@property (readwrite, nonatomic, assign) SCNetworkReachabilityRef networkReachability;
@property (readwrite, nonatomic, assign) NetworkReachabilityAssociation networkReachabilityAssociation;
@property (readwrite, nonatomic, assign) NetworkReachabilityStatus networkReachabilityStatus;
@property (readwrite, nonatomic, copy)   NetworkReachabilityStatusBlock networkReachabilityStatusBlock;

@end



@implementation ReachabilityStatus

+ (instancetype)sharedInstance {
    
    static ReachabilityStatus *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct sockaddr_in address;
        bzero(&address, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET;
        
        _sharedManager = [self managerForAddress:&address];
        
        _sharedManager.IPAddress = [_sharedManager getIPAddress:YES];
    });
    
    return _sharedManager;
}

+ (instancetype)managerForDomain:(NSString *)domain {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    
    ReachabilityStatus *reachStatus = [[self alloc] initWithReachability:reachability];
    
    reachStatus.networkReachabilityAssociation = NetworkReachabilityForName;
    
    return reachStatus;
}

+ (instancetype)managerForAddress:(const void *)address {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);
    
    ReachabilityStatus *reachStatus = [[self alloc] initWithReachability:reachability];
    reachStatus.networkReachabilityAssociation = NetworkReachabilityForAddress;
    
    return reachStatus;
}


- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.networkReachability = reachability;
    self.networkReachabilityStatus = NetworkReachabilityStatusUnknown;
    
    return self;
}

- (void)dealloc {
    [self stopMonitoring];
    
    if (_networkReachability) {
        CFRelease(_networkReachability);
        _networkReachability = NULL;
    }
}


#pragma mark -

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return self.networkReachabilityStatus == NetworkReachabilityStatusReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return self.networkReachabilityStatus == NetworkReachabilityStatusReachableViaWiFi;
}


#pragma mark -

- (void)startMonitoring {
    [self stopMonitoring];
    
    if (!self.networkReachability) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    NetworkReachabilityStatusBlock callback = ^(NetworkReachabilityStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.networkReachabilityStatus = status;
        if (strongSelf.networkReachabilityStatusBlock) {
            strongSelf.networkReachabilityStatusBlock(status);
        }
        
    };
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)callback, NetworkReachabilityRetainCallback, NetworkReachabilityReleaseCallback, NULL};
    
    SCNetworkReachabilitySetCallback(self.networkReachability, AFNetworkReachabilityCallback, &context);
    
    SCNetworkReachabilityScheduleWithRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    switch (self.networkReachabilityAssociation) {
            
        case NetworkReachabilityForName:
            break;
            
        case NetworkReachabilityForAddress:
            
        case NetworkReachabilityForAddressPair:
            
        default: {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
                
                SCNetworkReachabilityFlags flags;
                SCNetworkReachabilityGetFlags(self.networkReachability, &flags);
                NetworkReachabilityStatus status = AFNetworkReachabilityStatusForFlags(flags);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(status);
                    
                    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter postNotificationName:NetworkReachabilityDidChangeNotification object:nil userInfo:@{ NetworkReachabilityNotificationStatusItem: @(status) }];
                    
                });
            });
        }
            break;
    }
}

- (void)stopMonitoring {
    if (!self.networkReachability) {
        return;
    }
    
    SCNetworkReachabilityUnscheduleFromRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}


#pragma mark - getIPAddress

- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@">>> IP addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark -

- (void)setReachabilityStatusChangeBlock:(void (^)(NetworkReachabilityStatus status))block {
    self.networkReachabilityStatusBlock = block;
}


#pragma mark - NSKeyValueObserving

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"reachable"] || [key isEqualToString:@"reachableViaWWAN"] || [key isEqualToString:@"reachableViaWiFi"]) {
        return [NSSet setWithObject:@"networkReachabilityStatus"];
    }
    
    return [super keyPathsForValuesAffectingValueForKey:key];
}


@end
