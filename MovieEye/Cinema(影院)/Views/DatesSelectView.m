//
//  DatesSelectView.m
//  MovieEye
//
//  Created by Rany on 2017/5/22.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "DatesSelectView.h"
#define kItemWidth self.width/4
@interface DatesSelectView ()

{
    UIButton *_previousButton; //上一个按钮
}

@property(nonatomic, strong) UIView *redLineView;

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation DatesSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
    }
    return self;
}

-(void)setItemTitleArray:(NSArray *)itemTitleArray
{
    _itemTitleArray = itemTitleArray;
    
    [self removeButton];
    
    [self addItem];
    
}

-(NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    
    return _buttonArray;
}

- (void)removeButton
{
    for (UIButton *button in self.buttonArray) {
        
        [button removeFromSuperview];
        
    }
}

-(void)setupUI
{
    self.scrollView = [[UIScrollView alloc]init];
    
    [self addSubview:self.scrollView];
    
    self.redLineView = [[UIView alloc]init];
    
    self.redLineView.backgroundColor = [UIColor redColor];
    
    [self.scrollView addSubview:self.redLineView];
    
}


-(void)layoutSubviews
{
    self.redLineView.frame = CGRectMake(0, self.height-1, kItemWidth, 1);
    
    self.scrollView.frame = self.bounds;
}

- (void)addItem
{
    if (_itemTitleArray== nil) {
        
        return;
    }
    
    [_itemTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [button setTitle:obj forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button setTitleColor:CustomRedColor forState:UIControlStateSelected];
        
        if (idx == 0) {
            
            button.selected = YES;
            
            _previousButton = button;
        }
        
        button.tag = idx;
        
        [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(kItemWidth*idx, 0, kItemWidth, self.height-1);
        
        [self.scrollView addSubview:button];
        
        [self.buttonArray addObject:button];
        
    }];
    
    self.scrollView.contentSize = CGSizeMake(kItemWidth*_itemTitleArray.count, 10);
}


- (void)itemClick:(UIButton *)button
{
    _previousButton.selected = !_previousButton.isSelected;
    
    button.selected =  !button.isSelected;
    
    _previousButton = button;
    
    NSInteger index = button.tag;
    
    //scrollview 滚动
    CGRect centerRect = CGRectMake(button.center.x - CGRectGetWidth(self.scrollView.bounds)/2, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));

    [self.scrollView scrollRectToVisible:centerRect animated:YES];

    
    //红色条滑动
    
    [UIView animateWithDuration:0.3 animations:^{
       
        CGRect tmpRect = self.redLineView.frame;
        tmpRect.origin.x = button.frame.origin.x;
        self.redLineView.frame = tmpRect;
        
    }];

    
    if (self.delegate) {
        
        [self.delegate datesSelectView:self didSelectedAtIndex:index];
    }
}

@end
