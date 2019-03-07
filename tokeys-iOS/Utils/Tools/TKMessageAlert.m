//
//  TKMessageAlert.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKMessageAlert.h"

@implementation TKMessageAlert
- (id)initSystemShake
{
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

-(void)playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"liujianji" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:path]),&sound);
        AudioServicesPlaySystemSound(sound);
        
    }
    
    AudioServicesPlaySystemSound(sound);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (void)play
{
    AudioServicesPlaySystemSound(sound);
}
@end
