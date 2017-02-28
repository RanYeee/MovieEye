//
//  FilmStillCell.m
//  MovieEye
//
//  Created by Rany on 2017/2/16.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "FilmStillCell.h"
#import "UIButton+WebCache.h"
#import "UIView+DDAddition.h"
#import "VideoPlayerController.h"

@interface FilmStillCell()<QMUIImagePreviewViewDelegate>
{
    CGRect _tmpStageImageRect;
}
@property(nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;

@end
@implementation FilmStillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setStagePhotoWithPhotos:(NSArray *)photoURLs{
    
    if (_photoURLs) {
        
        return;
    }
    
    _photoURLs = photoURLs;
    
    self.scrollView.contentSize = CGSizeMake(110*(photoURLs.count-1)+150+(photoURLs.count+1)*10, self.scrollView.frame.size.height);
    
    [photoURLs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSString *urlStr = [obj stringByReplacingOccurrencesOfString:@"w.h" withString:@"156.220"];
        
        NSString *imgURLStr = [[urlStr componentsSeparatedByString:@"@"]firstObject];
        UIImageView *stageImageView = [[UIImageView alloc]init];
        stageImageView.tag = idx;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAvatarViewEvent:)];
        stageImageView.userInteractionEnabled = YES;
        [stageImageView addGestureRecognizer:tap];
        stageImageView.contentMode = UIViewContentModeScaleAspectFill;
        stageImageView.clipsToBounds = YES;
        
        if (idx == 0) {
            
            stageImageView.frame = CGRectMake(10, 8, 150, 95);
            
            //添加播放按钮
            UIButton *playButton = [[UIButton alloc]init];
            playButton.frame = CGRectMake(CGRectGetMaxX(stageImageView.frame)-50, CGRectGetMaxY(stageImageView.frame)-50, 30, 30);
            [playButton setImage:IMAGE(@"play") forState:UIControlStateNormal];
            [playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [stageImageView addSubview:playButton];
            
        }else if(idx == 1){
            
            stageImageView.frame = CGRectMake(150*idx+20, 8, 110, 95);
            
        }else{
            
            stageImageView.frame = CGRectMake(110*idx+40+(idx+1)*10, 8, 110, 95);

        }
        
        stageImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [stageImageView sd_setImageWithURL:[NSURL URLWithString:imgURLStr]];
        
        [self.scrollView addSubview:stageImageView];
        
    }];
}

- (void)playButtonClick
{
    VideoPlayerController *videoPlayer = [[VideoPlayerController alloc]init];
    
    videoPlayer.mp4_URLString = self.mp4_Url;
    
    [self.getCurrentViewController.navigationController pushViewController:videoPlayer animated:YES];
}

-(void)handleAvatarViewEvent:(UIGestureRecognizer *)gesture
{
    NSInteger index = gesture.view.tag;
    
    if (index == 0) {
        
        [self playButtonClick];
        
        return;
    }
    if (!self.imagePreviewViewController) {
        
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc]init];
        self.imagePreviewViewController.imagePreviewView.delegate = self;
        
    }
    
    
    self.imagePreviewViewController.imagePreviewView.currentImageIndex = index;
    UIImageView *imageView = (UIImageView *)gesture.view;
    _tmpStageImageRect = [imageView convertRect:imageView.frame toView:nil];
    
    [self.getCurrentViewController.navigationController pushViewController:self.imagePreviewViewController animated:YES];
}

#pragma mark - <QMUIImagePreviewViewDelegate>
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView
{
    return _photoURLs.count;
}

-(void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index
{
    NSString *urlStr = [_photoURLs[index] stringByReplacingOccurrencesOfString:@"w.h" withString:@"156.220"];
    NSString *imgURLStr = [[urlStr componentsSeparatedByString:@"@"]firstObject];
    zoomImageView.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:imgURLStr];
}

-(void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location
{
    [self.imagePreviewViewController.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.imagePreviewViewController.navigationController popViewControllerAnimated:YES];
}

@end
