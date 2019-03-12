//
//  TKContactsAction.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKFriendModel.h"
#import "TKHttpAction.h"
#import "TKSearchModel.h"
#import "TKSearchPeopleModel.h"

@interface TKContactsAction : NSObject


/**
 好友列表

 @param callblock <#callblock description#>
 */
+(void)friendList:(void(^)(NSArray<TKFriendModel*>*friendList,NSString *aMessage))callblock;

+(void)addOneFriend:(NSString*)accid faccid:(NSString*)faccid respose:(void(^)(BOOL aSuccess,NSString *aMessage))call;


+(void)teamAndFriends:(NSString*)accid
           pageNumber:(NSInteger)pageNumber
             pageSize:(NSInteger)pageSize
              keyword:(NSString*)keyword
              respose:(void(^)(NSArray<TKSearchModel*>* searchModels,NSString *aMessage))callblock;


+(void)findByKeyword:(NSString*)keyword respose:(void(^)(TKSearchPeopleModel*loginModel,NSString*aMessage))callblock;

@end

