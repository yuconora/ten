//
//  BasicView.h
//  ten_2.0
//
//  Created by qianfeng on 9/9/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreView.h"
#import "BasicModel.h"
#import "SetFont.h"
@interface BasicView : UIViewController
@property (nonatomic,strong) NSString     *hostStr;
@property (nonatomic,strong) MoreView     *mView;
@property (nonatomic,strong) UIScrollView *sc;
@property (nonatomic,assign) BOOL         isOpen;
@property (nonatomic,strong) UILabel      *timeLabel;
@property (nonatomic,strong) UIButton     *moreBtn;
@property (nonatomic,strong) UIImageView  *ima;
@property (nonatomic,strong) UIView       *imaView;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,assign) CGFloat      fontSize;
@property (nonatomic,strong) UIView       *bottomView;
@property (nonatomic,strong) void(^viewBlock)(BasicView *);
- (UIButton *)createRightBtn;
- (UILabel *)creatTimeLabel;
- (void )changeTimeLabelWithPage:(int)page;
- (NSString *)requestHost;
- (void)createSc;
- (void)createBottomViewByView:(UIView *)lastView
                      ByAuthor:(NSString *)author
                andAuthorBrief:(NSString *)authorbrief;
- (CGFloat)getImageHeightWithStr:(NSString *)str;
- (CGFloat)getImageHeightWithUIImageView:(UIImageView *)imgv;
- (void)createUIWithModel:(BasicModel *)model;
- (void)creatAnimation;
- (void)changeScFameByNum:(BOOL)Change;
- (void)setNavColor;
- (void)creatNavItemwithPicStr:(NSString *)str;
- (void)changeSize;
- (CGFloat)setFontWith:(SetFont *)set;
- (void)changeLabelTextWithStr:(NSString *)app_id;
@end
