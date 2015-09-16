//
//  RootViewController.h
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
@property (nonatomic,strong) NSMutableArray       *pages;
@property (nonatomic,strong) UIPageViewController *pageVC;
@property (nonatomic,strong) NSMutableArray       *dataArray;
@property (nonatomic,strong) NSString             *hostStr;
@property (nonatomic,strong) UIImageView          *navImage;
@property (nonatomic,assign) int                  typeNum;
- (void)initPageViewWithViewControllerStr:(NSString *)str withNSInteger:(NSInteger)num;
- (void)creatNavItem;
- (void)setTabColor;
- (void)setNavColor;
- (void)creatNavTitleWithStr:(NSString *)title;
- (void)loadDataByPage:(NSInteger)page WithType:(int)type;

@end
