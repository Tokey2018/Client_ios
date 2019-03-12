//
//  XYPopView.h
//  FUGenealogySDK
//
//  Created by 杨卢银 on 16/8/29.
//  Copyright © 2016年 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+RTTint.h"

typedef void(^FuncBlock)(NSInteger index);

@interface XYPopView : UIView
/**
 *  里面存储funcModel对象
 */
@property (nonatomic, strong) NSMutableArray *funcModels;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, copy) FuncBlock menuSelectBlock;

@property (nonatomic, copy) FuncBlock menuIconSelectBlock;

// 功能模型数组
+ (instancetype)popViewWithFuncModels:(NSArray *)funcModels;
// 功能字典数组
+ (instancetype)popViewWithFuncDicts:(NSArray *)funcDicts;

+ (instancetype)popViewWithFuncDicts:(NSArray *)funcDicts x:(CGFloat)x y:(CGFloat)y;

- (void)showInKeyWindow;
- (void)showInView:(UIView*)view;

- (void)dismissFromKeyWindow;

@end
