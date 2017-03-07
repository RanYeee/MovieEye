//
//  CinemaListModel.h
//  MovieEye
//
//  Created by Rany on 17/3/7.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaListModel : NSObject
@property (nonatomic, assign) int imax;

@property (nonatomic, assign) int referencePrice;

@property (nonatomic, assign) int deal;

@property (nonatomic, assign) int distance;

@property (nonatomic, assign) int lng;

@property (nonatomic, copy) NSString *nm;

@property (nonatomic, copy) NSString *dis;

@property (nonatomic, copy) NSString *ct;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, assign) int preferential;

@property (nonatomic, assign) int showCount;

@property (nonatomic, copy) NSString *addr;

@property (nonatomic, assign) int _id;

@property (nonatomic, assign) int sellmin;

@property (nonatomic, assign) BOOL sell;

@property (nonatomic, assign) int poiId;

@property (nonatomic, copy) NSString *brd;

@property (nonatomic, assign) int lat;

@property (nonatomic, assign) int sellPrice;

@property (nonatomic, assign) int brdId;

@property (nonatomic, assign) int dealPrice;

@property (nonatomic, assign) int follow;
@end
