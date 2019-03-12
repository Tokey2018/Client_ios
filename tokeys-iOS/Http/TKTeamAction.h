//
//  TKTeamAction.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKHttpAction.h"
#import "TKGroupNewModel.h"
#import "TKGroupNotiModel.h"

@interface TKTeamAction : NSObject


/**
 拉某人入群

 @param groupID <#groupID description#>
 @param owner <#owner description#>
 @param members <#members description#>
 @param call <#call description#>
 */
+(void)team_invite:(NSString*)groupID
             owner:(NSString*)owner
           members:(NSString*)members respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;

+(void)team_create:(NSString*)tname
             owner:(NSString*)owner
           members:(NSString*)members
               did:(NSString*)did
           respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;


+(void)updateMsgSwitch:(NSString*)tid accid:(NSString*)accid ope:(NSString*)ope respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;



+(void)team_detail:(NSString*)tid respose:(void(^)(TKGroupNewModel *aDetail,NSString *aMessage))call;
/**
 解散群租

 @param tid <#tid description#>
 @param owner <#owner description#>
 @param call <#call description#>
 */
+(void)team_remove:(NSString*)tid
             owner:(NSString*)owner
           respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;


+(void)team_leave:(NSString*)tid
            accid:(NSString*)accid
          respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;

/**
 踢人

 @param tid <#tid description#>
 @param owner <#owner description#>
 @param members <#members description#>
 @param call <#call description#>
 */
+(void)team_kick:(NSString*)tid
           owner:(NSString*)owner
         members:(NSString*)members
         respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;


+(void)replaceMaster:(NSString*)tid
               owner:(NSString*)owner
            newowner:(NSString*)newowner
               leave:(NSString*)leave
             respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;


/**
 发送通告

 @param tid <#tid description#>
 @param owerAccid <#owerAccid description#>
 @param title <#title description#>
 @param content <#content description#>
 @param call <#call description#>
 */
+(void)sendNotice:(NSString*)tid
        owerAccid:(NSString*)owerAccid
            title:(NSString*)title
          content:(NSString*)content
          respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;



+(void)noticeList:(NSString*)tid respose:(void(^)(NSArray<TKGroupNotiModel*> *notiModels,NSString *aMessage))call;

@end

