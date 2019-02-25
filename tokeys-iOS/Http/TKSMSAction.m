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

+ (void)sendSMSCode:(NSString *)phone respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:phone  forKey:@"phone"];
    
    NSString *url = [action getURL:@"/reg/sendSMSCode"];
    [action tokeys_request:url method:TKHttpMethodGET params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"发送失败");
        }else{
            if (response.code==0) {
                call(YES,@"发送成功");
            }else{
                call(NO,response.msg);
            }
        }
    }];
}
+ (void)verificatRegCode:(NSString *)phone code:(NSString *)code respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:phone forKey:@"phone"];
    [parms setValue:code forKey:@"code"];
    
    NSString *url = [action getURL:@"/reg/verificatRegCode"];
    [action tokeys_request:url method:TKHttpMethodGET params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"发送失败");
        }else{
            if (response.code==0) {
                call(YES,@"发送成功");
            }else{
                call(NO,response.msg);
            }
        }
    }];
}

+(void)findPassSMS:(NSString *)phone respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:phone  forKey:@"phone"];
    
    NSString *url = [action getURL:@"/reg/findPassSMS"];
    [action tokeys_request:url method:TKHttpMethodGET params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"发送失败");
        }else{
            if (response.code==0) {
                call(YES,@"发送成功");
            }else{
                call(NO,response.msg);
            }
        }
    }];
}
+(void)verificatPassCode:(NSString *)phone code:(NSString *)code respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:phone forKey:@"phone"];
    [parms setValue:code forKey:@"code"];
    
    NSString *url = [action getURL:@"/reg/verificatPassCode"];
    [action tokeys_request:url method:TKHttpMethodGET params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"发送失败");
        }else{
            if (response.code==0) {
                call(YES,@"发送成功");
            }else{
                call(NO,response.msg);
            }
        }
    }];
        
}

@end
