//
//  SearchResultModel.m
//  MovieEye
//
//  Created by Rany on 17/3/3.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "SearchResultModel.h"

@implementation SearchResultModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"_id":@"id"};
}
@end
