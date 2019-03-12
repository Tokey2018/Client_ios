//
//  TKUserAction.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKDoLoginModel.h"
#import "TKXGModel.h"
#import "TKHttpAction.h"

@interface TKUserAction : NSObject


+(void)register_save:(NSString*)phone
                code:(NSString*)code
            password:(NSString*)password
           phoneBook:(NSArray*)phoneBook
             respose:(void(^)(BOOL aSuccess,NSString*aMessage))callblock;

+(void)userLogin:(NSString*)phone
        password:(NSString*)password
       phoneBook:(NSArray*)phoneBook
         respose:(void(^)(TKDoLoginModel*loginModel,NSString *yhsdLoginUrl,NSString*aMessage))callblock;


/**
 找回密码

 @param phone <#phone description#>
 @param code <#code description#>
 @param password <#password description#>
 @param confirmPass <#confirmPass description#>
 @param callblock <#callblock description#>
 */
+(void)findpass_setNewPass:(NSString*)phone
                      code:(NSString*)code
                  password:(NSString*)password
               confirmPass:(NSString*)confirmPass
                   respose:(void(^)(BOOL aSuccess,NSString*aMessage))callblock;


+(void)userInfo:(NSString*)ownAccid
       otherUid:(NSString*)otherUid
        respose:(void(^)(TKXGModel*xgModel,NSString*aMessage))callblock;

@end

