//
//  FilmStillCell.m
//  MovieEye
//
//  Created by Rany on 2017/2/16.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "FilmStillCell.h"
#import "UIButton+WebCache.h"
@implementation FilmStillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setStagePhotoWithPhotos:(NSArray *)photoURLs{
    
    self.scrollView.contentSize = CGSizeMake(110*(photoURLs.count-1)+150+(photoURLs.count+1)*10, self.scrollView.frame.size.height);
    
    [photoURLs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
         NSString *urlStr = [obj stringByReplacingOccurrencesOfString:@"w.h" withString:@"156.220"];
        
        NSString *imgURLStr = [[urlStr componentsSeparatedByString:@"@"]firstObject];
        NSLog(@"%@",imgURLStr);
        UIImageView *stageBtn = [[UIImageView alloc]init];
        stageBtn.contentMode = UIViewContentModeScaleAspectFill;
        stageBtn.clipsToBounds = YES;
        
        if (idx == 0) {
            
            stageBtn.frame = CGRectMake(10, 8, 150, 95);
            
            //添加播放按钮
            UIImageView *imgView = [[UIImageView alloc]initWithImage:IMAGE(@"play")];
            imgView.frame = CGRectMake(CGRectGetMaxX(stageBtn.frame)-50, CGRectGetMaxY(stageBtn.frame)-50, 30, 30);
            [stageBtn addSubview:imgView];
            
        }else if(idx == 1){
            
            stageBtn.frame = CGRectMake(150*idx+20, 8, 110, 95);
        }else{
            
            stageBtn.frame = CGRectMake(110*idx+40+(idx+1)*10, 8, 110, 95);

        }
        
        stageBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [stageBtn sd_setImageWithURL:[NSURL URLWithString:imgURLStr]];
        
        [self.scrollView addSubview:stageBtn];
        
    }];
}
@end
