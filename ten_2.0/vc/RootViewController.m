//
//  RootViewController.m
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "RootViewController.h"
#import "CriticModel.h"
#import "CriticView.h"
#import "NovelModel.h"
#import "NovelView.h"
#import "DiagramModel.h"
#import "DiagramView.h"
#import "BasicView.h"
#import "MoreView.h"
#import "FavoriteModel.h"
#import "SetFont.h"
#import "DBManager.h"
#import "FavoriteModel.h"
#import "FVCustomAlertView.h"
#import "UMSocial.h"
@interface RootViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIGestureRecognizerDelegate,UMSocialUIDelegate>{
    NSInteger       current;
    UIScrollView    *_sc;
    NSMutableArray  *_cModelArray;
    NSMutableArray  *_nModelArray;
    NSMutableArray  *_dModelArray;
    NSMutableArray  *_refreshArray;
    UIImageView     *_ima;
    UIView          *_imaView;
    CriticModel     *_cModel;
    NovelModel      *_nModel;
    DiagramModel    *_dModel;
    BOOL            _isFav;
    FavoriteModel   *_fModel;
    NSData          *_jsData;
    NSString        *_jsonStr;
    NSString        *_shareStr;
}

@end

@implementation RootViewController
- (void)dealloc {
    _sc           = nil;
    _cModelArray  = nil;
    _nModelArray  = nil;
    _dModelArray  = nil;
    _refreshArray = nil;
    _ima          = nil;
    _imaView      = nil;
    _pages        = nil;
    _pageVC       = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavColor];
    _dataArray    = [NSMutableArray alloc];
    _refreshArray = [NSMutableArray array];
    _cModelArray  = [NSMutableArray array];
    _nModelArray  = [NSMutableArray array];
    _dModelArray  = [NSMutableArray array];
}

#pragma mark - 初始化pageViewControl
- (void)initPageViewWithViewControllerStr:(NSString *)str withNSInteger:(NSInteger)num {
    _pages  = [NSMutableArray array];
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    for (NSInteger i=0; i<num; i++) {
        BasicView *viewController = [[NSClassFromString(str) alloc] init];
        [viewController changeTimeLabelWithPage:(int)i];
        [self.pages addObject:viewController];
        viewController.viewBlock = ^(BasicView *bView){
            [bView.mView.favoriteBtn addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
            [bView.mView.share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
            [bView changeTimeLabelWithPage:(int)i];
            bView.mView.favoriteBtn.tag = i+100;
            bView.mView.favoriteLabel.tag = i+200;
        };
        [_refreshArray addObject:[NSNumber numberWithBool:NO]];
    }
    self.pageVC.delegate      = self;
    self.pageVC.dataSource    = self;
    BasicView *viewController = self.pages[0];
    [_pageVC setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        //
    }];
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    self.pageVC.view.frame = self.view.bounds;
    [self.pageVC didMoveToParentViewController:self];

}

- (void)share:(UIButton *)btn{
    switch (self.typeNum) {
        case 1:{
            _shareStr = [NSString stringWithFormat:@"%@%@%@......",@"我在<十个>上面读到一篇好影评,你也来看看吧^_^",_cModel.title,_cModel.text1];

        }
            break;
        case 2:{
            _shareStr = [NSString stringWithFormat:@"%@%@%@......",@"我在<十个>上面读到一篇好文章,你也来看看吧^_^",_nModel.title,_nModel.summary];
        }
            break;
        case 3:{
            _shareStr = [NSString stringWithFormat:@"%@%@%@",@"我在<十个>上面读到一张美图,你也来看看吧^_^......",_dModel.title,_dModel.text1];
        }
            break;
    }
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:APPKEY
                                      shareText:_shareStr
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:self];
}
- (void)favorite:(UIButton *)btn {
    UILabel *label = (UILabel *)[btn.superview viewWithTag:btn.tag+100];
    _fModel = [[FavoriteModel alloc] init];
    switch (self.typeNum) {
        case 1:
        {
            NSDictionary *dic = [_cModelArray[(int)btn.tag-100] keyValues];
            NSError *error = nil;
            _jsData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            _jsonStr = [[NSString alloc] initWithData:_jsData encoding:NSUTF8StringEncoding];

        }
            break;
        case 2:
        {
            NSDictionary *dic = [_nModelArray[(int)btn.tag-100] keyValues];
            NSError *error = nil;
            _jsData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            _jsonStr = [[NSString alloc] initWithData:_jsData encoding:NSUTF8StringEncoding];
        }
            break;
        case 3:
        {
            NSDictionary *dic = [_dModelArray[(int)btn.tag-100] keyValues];
            NSError *error = nil;
            _jsData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            _jsonStr = [[NSString alloc] initWithData:_jsData encoding:NSUTF8StringEncoding];
        }
            break;
    }
    _fModel.app_id = self.dataArray[(int)btn.tag-100];
    _fModel.type = [NSString stringWithFormat:@"%d",self.typeNum];
    _fModel.dic = _jsonStr;
    _isFav = [[DBManager shareManager] isExistsDataWithModel:_fModel];
    btn.selected = _isFav;
    !_isFav?[[DBManager shareManager] insertDataWithModel:_fModel]:[[DBManager shareManager] deleteDataWithModel:_fModel];
    if (!_isFav) {
        label.text = @"已收藏";
    }else{
        label.text = @"收藏";
    }
}

