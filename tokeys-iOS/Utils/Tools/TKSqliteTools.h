//
//  TKSqliteTools.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface TKAccountPassWordModel : NSObject

@property (nonatomic,copy)NSString * account;

@property (nonatomic,copy)NSString * passWord;

@end

@interface TKSqliteTools : NSObject

//声明数据库属性
@property (nonatomic,strong)FMDatabase * database;

/**创建数据库与表（单例形式）*/
+ (instancetype)sharedSqliteTools;
/**收藏数据*/
- (void)insertAppAccount:(NSString *)string andPass:(NSString*)passStr;
/**查看所有数据*/
- (NSArray*)showAllApp;

- (BOOL)isExistAppWithstring:(NSString*)history;

- (void)DeleteAppAccount:(NSString*)accountId;

- (TKAccountPassWordModel*)showAppById:(NSString*)accountId;

@end

