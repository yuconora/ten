//
//  FavoriteVC.m
//  ten_2.0
//
//  Created by qianfeng on 9/9/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "FavoriteVC.h"
#import "CriticView.h"
#import "CriticRootVC.h"
#import "CriticModel.h"
#import "NovelModel.h"
#import "DiagramModel.h"
#import "NovelView.h"
#import "DiagramView.h"
#import "FavoriteCell.h"
#import "FavoriteModel.h"
#import "DBManager.h"
#import "FVCustomAlertView.h"
@interface FavoriteVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tb;
    NSMutableArray *_dataArray;
    NSMutableArray *_dataSource;
}

@end

@implementation FavoriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [NSMutableArray array];
    [self initDataSource];
    [self createTb];

}
- (void)initDataSource{
    NSMutableArray *cArray = [NSMutableArray array];
    NSMutableArray *nArray = [NSMutableArray array];
    NSMutableArray *dArray = [NSMutableArray array];
    if (_dataSource!=nil) {
        [_dataSource removeAllObjects];
    }
    _dataSource = [NSMutableArray arrayWithArray:[[DBManager shareManager] responseData]];
        for (FavoriteModel *model in _dataSource) {
                NSData *data = [model.dic dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([model.type isEqualToString:@"1"]) {
                    CriticModel *cModel = [[CriticModel alloc] init];
                    [cModel setValuesForKeysWithDictionary:dic];
                    [cArray addObject:cModel];
                }else if ([model.type isEqualToString:@"2"]){
                    NovelModel *nModel = [[NovelModel alloc] init];
                    [nModel setValuesForKeysWithDictionary:dic];
                    [nArray addObject:nModel];
                }else if ([model.type isEqualToString:@"3"]){
                    DiagramModel *dModel = [[DiagramModel alloc] init];
                    [dModel setValuesForKeysWithDictionary:dic];
                    [dArray addObject:dModel];
                }
            }
            _dataArray = [[NSMutableArray alloc]initWithObjects:cArray,nArray,dArray, nil];
//        }
}
- (void)viewWillAppear:(BOOL)animated{
    if (_dataSource.count==0) {
        [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:@"还未收藏"];
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)createTb {
    _tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT) style:UITableViewStylePlain];
    _tb.delegate = self;
    _tb.dataSource = self;
    [self.view addSubview:_tb];
    _tb.tableFooterView = [[UIView alloc]init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"fav";
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FavoriteCell" owner:nil options:nil] lastObject];
    }
    if (indexPath.section==0) {
        CriticModel *model = _dataArray[indexPath.section][indexPath.row];
        NSString *str = [model.text1 substringWithRange:NSMakeRange(0,20)];
        [cell createUIWithStr:model.title andstr:str];
    }else if (indexPath.section==1){
        NovelModel *model = _dataArray[indexPath.section][indexPath.row];
        NSString *str = [model.summary substringWithRange:NSMakeRange(0,20)];
        [cell createUIWithStr:model.title andstr:str];
    }else if (indexPath.section==2){
        DiagramModel *model = _dataArray[indexPath.section][indexPath.row];
        NSString *str = [model.text1 substringWithRange:NSMakeRange(0,20)];
        [cell createUIWithStr:model.title andstr:str];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        CriticView *page = [[CriticView alloc] init];
        [page creatNavItemwithPicStr:@"left"];
        [page creatAnimation];
         CriticModel *model = _dataArray[indexPath.section][indexPath.row];
        [self pushToNextVC:page creatUIWithModel:model];
        [self.navigationController pushViewController:page animated:YES];
    }else if (indexPath.section==1) {
        NovelView *page = [[NovelView alloc] init];
        [page creatNavItemwithPicStr:@"left"];
        [page creatAnimation];
        NovelModel *nModel = _dataArray[indexPath.section][indexPath.row];
        [self pushToNextVC:page creatUIWithModel:nModel];
        [self.navigationController pushViewController:page animated:YES];
    }else if (indexPath.section==2) {
        DiagramView *dPage = [[DiagramView alloc] init];
        [dPage creatNavItemwithPicStr:@"left"];
        [dPage creatAnimation];
        DiagramModel *dModel = _dataArray[indexPath.section][indexPath.row];
        [self pushToNextVC:dPage creatUIWithModel:dModel];
        [self.navigationController pushViewController:dPage animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [[DBManager shareManager]deleteDataWithStr:[_dataArray[indexPath.section][indexPath.row] id]];
        [self initDataSource];
        [_tb deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [_tb reloadData];
    }
}
- (void)pushToNextVC:(BasicView *)Page creatUIWithModel:(BasicModel *)model{
    Page.hidesBottomBarWhenPushed = YES;
    Page.navigationController.navigationBar.translucent = NO;
    Page.timeLabel.text = @"轻轻收藏,安静阅读";
    Page.timeLabel.font = [UIFont systemFontOfSize:12.0f];
    Page.timeLabel.textColor = [UIColor magentaColor];
    [Page changeScFameByNum:YES];
    [Page createUIWithModel:model];
    [Page.ima removeFromSuperview];
    [Page.imaView removeFromSuperview];
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
