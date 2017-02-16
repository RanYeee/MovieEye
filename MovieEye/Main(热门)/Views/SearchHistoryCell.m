//
//  SearchHistoryCell.m
//  MovieEye
//
//  Created by Rany on 17/2/13.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "SearchHistoryCell.h"

@implementation SearchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)cancleButtonClick:(id)sender {
    
    if (self.delegate) {
        
        [self.delegate searchHistoryCell:self deleteCellAtIndex:self.indexPath];
    }
    
}



@end
