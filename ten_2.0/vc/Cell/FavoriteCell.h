//
//  FavoriteCell.h
//  ten_2.0
//
//  Created by qianfeng on 9/11/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *describ;
- (void)createUIWithStr:(NSString *)str andstr:(NSString *)other;
@end
