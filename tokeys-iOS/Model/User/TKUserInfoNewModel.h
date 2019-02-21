//
//  TKUserInfoNewModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"


@interface TKUserInfoNewModel : TKModel

@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * imToken;
@property (nonatomic , copy) NSString              * realName;
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * aid;
@property (nonatomic , copy) NSString              * accid;
@property (nonatomic , copy) NSString              * auditStatus;
@property (nonatomic , copy) NSString              * userImg;
@property (nonatomic , copy) NSString              * backgroupImg;
@property (nonatomic, copy) NSString *roleCode;
@property (nonatomic, copy) NSArray *agencyTids;


@end

