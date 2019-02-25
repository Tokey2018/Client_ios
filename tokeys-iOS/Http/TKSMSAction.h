//
//  TKSMSAction.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/25.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 SMS 短信
 */
@interface TKSMSAction : NSObject


+(void)sendSMSCode:(NSString*)phone respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;

/**
 验证注册验证码

 @param phone <#phone description#>
 @param code <#code description#>
 @param call <#call description#>
 */
+(void)verificatRegCode:(NSString*)phone code:(NSString*)code respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;


/**
 发送找回密码的短信验证码

 @param phone <#phone description#>
 @param call <#call description#>
 */
+(void)findPassSMS:(NSString*)phone respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;

+(void)verificatPassCode:(NSString*)phone code:(NSString*)code respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;

@end

