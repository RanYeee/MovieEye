//
//  MovieCollectionView.m
//  MovieEye
//
//  Created by Rany on 17/3/3.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "MovieCollectionView.h"
#import "MovieCollectionCell.h"
#import <Masonry/Masonry.h>
@interface MovieCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIImageView *bgImageView;//背景图

@property (nonatomic,strong) QMUIVisualEffectView *blurEffectView;//模糊背景图

@property (nonatomic,strong) UICollectionView *collectionView;//背景图

@property(nonatomic, strong) QMUICollectionViewPagingLayout *collectionViewLayout;


@end

@implementation MovieCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI
{
    self.bgImageView = [[UIImageView alloc]init];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.bottom.equalTo(self);

    }];
        

    self.blurEffectView = [[QMUIVisualEffectView alloc]initWithStyle:QMUIVisualEffectViewStyleDark];
    self.blurEffectView.alpha = 0.75;
    [self addSubview:self.blurEffectView];
    [self.blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.bgImageView);
        
    }];
    
    self.collectionView = [[UICollectionView alloc]init];
    self.collectionView.backgroundColor = UIColorClear;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = self.collectionViewLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MovieCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cellID"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self);
        
    }];
        
    
    
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionCell *cell = (MovieCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [MovieCollectionCell createCollectionCell];
        
    }
    cell.movieImageView.image = IMAGE(@"bgImageTest");
    [cell setNeedsLayout];
    return cell;
}


@end
