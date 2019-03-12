//
//  TKGroupNewModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/12.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"
#import "TKGroupModel.h"

@interface TKGroupNewModel : TKModel

@property(nonatomic,strong)TKGroupModel * owner;

@property(nonatomic,strong)TKGroupModel *team;

@property(nonatomic,strong)NSArray *members;

@end

