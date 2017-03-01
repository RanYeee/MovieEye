//
//  HotSearchCell.h
//  MovieEye
//
//  Created by Rany on 17/2/10.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSearchModel.h"
#import "CommentTagCell.h"
@interface HotSearchCell : CommentTagCell

@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;

@property (nonatomic ,copy) NSArray<HotSearchModel*> *hotSearchArray;

@end
