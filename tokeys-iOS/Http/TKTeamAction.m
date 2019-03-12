//
//  TKTeamAction.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKTeamAction.h"
#import "TKHttpAction.h"

@implementation TKTeamAction

+(void)team_invite:(NSString*)groupID
             owner:(NSString*)owner
           members:(NSString*)members respose:(void(^)(BOOL ,NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];

    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:groupID forKey:@"tid"];
    [parms setValue:owner forKey:@"owner"];
    [parms setValue:members forKey:@"members"];
    
    NSString *url = [action getURL:@"/team/invite"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"操作失败");
        }else{
            if (response.code==0) {
                call(YES,@"操作成功");
            }else{
                call(NO,response.msg);
            }
        }
    }];
}

+(void)team_create:(NSString*)tname
             owner:(NSString*)owner
           members:(NSString*)members
               did:(NSString*)did
           respose:(void(^)(BOOL ,NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:tname forKey:@"tname"];
    [parms setValue:owner forKey:@"owner"];
    [parms setValue:members forKey:@"members"];
    [parms setValue:did forKey:@"did"];
    
    NSString *url = [action getURL:@"/team/create"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"创建失败");
        }else{
            if (response.code==0) {
                call(YES,@"创建成功");
            }else{
                call(NO,response.msg);
            }
        }
    }];
}

+ (void)team_detail:(NSString *)tid respose:(void (^)(TKGroupNewModel *, NSString *))call{
    
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:tid forKey:@"tid"];
   
    
    NSString *url = [action getURL:@"/team/detail"];
    [action tokeys_request:url method:TKHttpMethodGET params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(nil,@"创建失败");
        }else{
            if (response.code==0) {
                TKGroupNewModel *m = [[TKGroupNewModel alloc] initWithDictionary:response.data];
                call(m,response.msg);
            }else{
                call(nil,response.msg);
            }
        }
    }];
}

+(void)updateMsgSwitch:(NSString *)tid accid:(NSString *)accid ope:(NSString *)ope respose:(void (^)(BOOL, NSString *))call{
    
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:tid forKey:@"tid"];
    [parms setValue:accid forKey:@"accid"];
    [parms setValue:ope forKey:@"ope"];
    
    
    NSString *url = [action getURL:@"/team/updateMsgSwitch"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"操作失败");
        }else{
            if (response.code==0) {
                call(YES,@"操作成功");
            }else{
                call(NO,response.msg);
            }
        }
    }];
}

+ (void)team_remove:(NSString *)tid owner:(NSString *)owner respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:tid forKey:@"tid"];
    [parms setValue:owner forKey:@"owner"];
    
    NSString *url = [action getURL:@"/team/remove"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"操作失败");
        }else{
            if (response.code==0) {
                call(YES,response.msg);
            }else{
                call(NO,response.msg);
            }
        }
    }];
}
+(void)team_leave:(NSString *)tid accid:(NSString *)accid respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:tid forKey:@"tid"];
    [parms setValue:accid forKey:@"accid"];
    
    NSString *url = [action getURL:@"/team/leave"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"操作失败");
        }else{
            if (response.code==0) {
                call(YES,response.msg);
            }else{
                call(NO,response.msg);
            }
        }
    }];
}

+ (void)team_kick:(NSString *)tid owner:(NSString *)owner members:(NSString *)members respose:(void (^)(BOOL, NSString *))call{
    
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:tid forKey:@"tid"];
    [parms setValue:owner forKey:@"owner"];
    [parms setValue:members forKey:@"member"];
    
    NSString *url = [action getURL:@"/team/kick"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,@"操作失败");
        }else{
            if (response.code==0) {
                call(YES,response.msg);
            }else{
                call(NO,response.msg);
            }
        }
    }];
}

+ (void)replaceMaster:(NSString *)tid owner:(NSString *)owner newowner:(NSString *)newowner leave:(NSString *)leave respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:tid forKey:@"tid"];
    [parms setValue:owner forKey:@"owner"];
    [parms setValue:newowner forKey:@"newowner"];
    [parms setValue:leave forKey:@"leave"];
    
    NSString *url = [action getURL:@"/team/replaceMaster"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,aMessage);
        }else{
            if (response.code==0) {
                call(YES,response.msg);
            }else{
                call(NO,response.msg);
            }
        }
    }];
}


+ (void)sendNotice:(NSString *)tid owerAccid:(NSString *)owerAccid title:(NSString *)title content:(NSString *)content respose:(void (^)(BOOL, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:tid forKey:@"tid"];
    [parms setValue:owerAccid forKey:@"owerAccid"];
    [parms setValue:title forKey:@"title"];
    [parms setValue:content forKey:@"content"];
    
    NSString *url = [action getURL:@"/team/sendNotice"];
    [action tokeys_request:url method:TKHttpMethodPOST params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(NO,aMessage);
        }else{
            if (response.code==0) {
                call(YES,response.msg);
            }else{
                call(NO,response.msg);
            }
        }
    }];
}
+ (void)noticeList:(NSString *)tid respose:(void (^)(NSArray<TKGroupNotiModel *> *, NSString *))call{
    TKHttpAction *action =  [[TKHttpAction alloc] init];
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:tid forKey:@"tid"];
    
    
    NSString *url = [action getURL:@"/team/noticeList"];
    [action tokeys_request:url method:TKHttpMethodGET params:parms showHUD:YES resposeBlock:^(TKHttpResposeModel *response, NSString *aMessage) {
        if (response==nil) {
            call(nil,aMessage);
        }else{
            if (response.code==0) {
                NSArray *data = response.data;
                NSMutableArray *list;
                if(data!=nil){
                    list = [NSMutableArray array];
                    for (NSDictionary *dic in data) {
                        TKGroupNewModel *m = [[TKGroupNewModel alloc] initWithDictionary:dic];
                        [list addObject:m];
                    }
                }
                call(list,response.msg);
            }else{
                call(nil,response.msg);
            }
        }
    }];
}
@end
