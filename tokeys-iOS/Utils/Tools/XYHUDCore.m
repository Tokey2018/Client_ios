//
//  XYHUDCore.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "XYHUDCore.h"
#import "SVProgressHUD.h"

@implementation XYHUDCore

+(void)showErrorWithStatus:(NSString*)text{
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showErrorWithStatus:text];
    [SVProgressHUD dismissWithDelay:1.0];
}
+(void)showSuccessWithStatus:(NSString*)text{
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showSuccessWithStatus:text];
    [SVProgressHUD dismissWithDelay:1.0];
}

@end
