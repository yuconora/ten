//
//  CriticView.m
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "CriticView.h"
#import "CriticModel.h"
#import "PlayVC.h"
#import "MoreView.h"
#import "SetFont.h"
#import "DBManager.h"
@interface CriticView ()<UIScrollViewDelegate>{
    CriticModel *_criticModel;
    CGFloat     font;
    UIImageView *_img1;
    UIImageView *_img2;
    UIImageView *_img3;
    UIImageView *_img4;
    UIImageView *_img5;
    UILabel     *_authLabel;
    UILabel     *_text1;
    UILabel     *_text2;
    UILabel     *_text3;
    UILabel     *_text4;
    UILabel     *_text5;
    CGSize      _text1S;
    CGSize      _text2S;
    CGSize      _text3S;
    CGSize      _text4S;
    CGSize      _text5S;
}
@end

@implementation CriticView

- (void)dealloc {
    self.sc    = nil;
    _img1      = nil;
    _img2      = nil;
    _img3      = nil;
    _img4      = nil;
    _img5      = nil;
    _text1     = nil;
    _text2     = nil;
    _text3     = nil;
    _text4     = nil;
    _text5     = nil;
    _authLabel = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSc];
    self.sc.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
#pragma mark - 根据模型创建Ui

- (void)createUIWithModel:(CriticModel*)cModel {
    _criticModel = [[CriticModel alloc]init];
    _criticModel = cModel;
    if (!self.hostStr) {
        self.hostStr = [self requestHost];
    }
    //1.timeLabel
    UILabel *timeLabel = self.timeLabel;
    [self.sc addSubview:timeLabel];
    UIButton *btn = self.moreBtn;
    [self.sc addSubview:btn];
    //2.line
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(timeLabel.frame)+2, SCREEN_WIDTH-40, 2)];
    line1.backgroundColor = [UIColor grayColor];
    [self.sc addSubview:line1];
    //3.imageForToPlay
    UIImageView *imgForPlay = [[UIImageView alloc] init];
    [imgForPlay sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.hostStr,cModel.imageforplay]] placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //
        CGFloat h = [self getImageHeightWithUIImageView:imgForPlay];
        imgForPlay.frame = CGRectMake(20, CGRectGetMaxY(line1.frame)+10, SCREEN_WIDTH-50, h);
        [self.sc addSubview:imgForPlay];
        //3.1playBtn
        UIButton *playBtn = [MyControl createButtonWithFrame:CGRectMake(0, imgForPlay.frame.size.height-50, 50, 50) target:self SEL:@selector(playVidio:) title:nil];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [playBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        playBtn.contentMode = UIViewContentModeScaleAspectFit;
        [imgForPlay addSubview:playBtn];
        imgForPlay.userInteractionEnabled = YES;
        //4.titleLabel
        CGSize title = [Tool strSize:cModel.title
                         withMaxSize:CGSizeMake(imgForPlay.frame.size.width, MAXFLOAT)
                            withFont:[UIFont systemFontOfSize:20.0f]
                   withLineBreakMode:NSLineBreakByClipping];
        UILabel *titleLabel = [MyControl
                               createLabelWithFrame:CGRectMake(imgForPlay.frame.origin.x,CGRectGetMaxY(imgForPlay.frame)+10,imgForPlay.frame.size.width,title.height)
                               Font:20.0f
                               Text:cModel.title];
        [self.sc addSubview:titleLabel];
        //5.authLabel
        _authLabel = [MyControl
                      createLabelWithFrame:CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+5,imgForPlay.frame.size.width,20)
                      Font:12.0f
                      Text:[NSString stringWithFormat:@"作者:%@ | 阅读量:%@",cModel.author,cModel.times]];
        _authLabel.textColor = [UIColor grayColor];
        [self.sc addSubview:_authLabel];

        //6.text1label
        _text1S = [Tool
                   strSize:cModel.text1
                   withMaxSize:CGSizeMake(imgForPlay.frame.size.width, MAXFLOAT)
                   withFont:[UIFont systemFontOfSize:self.fontSize]
                   withLineBreakMode:NSLineBreakByClipping];
        _text1 = [MyControl
                  createLabelWithFrame:CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(_authLabel.frame)+10, imgForPlay.frame.size.width, _text1S.height)
                  Font:self.fontSize
                  Text:cModel.text1];
        [self.sc addSubview:_text1];

        //7.img1

        _img1 = [[UIImageView alloc]init];
        [_img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.hostStr,cModel.image1]] placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //
            CGFloat h1 = [self getImageHeightWithUIImageView:imgForPlay];
            _img1.frame = CGRectMake(20, CGRectGetMaxY(_text1.frame)+10, imgForPlay.frame.size.width, h1);
            [self.sc addSubview:_img1];

            //8.text2
            _text2S = [Tool
                       strSize:cModel.text2
                       withMaxSize:CGSizeMake(imgForPlay.frame.size.width, MAXFLOAT)
                       withFont:[UIFont systemFontOfSize:self.fontSize]
                       withLineBreakMode:NSLineBreakByClipping];
            _text2 = [MyControl
                      createLabelWithFrame:CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(_img1.frame)+10, imgForPlay.frame.size.width, _text2S.height)
                      Font:self.fontSize
                      Text:cModel.text2];
            [self.sc addSubview:_text2];

            //9.img2
            _img2 = [[UIImageView alloc]init];
            [_img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.hostStr,cModel.image2]] placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //
                CGFloat h2 = [self getImageHeightWithUIImageView:_img2];
                _img2.frame = CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(_text2.frame)+10, imgForPlay.frame.size.width, h2);
                [self.sc addSubview:_img2];
                //10.text3
                _text3S = [Tool
                           strSize:cModel.text3
                           withMaxSize:CGSizeMake(imgForPlay.frame.size.width, MAXFLOAT)
                           withFont:[UIFont systemFontOfSize:self.fontSize]
                           withLineBreakMode:NSLineBreakByClipping];
                _text3 = [MyControl
                          createLabelWithFrame:CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(_img2.frame)+10, imgForPlay.frame.size.width, _text3S.height)
                          Font:self.fontSize
                          Text:cModel.text3];
                [self.sc addSubview:_text3];

                //11.img3
                _img3 = [[UIImageView alloc] init];
                [_img3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.hostStr,cModel.image3]] placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    //
                    CGFloat h3 = [self getImageHeightWithUIImageView:_img3];
                    _img3.frame = CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(_text3.frame)+10, imgForPlay.frame.size.width, h3);
                    [self.sc addSubview:_img3];
                    //12.text4
                    _text4S = [Tool
                               strSize:cModel.text4
                               withMaxSize:CGSizeMake(imgForPlay.frame.size.width, MAXFLOAT)
                               withFont:[UIFont systemFontOfSize:self.fontSize]
                               withLineBreakMode:NSLineBreakByClipping];
                    _text4 = [MyControl
                              createLabelWithFrame:CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(_img3.frame)+10, imgForPlay.frame.size.width, _text4S.height)
                              Font:self.fontSize
                              Text:cModel.text4];
                    [self.sc addSubview:_text4];
                    //13.img4
                    _img4 = [[UIImageView alloc] init];
                    [_img4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.hostStr,cModel.image4]] placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        //
                        CGFloat h4 = [self getImageHeightWithUIImageView:_img4];
                        _img4.frame = CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(_text4.frame)+10, imgForPlay.frame.size.width, h4);
                        [self.sc addSubview:_img4];
                        //14.text5
                        _text5S = [Tool
                                   strSize:cModel.text5
                                   withMaxSize:CGSizeMake(imgForPlay.frame.size.width, MAXFLOAT)
                                   withFont:[UIFont systemFontOfSize:self.fontSize]
                                   withLineBreakMode:NSLineBreakByClipping];
                        _text5 = [MyControl
                                  createLabelWithFrame:CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(_img4.frame)+10, imgForPlay.frame.size.width, _text5S.height)
                                  Font:self.fontSize
                                  Text:cModel.text5];
                        [self.sc addSubview:_text5];
                        //15.img5
                        if ([cModel.image5 isEqualToString:@""]) {
                            [self createBottomViewByView:_text5 ByAuthor:cModel.author andAuthorBrief:cModel.authorbrief];
                        }else{
                            _img5 = [[UIImageView alloc] init];
                            [_img5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.hostStr,cModel.image5]] placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                //
                                CGFloat h5 = [self getImageHeightWithUIImageView:_img5];
                                _img5.frame = CGRectMake(imgForPlay.frame.origin.x, CGRectGetMaxY(_text5.frame)+10, imgForPlay.frame.size.width, h5);
                                [self.sc addSubview:_img5];
                                [self createBottomViewByView:_img5 ByAuthor:cModel.author andAuthorBrief:cModel.authorbrief];
                            }];
                        }
                    }];
                }];
            }];

        }];

    }];
}


