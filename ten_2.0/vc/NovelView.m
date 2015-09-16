//
//  NovelView.m
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "NovelView.h"
#import "NovelModel.h"
#import "SetFont.h"
@interface NovelView ()<UIScrollViewDelegate>{
    CGSize h;
    UIImageView *_img;
    UILabel *_textLabel;
    NovelModel *_nModel;
}
@property (nonatomic,strong) NSTextStorage *storage;
@end

@implementation NovelView
- (void)dealloc{
    _img = nil;
    _textLabel = nil;
    _nModel = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createSc];
    self.sc.delegate = self;
}
#pragma mark - 根据模型创建Ui
- (void)createUIWithModel:(NovelModel*)model{
    _nModel = [[NovelModel alloc] init];
    _nModel = model;
    //1.timeLabel
    UILabel *timeLabel = self.timeLabel;
    [self.sc addSubview:timeLabel];
    UIButton *btn = self.moreBtn;
    [self.sc addSubview:btn];
    //2.line
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(timeLabel.frame)+2, SCREEN_WIDTH-40, 2)];
    line1.backgroundColor = [UIColor grayColor];
    [self.sc addSubview:line1];
    //3.titleLabel
    CGSize title = [Tool strSize:model.title
                     withMaxSize:CGSizeMake(line1.frame.size.width, MAXFLOAT)
                        withFont:[UIFont systemFontOfSize:20.0f]
               withLineBreakMode:NSLineBreakByClipping];
    UILabel *titleLabel = [MyControl
                           createLabelWithFrame:CGRectMake(line1.frame.origin.x,CGRectGetMaxY(line1.frame)+10,line1.frame.size.width,title.height)
                           Font:20.0f
                           Text:model.title];
    [self.sc addSubview:titleLabel];
    //4.authLabel
    UILabel *authLabel = [MyControl
                          createLabelWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+5,line1.frame.size.width,20)
                          Font:12.0f
                          Text:[NSString stringWithFormat:@"作者:%@ | 阅读量:%@",model.author,model.times]];
    authLabel.textColor = [UIColor grayColor];
    [self.sc addSubview:authLabel];
    //5.summaryLabel
    CGSize h1 = [Tool strSize:model.summary withMaxSize:CGSizeMake(line1.frame.size.width, MAXFLOAT) withFont:[UIFont systemFontOfSize:15.0f] withLineBreakMode:NSLineBreakByClipping];
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(authLabel.frame.origin.x, CGRectGetMaxY(authLabel.frame)+10, line1.frame.size.width, h1.height+40)];
    _img.image = [UIImage imageNamed:@"nav_bg"];
    [self.sc addSubview:_img];
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    left.image = [UIImage imageNamed:@"summary_left"];
    left.contentMode = UIViewContentModeScaleAspectFit;
    [_img addSubview:left];
    UILabel *sumLabel = [MyControl createLabelWithFrame:CGRectMake(10,left.frame.size.height, _img.frame.size.width-30, h1.height) Font:15.0f Text:model.summary];
    sumLabel.text = model.summary;
    sumLabel.textColor = [UIColor colorWithRed:0.068 green:0.535 blue:1.000 alpha:1.000];
    [_img addSubview:sumLabel];
    UIImageView *right = [[UIImageView alloc]initWithFrame:CGRectMake(_img.frame.size.width-30, left.frame.size.height+sumLabel.frame.size.height,30, 20)];
    right.image = [UIImage imageNamed:@"summary_right"];
    right.contentMode = UIViewContentModeScaleAspectFit;
    [_img addSubview:right];
    //6.bigText
    h = [Tool strSize:model.text withMaxSize:CGSizeMake(line1.frame.size.width, MAXFLOAT) withFont:[UIFont systemFontOfSize:self.fontSize] withLineBreakMode:NSLineBreakByClipping];
    _textLabel = [MyControl createLabelWithFrame:CGRectMake(line1.frame.origin.x, CGRectGetMaxY(_img.frame)+10, line1.frame.size.width, h.height) Font:self.fontSize Text:model.text];
    [self.sc addSubview:_textLabel];
    [self createBottomViewByView:_textLabel ByAuthor:model.author andAuthorBrief:model.authorbrief];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fontSize = [self setFontWith:[SetFont shareFont]];
    [self changeLabelTextWithStr:_nModel.id];
    if (_textLabel.font.pointSize!=self.fontSize) {
        [self changeAllLabelSize];
    }
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

- (void)changeAllLabelSize{
    h = [self reGetLabelHeightBySize:self.fontSize byLabel:_textLabel];
    [self setFont:self.fontSize changeHeight:h forView:_textLabel changeOrigin:_img];
    [self getFrameFromView:self.bottomView ByLastView:_textLabel];
    self.sc.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.bottomView.frame)+10);
}

- (void)setFont:(CGFloat)Value changeHeight:(CGSize)size forView:(UILabel *)label changeOrigin:(UIView *)view{
    label.font = [UIFont systemFontOfSize:Value];
    CGRect frame = label.frame;
    frame.origin.y = CGRectGetMaxY(view.frame);
    frame.size.height = size.height;
    label.frame = frame;
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
