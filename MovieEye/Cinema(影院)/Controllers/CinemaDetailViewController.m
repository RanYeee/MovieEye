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
    
    MovieCollectionView *collectionView = [[MovieCollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT/4.5)];
    
    collectionView.picUrlArray = @[@"https://imgsa.baidu.com/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=b2a716b3728b4710da22f59ea2a7a898/962bd40735fae6cd738f45f30fb30f2442a70f6c.jpg",@"https://imgsa.baidu.com/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=b2a716b3728b4710da22f59ea2a7a898/962bd40735fae6cd738f45f30fb30f2442a70f6c.jpg",@"https://imgsa.baidu.com/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=b2a716b3728b4710da22f59ea2a7a898/962bd40735fae6cd738f45f30fb30f2442a70f6c.jpg",@"https://imgsa.baidu.com/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=b2a716b3728b4710da22f59ea2a7a898/962bd40735fae6cd738f45f30fb30f2442a70f6c.jpg"];
    
    [self.view addSubview:collectionView];

}


@end
