//
//  TKCore.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKUserRespose.h"
#import "XYHUDCore.h"

@interface TKCore : NSObject

+(TKCore*)shareCore;

@property (strong , nonatomic) TKUserRespose *userRespose;

@property (strong , nonatomic) NSString *userGuid;

-(void)autoLogin;

@end


