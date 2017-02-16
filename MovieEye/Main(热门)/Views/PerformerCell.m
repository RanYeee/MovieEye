//
//  PerformerCell.m
//  MovieEye
//
//  Created by Rany on 17/2/15.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "PerformerCell.h"
#import "UIButton+WebCache.h"
#define kSpacing 10.0f

@interface PerformerCell()<QMUIImagePreviewViewDelegate>
{
    CGRect _tmpAvatarBtnRect;
}
@property(nonatomic, copy) NSArray *actorsList;

@property(nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;

@end

@implementation PerformerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self addPerformerInfoWithData:nil];
}


- (void)addPerformerInfoWithDatas:(NSArray *)actorsList
{
    _actorsList = actorsList;
    
    [self.scrollView setContentSize:CGSizeMake(80*actorsList.count+kSpacing, self.scrollView.frame.size.height)];
    
    [actorsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
       
        UIButton *avatarButton = [[UIButton alloc]init];

        avatarButton.tag = i;
        
        [avatarButton addTarget:self action:@selector(handleAvatarViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *imgURLString = [obj[@"avatar"] stringByReplacingOccurrencesOfString:@"w.h" withString:@"156.220"];
        avatarButton.contentMode = UIViewContentModeScaleAspectFill;
        [avatarButton sd_setImageWithURL:[NSURL URLWithString:imgURLString] forState:UIControlStateNormal];
        
        avatarButton.frame = CGRectMake(i*80+kSpacing, 8, 70, 90);
        avatarButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.scrollView addSubview:avatarButton];
        
        UILabel *cnmLabel = [[UILabel alloc]init];
        cnmLabel.font = [UIFont systemFontOfSize:12];
        cnmLabel.textAlignment = NSTextAlignmentCenter;
        cnmLabel.frame = CGRectMake(i*80+kSpacing, CGRectGetMaxY(avatarButton.frame)+5, 70, 18);
        cnmLabel.text = obj[@"cnm"];
        [self.scrollView addSubview:cnmLabel];
        
        UILabel *rolesLabel = [[UILabel alloc]init];
        rolesLabel.textColor = [UIColor lightGrayColor];
        rolesLabel.font = [UIFont systemFontOfSize:12];
        rolesLabel.textAlignment = NSTextAlignmentCenter;
        rolesLabel.frame = CGRectMake(i*80+kSpacing, CGRectGetMaxY(cnmLabel.frame), 70, 18);
        if (i == 0) {
            //第一位是导演
            rolesLabel.text = @"导演";
        }else{
            
            rolesLabel.text = obj[@"roles"]?:@"演员";

        }
        [self.scrollView addSubview:rolesLabel];

    }];
    

    
}

-(void)handleAvatarViewEvent:(UIButton *)button
{
    if (!self.imagePreviewViewController) {
        
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc]init];
        self.imagePreviewViewController.imagePreviewView.delegate = self;
      
    }
    
 
    self.imagePreviewViewController.imagePreviewView.currentImageIndex = button.tag;
    
    _tmpAvatarBtnRect = [button convertRect:button.imageView.frame toView:nil];
    
    [self.imagePreviewViewController startPreviewFromRectInScreen:_tmpAvatarBtnRect];
}

#pragma mark - <QMUIImagePreviewViewDelegate>
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView
{
    return _actorsList.count;
}

-(void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index
{
    NSString *imgURLStr = [_actorsList[index][@"avatar"]stringByReplacingOccurrencesOfString:@"w.h" withString:@"156.220"];
    zoomImageView.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:imgURLStr];
}

-(void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location
{
    [self.imagePreviewViewController endPreviewToRectInScreen:_tmpAvatarBtnRect];
}

@end
