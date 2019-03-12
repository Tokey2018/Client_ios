//
//  TKUserAction.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKUserAction.h"
#import "TKHttpAction.h"

@implementation TKUserAction


+ (void)register_save:(NSString *)phone code:(NSString *)code password:(NSString *)password phoneBook:(NSArray *)phoneBook respose:(void (^)(BOOL, NSString *))callblock{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:phone forKey:@"phone"];
    [dict setValue:code forKey:@"code"];
    [dict setValue:password forKey:@"password"];
    if(phoneBook.count!=0){
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:phoneBook options:0 error:nil];
        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [dict setObject:myString forKey:@"phoneBook"];
    }
    
    TKHttpAction *action = [[TKHttpAction alloc] init];
    NSString *url = [action getURL:@"/reg/save"];
    [action tokeys_request:url method:TKHttpMethodPOST params:dict showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        
    }];
}

+(void)userLogin:(NSString *)phone password:(NSString *)password phoneBook:(NSArray *)phoneBook respose:(void (^)(TKDoLoginModel *, NSString *, NSString *))callblock{

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:password forKey:@"password"];
    if(phoneBook!=nil && phoneBook.count!=0){
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:phoneBook options:0 error:nil];
        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [dict setObject:myString forKey:@"phoneBook"];
    }
    TKHttpAction *action = [[TKHttpAction alloc] init];
    NSString *url = [action getURL:@"/login/doLogin"];
    [action tokeys_request:url method:TKHttpMethodPOST params:dict showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response!=nil) {
            if (response.code==0) {
                TKDoLoginModel *model = [[TKDoLoginModel alloc] initWithDictionary:response.data];
                callblock(model,response.yhsdLoginUrl,response.msg);
                //加载URL
                [action request:response.yhsdLoginUrl method:TKHttpMethodGET params:nil showHUD:NO resposeBlock:nil];
            }else{
                callblock(nil,nil,response.msg);
            }
        }else{
            callblock(nil,nil,aMessage);
        }
    }];
}
+ (void)findpass_setNewPass:(NSString *)phone code:(NSString *)code password:(NSString *)password confirmPass:(NSString *)confirmPass respose:(void (^)(BOOL, NSString *))callblock{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:phone forKey:@"phone"];
    [parms setValue:code forKey:@"code"];
    [parms setValue:password forKey:@"password"];
    [parms setValue:confirmPass forKey:@"confirmPass"];
    
    NSString *url = [action getURL:@"/reg/setNewPass"];
    [action tokeys_request:url method:TKHttpMethodGET params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            callblock(NO,@"发送失败");
        }else{
            if (response.code==0) {
                callblock(YES,@"发送成功");
            }else{
                callblock(NO,response.msg);
            }
        }
    }];
}


+ (void)userInfo:(NSString *)ownAccid otherUid:(NSString *)otherUid respose:(void (^)(TKXGModel *, NSString *))callblock{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:ownAccid forKey:@"ownAccid"];
    [dict setObject:otherUid forKey:@"otherUid"];
   
    TKHttpAction *action = [[TKHttpAction alloc] init];
    NSString *url = [action getURL:@"/imperson/userInfo"];
    [action tokeys_request:url method:TKHttpMethodPOST params:dict showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response!=nil) {
            if (response.code==0) {
                TKXGModel *model = [[TKXGModel alloc] initWithDictionary:response.data];
                callblock(model,response.msg);
                
            }else{
                callblock(nil,response.msg);
            }
        }else{
            callblock(nil,aMessage);
        }
    }];
}

@end
