//
//  TKGroupModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/12.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"


@interface TKGroupModel : TKModel


@property (nonatomic,copy)NSString * tid;//群id
@property (nonatomic,copy)NSString * tname;//群名

@property (nonatomic,copy)NSString * owner;//管理者
@property (nonatomic,copy)NSString * size;

@property (nonatomic,copy)NSString * intro;
@property (nonatomic,copy)NSString * notice;
@property (nonatomic,copy)NSString * userImg;
@property (nonatomic,copy)NSString * uid;

@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,copy)NSString * maccid;
@property (nonatomic,copy)NSString * isAdmin;

@end

