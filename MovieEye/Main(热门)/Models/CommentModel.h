//
//  CommentModel.h
//  MovieEye
//
//  Created by Rany on 17/2/23.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, assign) int reply;

@property (nonatomic, assign) BOOL supportComment;

@property (nonatomic, assign) int oppose;

@property (nonatomic, assign) int userId;

@property (nonatomic, copy) NSString *avatarurl;

@property (nonatomic, assign) int vipType;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) int approve;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) int spoiler;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *authInfo;

@property (nonatomic, assign) BOOL approved;

@property (nonatomic, assign) int _id;

@property (nonatomic, assign) BOOL isMajor;

@property (nonatomic, assign) int score;

@property (nonatomic, assign) BOOL supportLike;

@property (nonatomic, assign) int sureViewed;

@property (nonatomic, assign) int juryLevel;

@property (nonatomic, assign) int movieId;

@property (nonatomic, copy) NSArray *tagList;

@property (nonatomic, copy) NSString *vipInfo;

@property (nonatomic, assign) BOOL filmView;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) int userLevel;

@property (nonatomic, assign) BOOL pro;


@end
