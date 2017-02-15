//
//  PerformerCell.h
//  MovieEye
//
//  Created by Rany on 17/2/15.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerformerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
+(instancetype)createFromXIB;
- (void)addPerformerInfoWithDatas:(NSArray *)actorsList;
@end