#pragma mark - 创造nav子控件
- (void)creatNavItem {
    _navImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 60, 40)];
    _navImage.image = [UIImage imageNamed:@"nav_left"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_navImage];
    self.navigationItem.leftBarButtonItem = item;
}
#pragma mark - 设置tabbar颜色
- (void)setTabColor {
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"]] ;
}
#pragma mark - 设置nav颜色
- (void)setNavColor {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}
#pragma mark - 创造nav title
- (void)creatNavTitleWithStr:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 40)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.text = title;
    label.font = [UIFont systemFontOfSize:20.0f];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.leftBarButtonItem = item;
}
#pragma mark - pageViewControl 代理 相关
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger pageNumber = [self.pages indexOfObject:viewController] - 1;
    current              = pageNumber+1;
    return (pageNumber >= 0) ? self.pages[pageNumber] : nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger pageNumber = [self.pages indexOfObject:viewController] + 1;
    return (pageNumber < self.pages.count) ? self.pages[pageNumber] : nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    NSInteger page =[self.pages indexOfObject:[pendingViewControllers firstObject]];
    if (![_refreshArray[(int)page] boolValue]) {
        [self loadDataByPage:page WithType:_typeNum];
    }
}

#pragma mark - 从网络获取数据源
- (void)loadDataByPage:(NSInteger)page WithType:(int)type{
    [_refreshArray replaceObjectAtIndex:(int)page withObject:[NSNumber numberWithBool:YES]];
    [self creatAnimation];
    NSDictionary *dic = @{@"id":self.dataArray[(int)page]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        switch (type) {
            case 1:
            {
                [manager GET:CRITIC_URL_INFO parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    _cModel = [[CriticModel alloc] init];
                    [_cModel setValuesForKeysWithDictionary:responseObject];
                    CriticView *view = self.pages[(int)page];
                    [view createUIWithModel:_cModel];
                    [_cModelArray addObject:_cModel];
                    [_ima removeFromSuperview];
                    [_imaView removeFromSuperview];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
                break;
            case 2:
            {
                [manager GET:NOVEL_URL_INFO parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    _nModel = [[NovelModel alloc] init];
                    [_nModel setValuesForKeysWithDictionary:responseObject];
                    NovelView *view = self.pages[(int)page];
                    [view createUIWithModel:_nModel];
                    [_nModelArray addObject:_nModel];
                    [_ima removeFromSuperview];
                    [_imaView removeFromSuperview];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
                break;
            case 3:
            {
                [manager GET:DIAGRAM_URL_INFO parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    _dModel = [[DiagramModel alloc] init];
                    [_dModel setValuesForKeysWithDictionary:responseObject];
                    DiagramView *view = self.pages[(int)page];
                    [view createUIWithModel:_dModel];
                    [_dModelArray addObject:_dModel];
                    [_ima removeFromSuperview];
                    [_imaView removeFromSuperview];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:@"无法连接网络"];
                }];
            }
                break;
    }
}

#pragma mark - 创造等待视图动画
- (void)creatAnimation {
    _imaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)];
    _imaView.backgroundColor = [UIColor whiteColor];
    _ima = [[UIImageView alloc] initWithFrame:CGRectMake(_imaView.center.x-22, _imaView.center.y-22, 44, 44)];
    NSArray *arr =  [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"plist"]];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *imageName in arr) {
        [array addObject:[UIImage imageNamed:imageName]];
    }
    [_ima setAnimationImages:[NSArray arrayWithArray:array]];
    [_ima setAnimationRepeatCount:0];
    [_ima startAnimating];
    [_imaView addSubview:_ima];
    [self.view addSubview:_imaView];

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
