//
//  SetFont.m
//  ten_2.0
//
//  Created by qianfeng on 9/12/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "SetFont.h"

@implementation SetFont

+ (SetFont *)shareFont{
    static SetFont *_set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_set==nil) {
            _set = [[SetFont alloc]init];
        }
    });
    return _set;
}

- (CGFloat)setFontSize{
    return _size;
}
@end
