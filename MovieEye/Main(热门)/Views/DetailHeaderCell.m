//
//  DetailHeaderCell.m
//  MovieEye
//
//  Created by Rany on 17/2/13.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "DetailHeaderCell.h"
#import "UIImage+WebP.h"
static BOOL kisOpen = NO;
@interface DetailHeaderCell()

@property (strong, nonatomic) IBOutlet UIButton *downButton;

@end

@implementation DetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.movieImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.movieImageView.layer.borderWidth = 0.5f;
    
    self.imaxLabel.qmui_borderColor = RGB(153, 153, 153);
    
    self.imaxLabel.qmui_borderWidth = 0.5f;
    self.imaxLabel.qmui_borderPosition = QMUIBorderViewPositionTop |QMUIBorderViewPositionRight | QMUIBorderViewPositionBottom;
    
    if (kisOpen) {
        
        _downButton.transform = CGAffineTransformMakeRotation(M_PI);//旋转180度
    }
}

-(void)setInfoDisplayWithDetailInfoModel:(MovieDetailInfoModel *)model
{
    _infoModel = model;
    
    self.nmLabel.text = model.nm;
    self.enmLabel.text = model.enm;
    self.scLabel.text = [NSString stringWithFormat:@"%.1f",model.sc];
    if (model.sc>0) {
        self.starView.value = model.sc/2.0;

    }else{
        self.starView.hidden = YES;
        self.scLabel.hidden = YES;
        self.wishLabel.hidden = NO;
        self.wishLabel.text = [NSString stringWithFormat:@"%d人想看",model.wish];
    }
    self.catLabel.text = model.cat;
    self.durLabel.text = [NSString stringWithFormat:@"%@/%d 分钟",model.src,model.dur];
    self.frtLabel.text = model.pubDesc;
    NSString *snumStr = nil;
    if (model.snum>10000) {
        
        snumStr = [NSString stringWithFormat:@"(%.1f万人评论)",model.snum/10000.0];
    }else{
        
        snumStr = [NSString stringWithFormat:@"(%d人评论)",model.snum];
    }
    self.snumLabel.text = snumStr;
    
    // 3d/imax
    

        if ([model.ver containsString:@"3D"]) {
            
            if ([model.ver containsString:@"3D/IMAX"]){
                
                self._3dLabel.hidden = NO;
                
                self.imaxLabel.hidden = NO;
                
            }else{
                self._3dLabel.hidden = NO;
                
                self.imaxLabel.hidden = YES;
            }

            
        }else if ([model.ver containsString:@"2D"]){
            
            if ([model.ver containsString:@"2D/IMAX"]) {
                
                self._3dLabel.hidden = NO;
                
                self.imaxLabel.hidden = NO;
                
                self._3dLabel.text = @"2D";
                
            }else{
                
                self._3dLabel.hidden = YES;
                
                self.imaxLabel.hidden = YES;
            }
  
        }else{
            
                   }
    
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.draTextView.attributedText = [[NSAttributedString alloc] initWithString:model.dra attributes:attributes];
    NSString *imgURLString = [model.img stringByReplacingOccurrencesOfString:@"w.h" withString:@"156.220"];
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:imgURLString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        self.bgImageView.image = [image qmui_imageWithClippedRect:CGRectMake(0, 0, image.size.width, image.size.height/2)];
        
    }];
    
    
    
}
+(instancetype)createFromXIB
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}
- (IBAction)playVideoButtonClick:(id)sender {
}
- (IBAction)readMoreClick:(UIButton *)sender {
    
    if (self.delegate) {
        
        
        CGFloat textHeight = [self heightForString:_infoModel.dra andWidth:self.bounds.size.width];
        
        if (kisOpen) {
            
            [self.delegate detailHeaderCell:self readMoreClickWithTextHeight:-textHeight];

        }else{
            
            [self.delegate detailHeaderCell:self readMoreClickWithTextHeight:textHeight];

        }
        
        kisOpen = !kisOpen;
        
    }
}


- (float)heightForString:(NSString *)value andWidth:(float)width{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value attributes:attributes];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height -16.0;
}
@end