- (void)viewWillAppear:(BOOL)animated {
    self.fontSize = [self setFontWith:[SetFont shareFont]];
    [self changeLabelTextWithStr:_criticModel.id];
    if (self.fontSize!=_text1.font.pointSize) {
        [self changeAllLabelSize];
    }
}

- (void)changeAllLabelSize{
    _text1S = [self reGetLabelHeightBySize:self.fontSize byLabel:_text1];
    [self setFont:self.fontSize changeHeight:_text1S forView:_text1 changeOrigin:_authLabel];
    [self getFrameFromView:_img1 ByLastView:_text1];
    _text2S = [self reGetLabelHeightBySize:self.fontSize byLabel:_text2];
    [self setFont:self.fontSize changeHeight:_text2S forView:_text2 changeOrigin:_img1];
    [self getFrameFromView:_img2 ByLastView:_text2];
    _text3S = [self reGetLabelHeightBySize:self.fontSize byLabel:_text3];
    [self setFont:self.fontSize changeHeight:_text3S forView:_text3 changeOrigin:_img2];
    [self getFrameFromView:_img3 ByLastView:_text3];
    _text4S = [self reGetLabelHeightBySize:self.fontSize byLabel:_text4];
    [self setFont:self.fontSize changeHeight:_text4S forView:_text4 changeOrigin:_img3];
    [self getFrameFromView:_img4 ByLastView:_text4];
    _text5S = [self reGetLabelHeightBySize:self.fontSize byLabel:_text5];
    [self setFont:self.fontSize changeHeight:_text5S forView:_text5 changeOrigin:_img4];
    [self getFrameFromView:_img5 ByLastView:_text5];
    [self getFrameFromView:self.bottomView ByLastView:_text5];
    self.sc.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.bottomView.frame)+10);
}
- (void)setFont:(CGFloat)Value changeHeight:(CGSize)size forView:(UILabel *)label changeOrigin:(UIView *)view{
    label.font = [UIFont systemFontOfSize:Value];
    CGRect frame = label.frame;
    frame.origin.y = CGRectGetMaxY(view.frame);
    frame.size.height = size.height;
    label.frame = frame;
}
- (void)getFrameFromView:(UIView *)view ByLastView:(UIView *)last{
    CGRect frame2 = view.frame;
    frame2.origin.y = CGRectGetMaxY(last.frame)+10;
    view.frame = frame2;
}
- (CGSize)reGetLabelHeightBySize:(CGFloat)value byLabel:(UILabel *)label{
    return [Tool strSize:label.text
                   withMaxSize:CGSizeMake(label.frame.size.width, MAXFLOAT)
                   withFont:[UIFont systemFontOfSize:self.fontSize]
                   withLineBreakMode:NSLineBreakByClipping];
}

#pragma mark - 按钮点击事件
- (void)playVidio:(UIButton *)btn {
    PlayVC *play = [[PlayVC alloc] init];
    play.VideoUrl = _criticModel.urlforplay;
    play.title = _criticModel.titleforplay;
    play.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:play animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
