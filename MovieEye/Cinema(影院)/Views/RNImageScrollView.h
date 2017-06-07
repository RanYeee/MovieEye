//
//  CinemaDetailTopView.h
//  MovieEye
//
//  Created by Rany on 2017/5/17.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNImageScrollView.h"

@protocol RNImageScrollViewDelegate <NSObject>

- (void)scrollViewDidEndScrollAtIndex:(NSInteger)index;

@end
@interface RNImageScrollView : UIView

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIImageView *bgImageView;

@property(nonatomic, strong) UIVisualEffectView *blurView;

@property(nonatomic, strong) NSArray *imageURLArray;


@property(nonatomic, weak) id <RNImageScrollViewDelegate>delegate;

@end
