//
//  DiagramView.m
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "DiagramView.h"
#import "DiagramModel.h"
@interface DiagramView ()<UIScrollViewDelegate,SDWebImageManagerDelegate>{
    DiagramModel *_dModel;

}

@end

@implementation DiagramView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSc];
    self.sc.delegate          = self;

}
#pragma mark - 根据模型创建ui
- (void)createUIWithModel:(DiagramModel*)model{
    _dModel = [[DiagramModel alloc] init];
    _dModel = model;
    if (!self.hostStr) {
    self.hostStr          = [self requestHost];
    }
    //1.timeLabel
    UILabel *timeLabel    = self.timeLabel;
    [self.sc addSubview:timeLabel];
    UIButton *btn         = self.moreBtn;
    [self.sc addSubview:btn];
    //2.line
    UIView *line1         = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(timeLabel.frame)+2, SCREEN_WIDTH-40, 2)];
    line1.backgroundColor = [UIColor grayColor];
    [self.sc addSubview:line1];
    //3.image
    UIImageView *img      = [[UIImageView alloc] init];
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.hostStr,model.image1]] placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //
        CGFloat h = [self getImageHeightWithUIImageView:img];
        img.frame = CGRectMake(line1.frame.origin.x, CGRectGetMaxY(line1.frame)+10, line1.frame.size.width, h);
        [self.sc addSubview:img];
        //4.label1
        CGSize h2             = [Tool strSize:model.text1 withMaxSize:CGSizeMake(line1.frame.size.width, MAXFLOAT) withFont:[UIFont systemFontOfSize:12.0f] withLineBreakMode:NSLineBreakByClipping];
        UILabel *label1       = [MyControl createLabelWithFrame:CGRectMake(line1.frame.origin.x, CGRectGetMaxY(img.frame)+10, line1.frame.size.width, h2.height) Font:12.0f Text:model.text1];
        [self.sc addSubview:label1];

        //5.label2
        CGSize h3             = [Tool strSize:model.text2 withMaxSize:CGSizeMake(line1.frame.size.width, MAXFLOAT) withFont:[UIFont systemFontOfSize:12.0f] withLineBreakMode:NSLineBreakByClipping];
        UILabel *label2       = [MyControl createLabelWithFrame:CGRectMake(line1.frame.size.width-h3.width, CGRectGetMaxY(label1.frame)+5, line1.frame.size.width, h3.height) Font:12.0f Text:model.text2];
        [self.sc addSubview:label2];

        //6.bottom
        [self createBottomViewByView:label2 ByAuthor:model.author andAuthorBrief:model.authorbrief];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [self changeLabelTextWithStr:_dModel.id];
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
