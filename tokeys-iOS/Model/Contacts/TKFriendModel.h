//
//  TKFriendModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"

@interface TKFriendModel : TKModel

@property (nonatomic,copy)NSString *uid;//用户id
@property (nonatomic,copy)NSString *phone;//电话
@property (nonatomic,copy)NSString *nick;//昵称
@property (nonatomic,copy)NSString *accid;//云信id

@end

