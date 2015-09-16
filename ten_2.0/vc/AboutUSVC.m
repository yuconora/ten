//
//  AboutUSVC.m
//  ten_2.0
//
//  Created by qianfeng on 9/9/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "AboutUSVC.h"

@interface AboutUSVC (){
    UIScrollView *_sc;
}


@end

@implementation AboutUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createImg];
}
- (void)createImg{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    UIImage * image = [UIImage imageNamed:@"about_us_bg"] ;
    img.image = image;
    [self.view addSubview:img];
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
