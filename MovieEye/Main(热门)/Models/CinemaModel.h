//
//  CinemaModel.h
//  MovieEye
//
//  Created by Rany on 17/3/3.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaModel : NSObject
@property (nonatomic, copy) NSString *vipDesc;

@property (nonatomic, assign) int snack;

@property (nonatomic, assign) int _id;

@property (nonatomic, copy) NSString *dealPrice;

@property (nonatomic, assign) int follow;

@property (nonatomic, assign) int exclusive;

@property (nonatomic, copy) NSString *nm;

@property (nonatomic, copy) NSDictionary *giftInfo;

@property (nonatomic, copy) NSString *platformActivityTag;

@property (nonatomic, assign) int closeStatus;

@property (nonatomic, assign) int type;

@property (nonatomic, copy) NSString *referencePrice;

@property (nonatomic, copy) NSString *addr;

@property (nonatomic, assign) int deal;

@property (nonatomic, assign) int imax;

@property (nonatomic, assign) int endorse;

@property (nonatomic, assign) int showGiftTag;

@property (nonatomic, assign) int preferential;

@property (nonatomic, copy) NSDictionary *vipInfo;

@property (nonatomic, copy) NSString *giftDesc;

@property (nonatomic, assign) int brdId;

@property (nonatomic, assign) int allowRefundTime;

@property (nonatomic, assign) int poiId;

@property (nonatomic, assign) int lng;

@property (nonatomic, copy) NSString *sellPrice;

@property (nonatomic, assign) BOOL sell;

@property (nonatomic, assign) int lat;

@property (nonatomic, assign) int distance;

@property (nonatomic, assign) int allowRefund;

@property (nonatomic, assign) int isPlatformActivity;

@property (nonatomic, assign) int hasGift;

@property (nonatomic, assign) int isMerchantActivity;

@property (nonatomic, copy) NSArray *cinemaPreTag;

@end
