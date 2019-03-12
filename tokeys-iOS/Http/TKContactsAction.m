//
//  TKContactsAction.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKContactsAction.h"
#import "TKHttpAction.h"

@implementation TKContactsAction

+ (void)friendList:(void (^)(NSArray<TKFriendModel *> *, NSString *))callblock{
    
    TKHttpAction *action = [[TKHttpAction alloc] init];
    NSString *url = [action getURL:@"/imperson/friendList"];
    [action tokeys_request:url method:TKHttpMethodGET params:nil showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response!=nil) {
            if (response.code==0) {
                
                //[[XYDataCore sharedDataCore] saveUserAllFriend:arr];
                NSMutableArray *fs = [NSMutableArray array];
                for(NSDictionary * diction in response.data){
                    
                    TKFriendModel * model = [[TKFriendModel alloc]initWithDictionary:diction];
                    
                    [fs addObject:model];
                }
                
                callblock(fs,response.msg);
            }else{
                callblock(nil,response.msg);
            }
        }else{
            callblock(nil,aMessage);
        }
    }];
}

+ (void)addOneFriend:(NSString *)accid faccid:(NSString *)faccid respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:accid forKey:@"accid"];
    [parms setValue:faccid forKey:@"faccid"];
    
    NSString *url = [action getURL:@"/imperson/addOneFriend"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"添加失败");
        }else{
            if (response.code==0) {
                call(YES,@"添加成功");
            }else{
                call(NO,response.msg);
            }
        }
    }];
}

+ (void)teamAndFriends:(NSString *)accid pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize keyword:(NSString *)keyword respose:(void (^)(NSArray<TKSearchModel *> *, NSString *))callblock{
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:accid forKey:@"accid"];
    [parms setValue:keyword forKey:@"keyword"];
    [parms setValue:@(pageNumber) forKey:@"pageNumber"];
    [parms setValue:@(pageSize) forKey:@"pageSize"];
    
    TKHttpAction *action = [[TKHttpAction alloc] init];
    NSString *url = [action getURL:@"/imperson/friendList"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response!=nil) {
            if (response.code==0) {
                
                //[[XYDataCore sharedDataCore] saveUserAllFriend:arr];
                NSMutableArray *fs = [NSMutableArray array];
                for(NSDictionary * diction in response.data){
                    
                    TKFriendModel * model = [[TKFriendModel alloc]initWithDictionary:diction];
                    
                    [fs addObject:model];
                }
                
                callblock(fs,response.msg);
            }else{
                callblock(nil,response.msg);
            }
        }else{
            callblock(nil,aMessage);
        }
    }];
    
}
+ (void)findByKeyword:(NSString *)keyword respose:(void (^)(TKSearchPeopleModel *, NSString *))callblock{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:keyword forKey:@"keyword"];
    
    TKHttpAction *action = [[TKHttpAction alloc] init];
    NSString *url = [action getURL:@"/imperson/findByKeyword"];
    [action tokeys_request:url method:TKHttpMethodPOST params:dict showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response!=nil) {
            if (response.code==0) {
                TKSearchPeopleModel *model = [[TKSearchPeopleModel alloc] initWithDictionary:response.data];
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
