//
//  TKChatInfoViewController.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKChatItem.h"
#import "TKDocumentModel.h"
#import "TKContactModel.h"

#define kMaxHeight 90.0f
#define kMinHeight 49.0f

@interface TKChatInfoViewController : UIViewController

@property (nonatomic,copy)NSString *userID;

@property (nonatomic,strong)NIMSession * session;

@property (nonatomic,assign)NSInteger type;

@property (nonatomic,copy)NSString *nameStr;

@property (nonatomic,assign)BOOL isCall;//是否为紧急呼叫
@property (nonatomic,assign)BOOL isBumen;//bumenqunliao

@end

