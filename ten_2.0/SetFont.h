//
//  SetFont.h
//  ten_2.0
//
//  Created by qianfeng on 9/12/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetFont : NSObject
@property (nonatomic,assign) CGFloat size;
+ (SetFont *)shareFont;
- (CGFloat)setFontSize;
@end
