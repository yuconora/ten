//
//  DBManager.m
//  ten_2.0
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 __None__. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
@implementation DBManager{
    FMDatabase *_fmdb;
}
+(DBManager *)shareManager{
    static DBManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_manager==nil) {
            _manager = [[DBManager alloc] init];
        }
    });
    return _manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //NSHomeDirectory() 得到了三个文件夹
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/ten.db"];
        _fmdb = [[FMDatabase alloc]initWithPath:path];
        NSLog(@"path%@",path);
        if ([_fmdb open]) {
            //打开数据库之后 创造表格
            /*
             create table if not exists app(id varchar(32),name varchar(128),pic varchar(1024))
             */
            NSString *sql = @"create table if not exists app(app_id varchar(32),type varchar(128),dic varchar(1024))";
            BOOL isSuccess = [_fmdb executeUpdate:sql];
            if (isSuccess) {
                NSLog(@"create table success");
            }else{
                NSLog(@"create table fail%@",_fmdb.lastErrorMessage);
            }
        }else{
            NSLog(@"open Sqlite fail");
        }
    }
    return self;
}
- (BOOL)isExistsDataWithModel:(FavoriteModel *)model{
    /*
     select applicationid from app where applicationID = ?
     */

    NSString *sql = @"select app_id from app where app_id = ?";
    //这个方法是查询
    FMResultSet *set = [_fmdb executeQuery:sql,model.app_id];
    //[set next] 如果查询到了这个方法 这个方法会返回一个真值
    return [set next];
}
- (BOOL)isExistsDataWithStr:(NSString *)app_id{
    NSString *sql = @"select app_id from app where app_id = ?";
    //这个方法是查询
    FMResultSet *set = [_fmdb executeQuery:sql,app_id];
    //[set next] 如果查询到了这个方法 这个方法会返回一个真值
    return [set next];

}
//插入数据
- (BOOL)insertDataWithModel:(FavoriteModel *)model{
    /*
     insert into app (applicationId,name,iconurl) values (?,?,?)
     */
    NSString *sql = @"insert into app (app_id,type,dic) values (?,?,?)";
    BOOL isSuccess = [_fmdb executeUpdate:sql,model.app_id, model.type,model.dic];
    if (isSuccess) {
        NSLog(@"insert success");
    }else{
        NSLog(@"failError :%@",_fmdb.lastErrorMessage);
    }
    return isSuccess;
}
//删除数据

- (BOOL)deleteDataWithStr:(NSString *)app_id{
    NSString *sql = @"delete from app where app_id = ?";
    BOOL isSuccess = [_fmdb executeUpdate:sql,app_id];
    if (isSuccess) {
        NSLog(@"delete success");
    }else
    {
        NSLog(@"error:%@",_fmdb.lastErrorMessage);
    }
    return isSuccess;
}
- (BOOL)deleteDataWithModel:(FavoriteModel *)model{
    //    delete from app where applicationId = ?
    NSString *sql = @"delete from app where app_id = ?";
    BOOL isSuccess = [_fmdb executeUpdate:sql,model.app_id];
    if (isSuccess) {
        NSLog(@"delete success");
    }else
    {
        NSLog(@"error:%@",_fmdb.lastErrorMessage);
    }
    return isSuccess;
}
- (NSArray *)responseData{
    NSString *sql = @"select * from app";
    FMResultSet *set = [_fmdb executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        FavoriteModel *model = [[FavoriteModel alloc]init];
        model.type = [set stringForColumn:@"type"];
        model.app_id = [set stringForColumn:@"app_id"];
        model.dic = [set stringForColumn:@"dic"];
        [array addObject:model];
    }
    return array;
}
@end
