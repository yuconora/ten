//
//  NovelView.h
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BasicView.h"
@class NovelModel;
@interface NovelView : BasicView
@property (nonatomic,strong) NSString *text;
- (void)createUIWithModel:(NovelModel*)model;
@end
