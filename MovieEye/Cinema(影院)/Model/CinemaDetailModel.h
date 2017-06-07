//
//  CinemaDetailModel.h
//  MovieEye
//
//  Created by Rany on 2017/5/22.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaDetailModel : NSObject

@property(nonatomic, copy) NSArray *Dates;

@property(nonatomic, copy) NSDictionary *currentMovie;

@property(nonatomic, copy) NSDictionary *cinemaDetailModel;

@property(nonatomic, copy) NSArray *movies;

@property(nonatomic, copy) NSArray *DateShow;

@property (nonatomic, strong) NSString *cssLink;

@end
