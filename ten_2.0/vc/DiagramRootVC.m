//
//  DiagramRootVC.m
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "DiagramRootVC.h"
#import "DiagramView.h"
@interface DiagramRootVC ()
@end

@implementation DiagramRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPageViewWithViewControllerStr:@"DiagramView" withNSInteger:10];
    [self creatNavTitleWithStr:@"美图"];
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    self.dataArray = [users objectForKey:@"diagram"];
    [self initPageViewWithViewControllerStr:@"DiagramView" withNSInteger:self.dataArray.count];
    self.typeNum = 3;
    [self loadDataByPage:0 WithType:self.typeNum];
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
