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

+(void)findPassSMS:(NSString*)phone respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;

+(void)verificatPassCode:(NSString*)phone code:(NSString*)code respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;

@end

