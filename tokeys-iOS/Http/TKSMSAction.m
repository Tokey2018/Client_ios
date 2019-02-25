//
//  TKSMSAction.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/25.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKSMSAction.h"
#import "TKHttpAction.h"

@implementation TKSMSAction


+(void)findPassSMS:(NSString *)phone respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:phone  forKey:@"phone"];
    
    NSString *url = [action getURL:@"/reg/findPassSMS"];
    [action request:url params:parms showHUD:YES resposeBlock:^(id responseObject, NSError *error) {
        if (error!=nil) {
            call(NO,@"发送失败");
        }else{
            call(YES,@"发送成功");
        }
    }];
}
+(void)verificatPassCode:(NSString *)phone code:(NSString *)code respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:phone forKey:@"phone"];
    [parms setValue:code forKey:@"code"];
    
    NSString *url = [action getURL:@"/reg/verificatPassCode"];
    [action request:url params:parms showHUD:YES resposeBlock:^(id responseObject, NSError *error) {
        if (error!=nil) {
            call(NO,@"验证失败");
        }else{
            call(YES,@"验证成功");
        }
    }];
        
}

@end
