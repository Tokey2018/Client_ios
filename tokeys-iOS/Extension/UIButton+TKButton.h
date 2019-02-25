//
//  UIButton+TKButton.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/25.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (TKButton)

/**
 倒计时按钮
 
 @param beginColor 按钮初始颜色
 @param changeColor 倒计时背景色
 */
- (void)sendMessageBegin:(UIColor*)beginColor andChange:(UIColor*)changeColor;

@end

