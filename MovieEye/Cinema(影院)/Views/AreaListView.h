//
//  AreaListView.h
//  MovieEye
//
//  Created by Rany on 17/3/7.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AreaListView;
@protocol AreaListViewDelegate <NSObject>

@optional
- (void)areaListView:(AreaListView *)listView didSelectItemAtIndex:(NSInteger)index;

@end

@interface AreaListView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *areaNameArray;

@property (nonatomic ,weak) id <AreaListViewDelegate> delegate;

@end
