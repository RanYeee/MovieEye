//
//  APIRequestManager.m
//  MovieEye
//
//  Created by Rany on 2017/2/8.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "APIRequestManager.h"

@implementation APIRequestManager

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static APIRequestManager *requestManager = nil;
    dispatch_once(&onceToken, ^{
        requestManager = [[APIRequestManager alloc]init];
    });
    
    return requestManager;
}

-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
        
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",nil];

    }
    
    return _manager;
}

- (void)getHTTPPath:(NSString *)apiPath
            success:(RequestSuccessBlock)success
            failure:(RequestFailBlock)failure
{
    NSLog(@">>apiPath:%@",apiPath);
    
    [self.manager GET:apiPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

@end
