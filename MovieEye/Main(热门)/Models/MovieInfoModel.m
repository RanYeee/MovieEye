//
//  MovieInfoModel.m
//  MovieEye
//
//  Created by Rany on 2017/2/9.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "MovieInfoModel.h"


@implementation MovieInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"is3d":@"3d",
             @"_id":@"id"};
}
@end
