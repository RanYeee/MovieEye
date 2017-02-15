//
//  HotSearchModel.h
//  MovieEye
//
//  Created by Rany on 17/2/13.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotSearchModel : NSObject
@property (nonatomic, copy) NSString *globalReleased;

@property (nonatomic, assign) int dur;

@property (nonatomic, assign) int wishst;

@property (nonatomic, assign) int wish;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *pubDesc;

@property (nonatomic, assign) BOOL onlinePlay;

@property (nonatomic, copy) NSString *fra;

@property (nonatomic, assign) int type;

@property (nonatomic, copy) NSString *nm;

@property (nonatomic, copy) NSString *show;

@property (nonatomic, copy) NSString *frt;

@property (nonatomic, assign) int _id;

@property (nonatomic, copy) NSString *rt;

@property (nonatomic, copy) NSString *ver;

@property (nonatomic, assign) int movieType;

@property (nonatomic, copy) NSString *enm;

@property (nonatomic, copy) NSString *cat;

@property (nonatomic, assign) int showst;
@end
