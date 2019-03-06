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

@end
