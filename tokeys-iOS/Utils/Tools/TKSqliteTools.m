//
//  TKSqliteTools.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKSqliteTools.h"

@implementation TKAccountPassWordModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end

@implementation TKSqliteTools

//1、创建数据库
- (instancetype)init{
    if (self = [super init]) {
        //1、沙盒目录路径
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/APPINFO.rdb"];
        
        //2、创建
        _database = [[FMDatabase alloc]initWithPath:path];
        
        //3、判断是否创建成功
        if ([_database open]) {
            // NSLog(@"数据库创建成功");
        }else{
            //  NSLog(@"数据库创建失败");
        }
        
        //4、创建表
        NSString * createSql = @"CREATE TABLE IF NOT EXISTS AppTable (account varchar(256),passWord varchar(256))";
        BOOL isSuc = [_database executeUpdate:createSql];
        
        if (isSuc) {
            // NSLog(@"创建表成功");
        }else{
            // NSLog(@"创建表失败");
        }
    }
    return self;
}
//2、将数据库创建形式转换为单例形式
+ (instancetype)sharedSqliteTools{
    //单例作用：在程序的生命周期中，无论使用单例的形式创建一个对象多少次，使用的均为同一对象。
    static TKSqliteTools * tools = nil;
    //判断是否已经存在该对象，如果不存在才来创建，如果存在，直接返回上次创建的对象
    if (tools == nil) {
        tools = [[TKSqliteTools alloc]init];
    }
    return tools;
}
//3、收藏的方法
- (void)insertAppAccount:(NSString *)string andPass:(NSString*)passStr{
    
    NSString * account = string;
    
    NSString * passWord = passStr;
    //增加的SQL语句
    NSString * insertSql = @"INSERT INTO AppTable (account,passWord) values(?,?)";
    
    BOOL isSuc = [_database executeUpdate:insertSql,account,passWord];
    
    if (isSuc) {
        
    }else{
        
    }
}

//3、删除的方法
- (void)DeleteAppAccount:(NSString *)accountId{
    
    NSString * account = accountId;
    //增加的SQL语句
    NSString * insertSql = @"DELETE FROM AppTable WHERE account = ?";
    
    BOOL isSuc = [_database executeUpdate:insertSql,account];
    
    if (isSuc) {
        
    }else{
        
    }
}

- (BOOL)isExistAppWithstring:(NSString *)history{
    //数据库的查操作
    NSString * selectSql = @"SELECT * FROM AppTable WHERE account = ?";
    FMResultSet * set = [_database executeQuery:selectSql,history];
    //判断是否可以找到值
    if ([set next]) {
        return YES;
    }else{
        return NO;
    }
}

- (NSArray*)showAllApp{
    NSString * selectSql = @"SELECT * FROM AppTable";
    
    FMResultSet * set = [_database executeQuery:selectSql];
    
    NSMutableArray * array = [NSMutableArray array];
    
    while ([set next]) {
        TKAccountPassWordModel * model = [[TKAccountPassWordModel alloc]init];
        model.account = [set stringForColumn:@"account"];
        model.passWord = [set stringForColumn:@"passWord"];
        //存储数据模型
        [array addObject:model];
    }
    
    return array;
    
}
- (TKAccountPassWordModel*)showAppById:(NSString*)accountId{
    NSString * selectSql = @"SELECT * FROM AppTable WHERE account = ?";
    FMResultSet * set = [_database executeQuery:selectSql,accountId];
    while ([set next]) {
        TKAccountPassWordModel * model = [[TKAccountPassWordModel alloc]init];
        model.account = [set stringForColumn:@"account"];
        model.passWord = [set stringForColumn:@"passWord"];
        //存储数据模型
        return model;
    }
    return nil;
}

@end
