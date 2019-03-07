//
//  TKUrlEditViewController.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKUrlEditViewController : UIViewController

@property (nonatomic,copy)NSString * url;
@property (nonatomic,copy)NSString * nameTitle;//标题
@property (nonatomic,copy)NSString * time;//时间
@property (nonatomic,assign)BOOL isYes;//是否隐藏分享按钮

@end

