//
//  FilmStillCell.h
//  MovieEye
//
//  Created by Rany on 2017/2/16.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilmStillCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (void)setStagePhotoWithPhotos:(NSArray *)photoURLs;
@end
