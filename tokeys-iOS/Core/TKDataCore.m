//
//  TKDataCore.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKDataCore.h"
#import "TKFileManager.h"

@interface TKDataCore ()

@property (strong , nonatomic) TKFileManager *fileManager;

@end

@implementation TKDataCore

static TKDataCore *__core;

+(TKDataCore *)sharedCore
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        __core = [[TKDataCore alloc]init];
        
    });
    
    return __core;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _fileManager = [TKFileManager sharedManager];
    }
    return self;
}

-(void)saveLoginUser:(TKUserRespose *)saveUser{
    if (saveUser==nil) {
        [_fileManager deleteFileKey:@"CURRENT" fileName:@"USERS.plist"];
        [TKCore shareCore].userRespose = nil;
        [TKCore shareCore].userGuid = nil;
        return;
    }
    NSDictionary *u_info = saveUser.dictionary;
    [_fileManager saveFile:u_info key:@"CURRENT" fileName:@"USERS.plist"];
    [TKCore shareCore].userRespose = saveUser;
}
-(TKUserRespose *)loginUser{
    NSMutableDictionary *rootdic = [_fileManager getDictionary:@"USERS.plist"];
    NSDictionary *u_info = rootdic[@"CURRENT"];
    if (u_info == nil) {
        return nil;
    }
    TKUserRespose *u = [[TKUserRespose alloc] initWithDictionary:u_info];
    return u;
}

@end
