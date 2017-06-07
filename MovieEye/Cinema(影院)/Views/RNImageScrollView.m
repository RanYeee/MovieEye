//
//  CinemaDetailTopView.m
//  MovieEye
//
//  Created by Rany on 2017/5/17.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "RNImageScrollView.h"
#import "UIButton+WebCache.h"

#define KSpacing 20.0f
#define KTopSpacing 40.f
#define KImg_height self.height-KTopSpacing
#define KImg_width (KImg_height)/25*18

@interface RNImageScrollView()<UIScrollViewDelegate>

{
    int img_offset;
    
    UIImageView *_currentImageView; //当前选中的imageView
    
    UIImageView *_previousImageView; //上一个的imageView
}

@property(nonatomic, strong) UIImageView *angleView;

@property(nonatomic, strong) NSMutableArray *imageViewArray;
@end

@implementation RNImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

-(NSMutableArray *)imageViewArray
{
    if (!_imageViewArray) {
        
        _imageViewArray = [NSMutableArray array];
    }
    
    return _imageViewArray;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //背景图片
    self.bgImageView = [[UIImageView alloc]init];
    
    self.bgImageView.backgroundColor = [UIColor grayColor];
    
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.bgImageView.clipsToBounds = YES;
    
    [self addSubview:_bgImageView];
    
    //毛玻璃图层
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self.blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    [self addSubview:self.blurView];
    
    //scrollview
    self.scrollView = [[UIScrollView alloc]init];
    
    self.scrollView.delegate = self;
    
    [self addSubview:self.scrollView];
    
    self.angleView = [[UIImageView alloc]init];
    
    self.angleView.image = IMAGE(@"angle");
    
    [self addSubview:self.angleView];
    

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect scrollViewRect = CGRectMake(0, 0, self.width, self.height);
    
    self.bgImageView.frame = scrollViewRect;
    
    self.blurView.frame = scrollViewRect;
    
    self.scrollView.frame = scrollViewRect;

    self.angleView.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame)-9, 14, 10);

    self.angleView.centerX = self.centerX;

}

-(void)addImageInScrollView
{
    
    if (self.imageViewArray.count>0) {
        
        return;
    }
    //设置背景图为图片数组的第一张
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[0]]];
    
    //创建图片到scrollview里面
    CGFloat contentOffset = self.width/2-KImg_width/2;
    
    NSInteger imageCount = _imageURLArray.count;
    
    for (int i=0; i<imageCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        imageView.layer.borderColor = [UIColorWhite CGColor];
        
        imageView.frame = CGRectMake(i*(KImg_width+KSpacing)+contentOffset, KTopSpacing/2,KImg_width,KImg_height);
        
        imageView.clipsToBounds = YES;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.backgroundColor = CustomRedColor;
        
        imageView.tag = 100+i;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[i]] placeholderImage:nil];
        
        if (i == 0) {
            
            imageView.layer.borderWidth = 1.0f;
            
            imageView.transform = CGAffineTransformMakeScale(1.15, 1.15);
            
            _previousImageView = imageView;
        }
        
        [self.scrollView addSubview:imageView];
        
        [self.imageViewArray addObject:imageView];
        
    }
    
    self.scrollView.contentSize = CGSizeMake(imageCount*KImg_width+(imageCount-1)*KSpacing+2*contentOffset, 0);

    _currentImageView = self.imageViewArray[0];
    
    if (self.delegate) {
        
        [self.delegate scrollViewDidEndScrollAtIndex:0];
    }
}


#pragma mark - setter

-(void)setImageURLArray:(NSArray *)imageURLArray
{
    _imageURLArray = imageURLArray;
    
    [self addImageInScrollView];
}


#pragma mark - scrollviewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int offset_X = scrollView.contentOffset.x;
    
    int imgOffset = KImg_width/2;
    
//    NSLog(@"offset_X = %d ,index = %d",offset_X%imgOffset,offset_X/imgOffset);
    
    

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  
    if (decelerate) {
        
        return;
        
    }
    
    [self updateContentOffsetWithScrollview:scrollView];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self updateContentOffsetWithScrollview:scrollView];
}

- (void)updateContentOffsetWithScrollview:(UIScrollView *)scrollView
{
    int offset_X = scrollView.contentOffset.x;
    
    if (offset_X<0){
        
        return;
    }
    
    img_offset = KImg_width/2;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (offset_X/img_offset<=1) {
            
            scrollView.contentOffset = CGPointMake((KImg_width+KSpacing)*(offset_X/img_offset), 0);
            
        }else{
            img_offset = KImg_width+KSpacing;
            scrollView.contentOffset = CGPointMake((KImg_width+KSpacing)*(offset_X/img_offset), 0);
        }
        
    }completion:^(BOOL finished) {
        
        if (finished) {
            
            //切换背景图
            NSInteger index = offset_X/img_offset;
            
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[index]]];
            
            //改变图片大小
            
            if (_previousImageView) {
                
//                if (_previousImageView.tag!=_currentImageView.tag) {
                
                    [UIView animateWithDuration:0.2 animations:^{
                        _previousImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);;
                        _previousImageView.layer.borderWidth = 0.0f;
                        
                    }];
//                }
              
            }
            
            _currentImageView = (UIImageView *)self.imageViewArray[index];
            [UIView animateWithDuration:0.2 animations:^{
                _currentImageView.transform = CGAffineTransformMakeScale(1.15, 1.15);
                _currentImageView.layer.borderWidth = 1.0f;
             
            }completion:^(BOOL finished) {
                
                _previousImageView = _currentImageView;
                
            }];
            
            
            if (self.delegate) {
                
                [self.delegate scrollViewDidEndScrollAtIndex:index];
                
            }
        }
        
    }];
    
//    NSLog(@"offsetX =%d index = %d",offset_X,offset_X/img_offset);
}

@end
