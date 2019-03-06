//
//  TKContactsAction.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKFriendModel.h"

@interface TKContactsAction : NSObject


/**
 好友列表

 @param callblock <#callblock description#>
 */
+(void)friendList:(void(^)(NSArray<TKFriendModel*>*friendList,NSString *aMessage))callblock;

@end

