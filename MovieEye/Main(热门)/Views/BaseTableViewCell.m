//
//  BaseTableViewCell.m
//  MovieEye
//
//  Created by Rany on 2017/2/16.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)createFromXIB
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];


}

+(instancetype)createFromXIBInTableView:(UITableView *)tableView WithIndentifier:(NSString *)identifier
{

    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
        
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];

        
    }

        
    return cell;

}



@end
