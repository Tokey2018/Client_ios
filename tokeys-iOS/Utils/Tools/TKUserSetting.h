//
//  TKUserSetting.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  属性一定都是id类型 一般常用NSString
 */
@interface TKUserSetting : NSObject
/// 呼出单例方法
+ (TKUserSetting*)sharedManager;
///清空本身记录信息
- (void)UserSettingManagerDestroy;

// 商城登录链接
@property (nonatomic, copy) NSString *yhsdLoginUrl;

//常用基本用户信息
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *username;//云信账号
@property (nonatomic, copy) NSString *password;//云信密码
@property (nonatomic, copy) NSString *voice;//
@property (nonatomic, copy) NSString *shake;//
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *auditStatus;
@property (nonatomic, copy) NSString *userImg;
@property (nonatomic, copy) NSString *backgroupImg;
@property (nonatomic, copy) NSString *roleCode;
@property (nonatomic, strong) NSArray *agencyTids;

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *did;
@property (nonatomic, copy) NSString *aname;
@property (nonatomic, copy) NSString *dname;
@property (nonatomic, copy) NSString *tid;
//是否屏蔽消息
@property (nonatomic,assign) BOOL isCloseMes;
///是否登录
@property (nonatomic,assign) BOOL isLogined;
///初次安装标识
@property (atomic, assign) BOOL isFistInstall;

@end
