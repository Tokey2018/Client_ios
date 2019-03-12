//
//  XYCircleProgress.h
//  tokeys
//
//  Created by 杨卢银 on 2018/6/7.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCircleProgressLayer.h"

@interface XYCircleProgress : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UILabel * progressLabel;

@property (strong,nonatomic) XYCircleProgressLayer * circleProgressLayer;

@end
