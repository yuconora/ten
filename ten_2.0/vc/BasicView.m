//
//  BasicView.m
//  ten_2.0
//
//  Created by qianfeng on 9/9/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "BasicView.h"
#import "CriticModel.h"
#import "DBManager.h"
@interface BasicView ()<UIScrollViewDelegate>

@end

@implementation BasicView

- (void)dealloc {
    _mView     = nil;
    _sc        = nil;
    _timeLabel = nil;
    _moreBtn   = nil;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timeLabel = [self creatTimeLabel];
    self.moreBtn   = [self createRightBtn];
    self.mView     = [[[NSBundle mainBundle] loadNibNamed:@"MoreView" owner:nil options:nil] lastObject];
    if (self.viewBlock) {
        self.viewBlock(self);
    }
}

- (void)changeLabelTextWithStr:(NSString *)app_id{
    BOOL isContain = [[DBManager shareManager]isExistsDataWithStr:app_id];
    if (isContain) {
        self.mView.favoriteLabel.text = @"已收藏";
    }else{
        self.mView.favoriteLabel.text = @"收藏";
    }
}
- (void)setNavColor {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 获取图片高度
- (CGFloat)getImageHeightWithStr:(NSString *)str {
    UIImage *image = [UIImage imageWithData:
                      [NSData dataWithContentsOfURL:
                       [NSURL URLWithString:
                        [NSString stringWithFormat:@"%@%@",self.hostStr,str]]]];
    return SCREEN_WIDTH/image.size.width*image.size.height;
}

- (CGFloat)getImageHeightWithUIImageView:(UIImageView *)imgv{
    return SCREEN_WIDTH/imgv.image.size.width*imgv.image.size.height;
}
- (void)changeScFameByNum:(BOOL)Change{
    if (Change){
        CGRect frame = self.sc.frame;
        frame.size.height = SCREEN_HEIGHT-NAV_HEIGHT;
        self.sc.frame = frame;
    }
}
#pragma mark - 创建页面下方图片栏
- (void)createBottomViewByView:(UIView *)lastView ByAuthor:(NSString *)author andAuthorBrief:(NSString *)authorbrief{
    //1.创建下面的线条
    self.bottomView = [[UIView alloc] init];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 2)];
    line2.backgroundColor = [UIColor grayColor];
    [self.bottomView addSubview:line2];
    //2.创建作者信息Label
    UILabel *nameLabel = [MyControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(line2.frame)+2, SCREEN_WIDTH-40, 20) Font:20.0f Text:author];
    [self.bottomView addSubview:nameLabel];
    //3.创建作者简介Label
    CGSize d = [Tool strSize:authorbrief withMaxSize:CGSizeMake(nameLabel.frame.size.width, MAXFLOAT) withFont:[UIFont systemFontOfSize:15.0f] withLineBreakMode:NSLineBreakByClipping];
    UILabel *detailLabel = [MyControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(nameLabel.frame)+5, SCREEN_WIDTH-40, d.height) Font:15.0f Text:authorbrief];
    detailLabel.textColor = [UIColor grayColor];
    [self.bottomView addSubview:detailLabel];
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(lastView.frame)+30, SCREEN_WIDTH, line2.frame.size.height+nameLabel.frame.size.height+detailLabel.frame.size.height);
    [self.sc addSubview:self.bottomView];
    //设置sc的contentSize
    self.sc.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.bottomView.frame)+20);
}
#pragma mark - 获取图片host头
- (NSString *)requestHost {
    return @"http://images.shigeten.net/";
}
#pragma mark - 创建sc
- (void)createSc {
    self.sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)];
    [self.view addSubview:self.sc];
}
- (CGFloat)setFontWith:(SetFont *)set{
    return set.size?set.size:15.0f;
}
#pragma mark - 创建timeLabel
- (UILabel *)creatTimeLabel{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, 40)];
    return timeLabel;
}
- (void )changeTimeLabelWithPage:(int)page {
    NSDate *date = [NSDate date];
    NSDate *newDate = [NSDate dateWithTimeInterval:-24*60*60*page sinceDate:date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy.MM.dd"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[format stringFromDate:newDate]];
    self.timeLabel.textColor = [UIColor grayColor];
}

#pragma mark - 创建右边MoreBtn
- (UIButton *)createRightBtn {
    UIButton *btn = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH-50, 10, 40, 20) target:self SEL:@selector(btnClick) title:nil];
    [btn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"more_selected"] forState:UIControlStateSelected];
    btn.contentMode = UIViewContentModeScaleAspectFit;
    return btn;
}
#pragma mark - btn点击事件
- (void)btnClick{
    self.isOpen = !self.isOpen;
    self.mView.frame = CGRectMake(0, SCREEN_HEIGHT-180, SCREEN_WIDTH, 180);
    CGRect frame = self.mView.frame;
    self.isOpen?(frame.origin.y = SCREEN_HEIGHT-180):(frame.origin.y=SCREEN_HEIGHT);
    self.mView.frame = frame;
    CATransition *tran = [CATransition animation];
    tran.delegate = self;
    tran.duration = 0.5;
    tran.type = kCATransitionPush;
    self.isOpen?(tran.subtype = kCATransitionFromTop):(tran.subtype = kCATransitionFromBottom);
    [self.mView.layer addAnimation:tran forKey:nil];
    [self.tabBarController.view addSubview:self.mView];
}
#pragma mark - 创造nav子控件
- (void)creatNavItemwithPicStr:(NSString *)str{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 0, 30, 40);
    [btn setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)leftBarButtonItemClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUIWithModel:(BasicModel *)model{

}
#pragma mark - 创造动画
- (void)creatAnimation {
    self.imaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)];
    self.imaView.backgroundColor = [UIColor whiteColor];
    self.ima = [[UIImageView alloc] initWithFrame:CGRectMake(self.imaView.center.x-22, self.imaView.center.y-22, 44, 44)];
    NSArray *arr =  [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"plist"]];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *imageName in arr) {
        [array addObject:[UIImage imageNamed:imageName]];
    }
    [self.ima setAnimationImages:[NSArray arrayWithArray:array]];
    [self.ima setAnimationRepeatCount:0];
    [self.ima startAnimating];
    [self.imaView addSubview:self.ima];
    [self.view addSubview:self.imaView];
}
#pragma mark - sc代理事件
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self changeFrame];
}
#pragma mark - 页面消失动作
- (void)viewWillDisappear:(BOOL)animated {
    [self changeFrame];
}
#pragma mark - 控制分享窗口的收回
- (void)changeFrame {
    CGRect frame = self.mView.frame;
    frame.origin.y=SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        self.mView.frame = frame;
    }];
    self.isOpen = NO;
}
#pragma mark - changeSize
- (void)changeSize{
   self.fontSize = [SetFont shareFont].size;
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
