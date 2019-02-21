//
//  TKUserRespose.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"
#import "TKUser.h"

@interface TKUserRespose : TKModel

@property (strong , nonatomic) NSString *access_token;

@property (strong , nonatomic) NSString *expiration;

@property (assign , nonatomic) NSTimeInterval expires_in;

@property (strong , nonatomic) NSString *refresh_token;

@property (strong , nonatomic) NSString *scope;

@property (strong , nonatomic) NSString *token_type;//" = bearer;

@property (strong , nonatomic) TKUser *user;

@end

