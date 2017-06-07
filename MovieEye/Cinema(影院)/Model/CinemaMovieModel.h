//
//  CinemaMovieModel.h
//  MovieEye
//
//  Created by Rany on 2017/5/18.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaMovieModel : NSObject

@property (nonatomic, strong) NSString *img;

@property (nonatomic, assign) int _id;

@property (nonatomic, assign) float sc;

@property (nonatomic, strong) NSString *ver;

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, assign) int preferential;

@property (nonatomic, strong) NSString *nm;

@end
