//
//  DatesSelectView.h
//  MovieEye
//
//  Created by Rany on 2017/5/22.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatesSelectView;

@protocol DatesSelectViewDelegate <NSObject>

- (void)datesSelectView:(DatesSelectView *)selectView didSelectedAtIndex:(NSInteger)index;

@end


@interface DatesSelectView : UIView


@property(nonatomic, strong) NSArray *itemTitleArray;

@property(nonatomic, weak) id <DatesSelectViewDelegate>delegate;

@end
