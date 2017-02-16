//
//  SearchHistoryCell.h
//  MovieEye
//
//  Created by Rany on 17/2/13.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchHistoryCell;
@protocol SearchHistoryCellDelegate <NSObject>

- (void)searchHistoryCell:(SearchHistoryCell *)cell deleteCellAtIndex:(NSIndexPath *)indexPath;

@end

@interface SearchHistoryCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *historyKeyLabel;

@property (nonatomic ,strong) NSIndexPath *indexPath;

@property (nonatomic ,weak)id <SearchHistoryCellDelegate>delegate;

@end
