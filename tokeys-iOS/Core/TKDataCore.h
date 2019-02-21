//
//  TKDataCore.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKUserRespose.h"


@interface TKDataCore : NSObject

+(TKDataCore *)sharedCore;

-(void)saveLoginUser:(TKUserRespose *)saveUser;

-(TKUserRespose*)loginUser;

@end

