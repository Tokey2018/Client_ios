//
//  TKHttpResposeModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"

@interface TKHttpResposeModel : TKModel

@property (assign , nonatomic) NSInteger code;

@property (strong , nonatomic) id data;

@property (strong , nonatomic) NSString *msg;

@property (strong , nonatomic) NSString *yhsdLoginUrl;

@end

