//
//  APIRequestManager.h
//  MovieEye
//
//  Created by Rany on 2017/2/8.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


typedef void(^RequestSuccessBlock)(id request);

typedef void(^RequestFailBlock)(NSError *error);


@interface APIRequestManager : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *manager;

+(instancetype)shareInstance;

- (void)getHTTPPath:(NSString *)apiPath
            success:(RequestSuccessBlock)success
            failure:(RequestFailBlock)failure;

@end
