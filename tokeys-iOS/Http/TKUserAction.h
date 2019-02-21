//
//  TKUserAction.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKDoLoginModel.h"

@interface TKUserAction : NSObject

+(void)userLogin:(NSString*)phone
        password:(NSString*)password
       phoneBook:(NSArray*)phoneBook
         respose:(void(^)(TKDoLoginModel*loginModel,NSString*aMessage))callblock;

@end

