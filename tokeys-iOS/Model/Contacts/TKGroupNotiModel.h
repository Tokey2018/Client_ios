//
//  TKGroupNotiModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/12.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"


/**
 群公告
 */
@interface TKGroupNotiModel : TKModel

@property (nonatomic,copy)NSString * addTime;//时间
@property (nonatomic,copy)NSString * content;//内容
@property (nonatomic,copy)NSString * tid;//群id
@property (nonatomic,copy)NSString * title;//标题

@end

