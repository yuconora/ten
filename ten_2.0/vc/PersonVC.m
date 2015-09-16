//
//  PersonVC.m
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "PersonVC.h"
#import "FavoriteVC.h"
#import "SetPageVC.h"
#import "AboutUSVC.h"
#import "FeedBackVC.h"

@interface PersonVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tb;
    NSArray *_picArray;
    NSArray *_titleArray;
}

@end

@implementation PersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self creatNavTitleWithStr:@"个人中心"];
    _picArray   = @[@"setting_favorite",
                    @"setting_font",
                    @"setting_aboutus",
                    @"setting_feedback"];
    _titleArray = @[@"我的收藏",
                    @"设置",
                    @"关于十个",
                    @"意见反馈"];
    [self createTab];
}
#pragma mark - 创建tb
- (void)createTab {
    _tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT) style:UITableViewStylePlain];
    _tb.dataSource      = self;
    _tb.delegate        = self;
    [self.view addSubview:_tb];
    _tb.tableFooterView = [[UIView alloc]init];
}

#pragma mark - tab代理相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _picArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
    cell                  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.imageView.image  = [UIImage imageNamed:_picArray[indexPath.row]];
    cell.textLabel.text   = _titleArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        FavoriteVC *f = [[FavoriteVC alloc] init];
        f.hidesBottomBarWhenPushed = YES;
        [f backBtnWithStr:@"收藏"];
        [self.navigationController pushViewController:f animated:YES];
    }else if (indexPath.row==1){
        SetPageVC *s = [[SetPageVC alloc] init];
        [s backBtnWithStr:_titleArray[indexPath.row]];
        [self.navigationController pushViewController:s animated:YES];
    }else if (indexPath.row==2){
        AboutUSVC *a = [[AboutUSVC alloc] init];
        a.hidesBottomBarWhenPushed = YES;
        [a backBtnWithStr:@"关于我们"];
        [self.navigationController pushViewController:a animated:YES];
    }else{
        FeedBackVC *fe = [[FeedBackVC alloc] init];
        fe.hidesBottomBarWhenPushed = YES;
        [fe backBtnWithStr:_titleArray[indexPath.row]];
        [self.navigationController pushViewController:fe animated:YES];
    }
}
#pragma mark - 创建nav子控件
- (void)creatNavTitleWithStr:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 40)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.text = title;
    label.font = [UIFont systemFontOfSize:20.0f];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.leftBarButtonItem = item;

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
