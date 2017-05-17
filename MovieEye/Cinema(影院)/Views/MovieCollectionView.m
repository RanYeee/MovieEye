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
//#import <LazyScroll/TMMuiLazyScrollView.h>
#define kPageWidth (self.width/3)
#define kSpacing 20
@interface MovieCollectionView()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _imageV_h;
    CGFloat _imageV_w;
    CGFloat _offset;
    
    UIImageView *_tmpImageview;
}
@property (nonatomic,strong) UIImageView *bgImageView;//背景图

@property (nonatomic,strong) QMUIVisualEffectView *blurEffectView;//模糊背景图

@property (nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic, strong, readonly) QMUICollectionViewPagingLayout *collectionViewLayout;

@property(nonatomic, strong) UIScrollView *scrollView;


@end

@implementation MovieCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI
{
    self.bgImageView = [[UIImageView alloc]init];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    self.bgImageView.image = IMAGE(@"bgImageTest");
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.bottom.equalTo(self);

    }];
        

    self.blurEffectView = [[QMUIVisualEffectView alloc]initWithStyle:QMUIVisualEffectViewStyleDark];
//    self.blurEffectView.alpha = 0.75;
    [self addSubview:self.blurEffectView];
    [self.blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.bgImageView);
        
    }];
    
    //scrollview
//    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
//    self.scrollView.delegate = self;
//    [self addSubview:self.scrollView];
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.edges.equalTo(self);
//        
//    }];
    
    _collectionViewLayout = [[QMUICollectionViewPagingLayout alloc] initWithStyle:QMUICollectionViewPagingLayoutStyleScale];

    _collectionView.maximumZoomScale = 1.5;
    
    //collectionView
    self.collectionView = [[UICollectionView alloc]initWithFrame:(CGRect){0,0,self.frame.size} collectionViewLayout:_collectionViewLayout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MovieCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];

    [self addSubview:self.collectionView];
 
    //angle
    UIImageView *angleImage = [[UIImageView alloc]initWithImage:IMAGE(@"angle")];
//    angleImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:angleImage];
    [angleImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(18, 6));
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picUrlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionCell *cell = (MovieCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.movieImageView sd_setImageWithURL:[NSURL URLWithString:self.picUrlArray[indexPath.row]]];
    [cell setNeedsLayout];
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return kSpacing;
}
#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    _imageV_h = self.frame.size.height-2*kSpacing;
    _imageV_w = _imageV_h*18/25;
    CGSize size = CGSizeMake(_imageV_w, _imageV_h);
    return size;
}


-(void)setPicUrlArray:(NSArray *)picUrlArray
{
    _picUrlArray = picUrlArray;
    NSInteger count = picUrlArray.count;
    _imageV_h = self.frame.size.height-2*kSpacing;
    _imageV_w = _imageV_h*18/25;
    NSLog(@"NSStringFromCGSize>%@",NSStringFromCGSize(self.collectionView.contentSize));
//    self.collectionView.contentInset = UIEdgeInsetsMake(10, self.frame.size.width/2-_imageV_w/2, 10, self.frame.size.width/2-_imageV_w/2);
    [self.collectionView reloadData];
    /*
    _imageV_h = self.frame.size.height-2*kSpacing;
    _imageV_w = _imageV_h*18/25;
    _offset = self.width/2-_imageV_w/2;
    [_picUrlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imageView = [[UIImageView alloc]init];

        imageView.tag = idx+100;
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj]];
        NSLog(@"%@",obj);
//        imageView.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:imageView];
        CGFloat imageV_x = _offset+kSpacing*(idx)+idx*_imageV_w;
        if (idx==0) {
            imageV_x = _offset;
        }
        
        imageView.frame = CGRectMake(imageV_x, kSpacing, _imageV_w, _imageV_h);
//        imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);

        
    }];
    
    self.scrollView.contentSize = CGSizeMake(count*_imageV_w+(count+1)*kSpacing+2*(_offset-kSpacing), self.height-20);
     */
}

-(void)scaleImageViewAtIndex:(NSInteger)index
{
    NSLog(@"%d",index);
////    
    UIImageView *presentView = (UIImageView *)[self.scrollView viewWithTag:index+100];
    [UIView animateWithDuration:0.25 animations:^{
        presentView.transform = CGAffineTransformMakeScale(1.1, 1.1);

    }];
    presentView.layer.borderColor = [UIColor whiteColor].CGColor;
    presentView.layer.borderWidth = 1.0f;
    
    if (_tmpImageview) {
        
        [UIView animateWithDuration:0.25 animations:^{
            _tmpImageview.transform = CGAffineTransformMakeScale(1.0, 1.0);

        }];
        _tmpImageview.layer.borderWidth = 0.0f;
    }
    
    _tmpImageview = presentView;
}

#pragma mark - scrollViewDelegate


//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//
////    [self setScrollViewContentOffsetWithScrollView:scrollView];
//
//}

//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//
////    [self setScrollViewContentOffsetWithScrollView:scrollView];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    if (offset>0 && offset<self.scrollView.contentSize.width) {
        NSLog(@"%f",offset);

    }
}

- (void)setScrollViewContentOffsetWithScrollView:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    float fl = offsetX/_imageV_w;
    int i = (int)fl;
    float result = fl-i;
    //    NSLog(@"%d--%f——%f",i,offsetX,result);
    
    if (result>0.6) {
        i++;
        
        if (i<self.picUrlArray.count) {
            
            [UIView animateWithDuration:0.2 animations:^{
                scrollView.contentOffset = CGPointMake((_imageV_w+kSpacing)*i, 0);
            }completion:^(BOOL finished) {
                
                
            }];
            
        }
        
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentOffset = CGPointMake((_imageV_w+kSpacing)*i, 0);
        }];
    }
    
    [self scaleImageViewAtIndex:i];
}

@end
