//
//  CinemaDetailApi.m
//  MovieEye
//
//  Created by Rany on 2017/6/5.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaDetailApi.h"

@interface CinemaDetailApi()

{
    NSString *_cinemaId;
    
    NSString *_movieId;
}

@end

@implementation CinemaDetailApi

-(instancetype)initWithCinemaID:(NSString *)cinemaId MovieID:(NSString *)movieId
{
    self = [super init];
    
    if (self) {
        
        _cinemaId = cinemaId;
        
        _movieId = movieId;
        
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"/showtime/wrap.json?cinemaid=%@&movieid=%@",_cinemaId,_movieId];
}


@end
