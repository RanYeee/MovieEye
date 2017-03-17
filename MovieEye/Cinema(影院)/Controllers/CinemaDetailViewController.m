//
//  CinemaDetailViewController.m
//  MovieEye
//
//  Created by Rany on 17/3/8.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaDetailViewController.h"
#import "MovieCollectionView.h"

@interface CinemaDetailViewController ()

@end

@implementation CinemaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    MovieCollectionView *collectionView = [[MovieCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    
    [self.view addSubview:collectionView];

}


@end
