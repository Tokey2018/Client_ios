//
//  TKCore.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKCore.h"
#import "TKDataCore.h"
#import "TKSqliteTools.h"
#import "TKUserSetting.h"
#import "TKUserAction.h"

@implementation TKCore

static TKCore *_onetimeClass;

+(TKCore *)shareCore
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        _onetimeClass = [[TKCore alloc]init];
        
    });
    
    return _onetimeClass;
}
-(TKUserRespose *)userRespose{
    if (!_userRespose) {
        _userRespose = [[TKDataCore sharedCore] loginUser];
    }
    return _userRespose;
}

-(void)autoLogin{
    TKAccountPassWordModel *accountmodel = [[TKSqliteTools sharedSqliteTools] showAppById:[TKUserSetting sharedManager].phone];
    if (accountmodel) {
        
        [TKUserAction userLogin:accountmodel.account password:accountmodel.passWord phoneBook:nil respose:^(TKDoLoginModel *loginModel, NSString *yhsdLoginUrl, NSString *aMessage) {
            
            TKDoLoginModel * model = loginModel;
            
            [TKUserSetting sharedManager].yhsdLoginUrl = yhsdLoginUrl;
            
            
            [TKUserSetting sharedManager].uid = model.user.uid;
            [TKUserSetting sharedManager].nick = model.user.nick;
            [TKUserSetting sharedManager].phone = accountmodel.account;
            [TKUserSetting sharedManager].username = model.user.accid;
            [TKUserSetting sharedManager].password = model.user.imToken;
            [TKUserSetting sharedManager].token = model.accessToken;
            [TKUserSetting sharedManager].isLogined = YES;
            [TKUserSetting sharedManager].userImg = model.user.userImg;
            [TKUserSetting sharedManager].backgroupImg = model.user.backgroupImg;
            [TKUserSetting sharedManager].roleCode = model.user.roleCode;
            [TKUserSetting sharedManager].agencyTids = model.user.agencyTids;
            [TKUserSetting sharedManager].auditStatus = model.user.auditStatus;
            [TKUserSetting sharedManager].voice = @"11";//系统声音默认开启;
            [TKUserSetting sharedManager].shake = @"12";//系统震动默认开启;
            [[[NIMSDK sharedSDK] loginManager] login:model.user.accid
                                               token:model.user.imToken
                                          completion:^(NSError *error) {
                                              if (error == nil)
                                              {
                                                  //[XYHUDCore showSuccessWithStatus:@"自动登录成功"];
                                                  if(![[TKSqliteTools sharedSqliteTools] isExistAppWithstring:accountmodel.account]){
                                                      
                                                      [[TKSqliteTools sharedSqliteTools] insertAppAccount:accountmodel.account andPass:accountmodel.passWord];
                                                  }else{
                                                      [[TKSqliteTools sharedSqliteTools] DeleteAppAccount:accountmodel.account];
                                                      [[TKSqliteTools sharedSqliteTools] insertAppAccount:accountmodel.account andPass:accountmodel.passWord];
                                                  }
                                                  
                                              }
                                              else
                                              {
                                                  //[XYHUDCore showErrorWithStatus:@"登录失败"];
                                              }
                                          }];
        }];
        
    }
}

@end
