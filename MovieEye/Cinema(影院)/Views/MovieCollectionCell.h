//
//  MovieCollectionCell.h
//  MovieEye
//
//  Created by Rany on 17/3/3.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *movieImageView;

+(instancetype)createCollectionCell;

@end
