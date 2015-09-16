//
//  PersonRootVC.m
//  ten_2.0
//
//  Created by qianfeng on 9/9/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "PersonRootVC.h"

@interface PersonRootVC ()

@end

@implementation PersonRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setNavColor {
    
}

#pragma mark - nav返回左边View
- (void)backBtnWithStr:(NSString *)title {
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 40, 40);
    [left addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [left setBackgroundImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 150, 40)];
    label.text = title;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [leftView addSubview:left];
    [leftView addSubview:label];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = item;

}
#pragma mark - 点击事件
- (void)backBtnClick:(UIBarButtonItem *)btn {
    [self.navigationController popViewControllerAnimated:YES];
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
