//
//  CinemaListModel.m
//  MovieEye
//
//  Created by Rany on 17/3/7.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaListModel.h"

@implementation CinemaListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"_id":@"id"};
}
@end
