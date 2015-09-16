//
//  DBManager.h
//  ten_2.0
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 __None__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteModel.h"
@interface DBManager : NSObject
+ (DBManager *)shareManager;
- (BOOL)isExistsDataWithStr:(NSString *)app_id;
- (BOOL)isExistsDataWithModel:(FavoriteModel *)model;
- (BOOL)insertDataWithModel:(FavoriteModel *)model;
- (BOOL)deleteDataWithModel:(FavoriteModel *)model;
- (BOOL)deleteDataWithStr:(NSString *)app_id;
- (NSArray *)responseData;
@end
