//
//  TKModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TKModel : NSObject

-(instancetype)initWithDictionary:(NSDictionary*)aDictionary;

-(NSDictionary *)dictionary;

-(NSString *)zb_jsonValue;

@end

