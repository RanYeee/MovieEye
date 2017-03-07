//
//  AreaListView.h
//  MovieEye
//
//  Created by Rany on 17/3/7.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaListView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *areaNameArray;

@end
