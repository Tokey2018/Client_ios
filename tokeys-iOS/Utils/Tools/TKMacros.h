//
//  TKMacros.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//

#import "TokeyViewTools.h"

#ifdef DEBUG
#define XYLog(FORMAT, ...) fprintf(stderr,"<XLLYLL> %s:%d \t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define XYLog(FORMAT, ...) nil
#endif

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

//布局转化---------new---------------
#define W_In_375(w)  round((w)*[UIScreen mainScreen].bounds.size.width/375.0)
//-------------------------------其他new------------------------
#define FontSize(size) [UIFont systemFontOfSize:size]
#define BoldFontSize(size) [UIFont boldSystemFontOfSize:size]
#define redMainColor rgb(215,51,10)
#define RGB102 rgb(102,102,102)
#define WEAKSELF __weak typeof(self)weakSelf = self;
#define UINavBar_Height  ((screen_height == 812) ? 88.0 : 64.0)
#define UITabBar_Height  ((screen_height == 812) ? 83.0 : 44.0)
