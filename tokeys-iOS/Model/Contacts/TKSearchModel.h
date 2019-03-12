//
//  TKSearchModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"


@interface TKSearchModel : TKModel

@property (nonatomic,assign) id usergid;//群id

@property (nonatomic,copy)NSString * userid;//个人云信id

@property (nonatomic,copy)NSString * alias;//昵称

@property (nonatomic,copy)NSString * isTeam;//是否为群组

@end

