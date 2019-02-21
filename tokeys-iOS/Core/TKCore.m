//
//  TKCore.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKCore.h"
#import "TKDataCore.h"

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
@end
