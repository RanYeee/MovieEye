//
//  CinemaMovieModel.m
//  MovieEye
//
//  Created by Rany on 2017/5/18.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaMovieModel.h"

@implementation CinemaMovieModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"_id":@"id"};
}
@end
