//
//  SearchResultModel.h
//  MovieEye
//
//  Created by Rany on 17/3/3.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject
@property (nonatomic, assign) int _id;

@property (nonatomic, copy) NSString *cat;

@property (nonatomic, assign) BOOL globalReleased;

@property (nonatomic, assign) BOOL onlinePlay;

@property (nonatomic, copy) NSString *enm;

@property (nonatomic, copy) NSString *nm;

@property (nonatomic, copy) NSString *pubDesc;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, assign) int movieType;

@property (nonatomic, assign) float sc;

@property (nonatomic, copy) NSString *show;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) int type;

@property (nonatomic, copy) NSString *ver;

@property (nonatomic, assign) int wish;

@property (nonatomic, assign) int wishst;

@property (nonatomic, assign) int showst;

@property (nonatomic, assign) int dur;
@end
