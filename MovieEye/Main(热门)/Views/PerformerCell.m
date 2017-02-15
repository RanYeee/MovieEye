//
//  PerformerCell.m
//  MovieEye
//
//  Created by Rany on 17/2/15.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "PerformerCell.h"
#define kSpacing 10.0f
@implementation PerformerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self addPerformerInfoWithData:nil];
}
+(instancetype)createFromXIB
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

- (void)addPerformerInfoWithDatas:(NSArray *)actorsList
{
    [self.scrollView setContentSize:CGSizeMake(80*actorsList.count+kSpacing, self.scrollView.frame.size.height)];
    
    [actorsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
       
        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *imgURLString = [obj[@"avatar"] stringByReplacingOccurrencesOfString:@"w.h" withString:@"156.220"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgURLString]];
        imageView.frame = CGRectMake(i*80+kSpacing, 8, 70, 90);
        imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.scrollView addSubview:imageView];
        
        UILabel *cnmLabel = [[UILabel alloc]init];
        cnmLabel.font = [UIFont systemFontOfSize:12];
        cnmLabel.textAlignment = NSTextAlignmentCenter;
        cnmLabel.frame = CGRectMake(i*80+kSpacing, CGRectGetMaxY(imageView.frame)+5, 70, 18);
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

@end
