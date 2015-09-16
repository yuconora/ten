//
//  PlayVC.m
//  ten_2.0
//
//  Created by qianfeng on 9/9/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "PlayVC.h"

@interface PlayVC (){
    UIWebView *_web;
}

@end

@implementation PlayVC

- (void)dealloc {
    _web = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createWeb];
    [self creatNavLeftBtn];

}
#pragma mark - 创造nav返回按钮
- (void)creatNavLeftBtn {
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 40, 40);
    [left addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [left setBackgroundImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = item;
}
#pragma mark - 点击事件
- (void)backBtnClick:(UIBarButtonItem *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 创造webView 
- (void)createWeb {
    _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT)];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.VideoUrl]];
    [self.view addSubview:_web];
    [_web loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
