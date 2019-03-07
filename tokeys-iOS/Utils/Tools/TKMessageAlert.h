//
//  TKMessageAlert.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TKMessageAlert : NSObject
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}
- (id)initSystemShake;//系统 震动
- (void)play;//播放
-(void)playSound;
@end

