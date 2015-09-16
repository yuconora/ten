//
//  CriticRootVC.m
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "CriticRootVC.h"
#import "CriticView.h"
#import "MainTabBarController.h"
#import "CriticModel.h"
@interface CriticRootVC ()
@end

@implementation CriticRootVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTabColor];
    [self setNavColor];
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    self.dataArray        = [users objectForKey:@"critic"];
    [self initPageViewWithViewControllerStr:@"CriticView" withNSInteger:self.dataArray.count];
    self.typeNum          = 1;
    [self loadDataByPage:0 WithType:self.typeNum];
}

- (void)viewWillAppear:(BOOL)animated {
     [self creatNavItem];
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
