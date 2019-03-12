//
//  TKXGModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"

@interface TKXGModel : TKModel

@property (nonatomic,copy)NSString * nick;//昵称
@property (nonatomic,copy)NSString * auditStatus;//认证状态
@property (nonatomic,copy)NSString * birthday;//生日
@property (nonatomic,copy)NSString * realName;//真实姓名
@property (nonatomic,copy)NSString * sex;//性别
@property (nonatomic,copy)NSString * userImg;//头像
@property (nonatomic,copy)NSString * isMarry;//是否结婚
@property (nonatomic,copy)NSString * office;//医院
@property (nonatomic,copy)NSString * dname;//科室
@property (nonatomic,copy)NSString * aname;//职称
@property (nonatomic,copy)NSString * sickSkill;//擅长技能
@property (nonatomic,copy)NSString * intro;//详细介绍
@property (nonatomic,copy)NSString * isFriend;//是否为好友
@property (nonatomic,copy)NSString * accid;

@end

