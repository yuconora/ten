//
//  MoreView.h
//  ten_2.0
//
//  Created by qianfeng on 9/9/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreView;
@interface MoreView : UIView

@property (strong, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (strong, nonatomic) IBOutlet UIButton *share;
@property (strong, nonatomic) IBOutlet UILabel *favoriteLabel;
- (IBAction)cancel:(UIButton *)sender;
@end
