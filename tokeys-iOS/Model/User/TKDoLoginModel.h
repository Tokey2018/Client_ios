//
//  TKDoLoginModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"
#import "TKUserInfoNewModel.h"

@interface TKDoLoginModel : TKModel

@property (nonatomic , copy)   NSString              * accessToken;

@property (nonatomic , strong) TKUserInfoNewModel    * user;

@end

