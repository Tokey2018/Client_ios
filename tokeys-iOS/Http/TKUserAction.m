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


+(void)userLogin:(NSString *)phone password:(NSString *)password phoneBook:(NSArray *)phoneBook respose:(void (^)(TKDoLoginModel *, NSString *))callblock{

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
    [action tokeys_request:url params:dict showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        
    }];
}


@end
