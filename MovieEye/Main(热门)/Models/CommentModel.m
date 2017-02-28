//
//  CommentModel.m
//  MovieEye
//
//  Created by Rany on 17/2/23.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"_id":@"id"};
}
@end
