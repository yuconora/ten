//
//  FavoriteCell.m
//  ten_2.0
//
//  Created by qianfeng on 9/11/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)createUIWithStr:(NSString *)str andstr:(NSString *)other{
    _title.text = str;
    _describ.text = other;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
