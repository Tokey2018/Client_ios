//
//  TKModel.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKModel.h"
#import "MJExtension.h"

@implementation TKModel

-(instancetype)initWithDictionary:(NSDictionary*)aDic{
    self =  [self.class mj_objectWithKeyValues:aDic];
    if (self) {
        
    }
    return self;
}
-(NSDictionary *)dictionary{
    return [self mj_keyValues];
}
-(NSString *)zb_jsonValue{
    return [self mj_JSONString];
}

@end
