//
//  MainTabBarController.m
//  Ten
//
//  Created by qianfeng on 9/6/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "MainTabBarController.h"
#import "RootViewController.h"
#import "CriticBaseModel.h"
#import "NovelBaseModel.h"
#import "DiagramBaseModel.h"
#import "CriticRootVC.h"
#import "ADModel.h"
#import "FVCustomAlertView.h"
@interface MainTabBarController ()<UITabBarControllerDelegate>{
    NSMutableArray *_tabArray;
    UIImageView *img;
    NSMutableArray *_dataSource;
    ADModel *_model;
    UIImageView *_ima;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tabArray = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self loadData];
//    [self checkNetWorking];

}
#pragma mark - 获取图片host头
- (NSString *)requestHost {
    return @"http://images.shigeten.net/";
}

#pragma mark - 创造tabBar下面的黑条
- (void)createImage {
    img = [[UIImageView alloc] initWithFrame:CGRectMake(20, TAB_HEIGHT-5, SCREEN_WIDTH/self.viewControllers.count-10*self.viewControllers.count, 5)];
    img.backgroundColor = [UIColor blackColor];
    [self.tabBar addSubview:img];
}

#pragma mark - tabBar代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    switch (viewController.tabBarItem.tag-400) {
        case 0:{
            [self createImageViewWithInt:0];
        }
            break;
        case 1:{
            [self createImageViewWithInt:1];
        }
            break;
        case 2:{
            [self createImageViewWithInt:2];
        }
            break;
        case 3:{
            [self createImageViewWithInt:3];
        }
            break;
    }
    
}

#pragma mark - 改变黑条frame
- (void)createImageViewWithInt:(int)Int {
    CGRect frame = img.frame;
    frame.origin.x = Int *SCREEN_WIDTH/self.viewControllers.count+20;
    img.frame = frame;
}
#pragma mark - 获取网络数据
- (void)loadData {
    [self initTabBar];
    [self createImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *url                  = @[CRITIC_URL,NOVEL_URL,DIAGRAM_URL];
        NSMutableArray *_criticArray  = [NSMutableArray array];
        NSMutableArray *_novelArray   = [NSMutableArray array];
        NSMutableArray *_diagramArray = [NSMutableArray array];
        for (int i = 0; i<url.count; i++) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url[i]]];
            if (data){
                id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (i==0) {
                    for (NSDictionary *d in responseObject[@"result"]) {
                        CriticBaseModel *cModel = [[CriticBaseModel alloc] init];
                        [cModel setValuesForKeysWithDictionary:d];
                        [_criticArray addObject:cModel.id];
                    }
                }else if (i==1){
                    for (NSDictionary *d in responseObject[@"result"]) {
                        NovelBaseModel *nModel = [[NovelBaseModel alloc] init];
                        [nModel setValuesForKeysWithDictionary:d];
                        [_novelArray addObject:nModel.id];
                    }
                }else{
                    for (NSDictionary *d in responseObject[@"result"]) {
                        DiagramBaseModel *dModel = [[DiagramBaseModel alloc] init];
                        [dModel setValuesForKeysWithDictionary:d];
                        [_diagramArray addObject:dModel.id];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataSource = [[NSMutableArray alloc]initWithObjects:_criticArray,_novelArray,_diagramArray, nil];
            NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
            [users setObject:_criticArray forKey:@"critic"];
            [users setObject:_novelArray forKey:@"novel"];
            [users setObject:_diagramArray forKey:@"diagram"];
            [users synchronize];
            self.delegate = self;

        });
    });
}

#pragma mark - 实例化tabbar
- (void)initTabBar {
    NSArray *ViewController = @[@"CriticRootVC",
                                @"NovelRootVC",
                                @"DiagramRootVC",
                                @"PersonVC"];
    for (int i=0; i<4; i++) {
        if (i!=3) {
        RootViewController *viewControl = [[NSClassFromString(ViewController[i]) alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewControl];
            [_tabArray addObject:nav];
        }else {
            UIViewController *viewControl = [[NSClassFromString(ViewController[i]) alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewControl];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
            [_tabArray addObject:nav];
        }
    }
    self.selectedIndex = 0;
    self.viewControllers = _tabArray;
    [self addTabBarImage];
}

#pragma mark - 给tabbar添加图片
- (void)addTabBarImage {
    if (self.viewControllers.count>4) {
        return;
    }
    NSArray *ima = @[@"home_critic.png",
                     @"home_novel.png",
                     @"home_diagram.png",
                     @"home_personal.png"];
    NSArray *imaSelect = @[@"home_critic_focus.png",
                           @"home_novel_focus.png",
                           @"home_diagram_focus.png",
                           @"home_personal_focus.png"];
    for (int i=0; i<self.viewControllers.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        item.image = [[UIImage imageNamed:ima[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:imaSelect[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.tag = 400+i;
    }
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
