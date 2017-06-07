//
//  CinemaDetailWebViewController.m
//  MovieEye
//
//  Created by Rany on 2017/5/31.
//  Copyright © 2017年 Rany. All rights reserved.
//

#import "CinemaDetailWebViewController.h"

@interface CinemaDetailWebViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation CinemaDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    NSString *urlString = [NSString stringWithFormat:@"http://m.maoyan.com/shows/%@?_v_=yes",self.cinemaID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [self.webView loadRequest:request];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@">>>> %@",request.URL);
    
    return YES;
}





@end
