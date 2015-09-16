//
//  SetPageVC.m
//  ten_2.0
//
//  Created by qianfeng on 9/11/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "SetPageVC.h"
#import "SetFont.h"
@interface SetPageVC ()
@property (strong, nonatomic) IBOutlet UILabel *text;
- (IBAction)lager:(id)sender;
- (IBAction)mid:(id)sender;

- (IBAction)small:(id)sender;

@end

@implementation SetPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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

- (IBAction)lager:(id)sender {
    _text.font = [UIFont systemFontOfSize:25.0f];
    [SetFont shareFont].size = _text.font.pointSize;
    NSLog(@"%f",[SetFont shareFont].size);
}

- (IBAction)mid:(id)sender {

    _text.font = [UIFont systemFontOfSize:20.0f];
    [SetFont shareFont].size = _text.font.pointSize;
    NSLog(@"%f",[SetFont shareFont].size);

}
- (IBAction)small:(id)sender {
    _text.font = [UIFont systemFontOfSize:15.0f];
    [SetFont shareFont].size = _text.font.pointSize;
    NSLog(@"%f",[SetFont shareFont].size);
}
@end
