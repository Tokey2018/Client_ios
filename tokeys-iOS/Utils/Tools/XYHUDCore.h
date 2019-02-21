//
//  XYHUDCore.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XYHUDCore : NSObject

+(void)showSuccessWithStatus:(NSString*)text;

+(void)showErrorWithStatus:(NSString*)text;

@end

