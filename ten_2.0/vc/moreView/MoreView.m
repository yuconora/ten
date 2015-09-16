//
//  MoreView.m
//  ten_2.0
//
//  Created by qianfeng on 9/9/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "MoreView.h"
@implementation MoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)cancel:(UIButton *)sender {
    CGRect frame = self.frame;
    frame.origin.y=SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = frame;
    }];
}
@end
