//
//  UIView+XYView.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+TKImageView.h"

@interface UIView (XYView)


@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
/**
 *视图宽度
 */
@property (nonatomic,assign) CGFloat width;
/**
 *视图高度
 */
@property (nonatomic,assign) CGFloat height;

/**
 *视图X坐标
 */
@property (nonatomic,assign) CGFloat x;
/**
 *视图Y坐标
 */
@property (nonatomic,assign) CGFloat y;

/**
 *视图X坐标（最大）
 */
@property (nonatomic,assign) CGFloat maxX;
/**
 *视图Y坐标 （最大）
 */
@property (nonatomic,assign) CGFloat maxY;


/**
 * 小红点
 */
@property (nonatomic,copy) NSString *badgeString;


/**
 *设置为圆形视图
 */
-(void)setRoundView;

/**
 *设置为圆角视图<angle 角度>
 */
-(void)setRoundViewByAngle:(float)angle;

-(void)setRoundViewByAngle:(float)angle byRoundingCorners:(UIRectCorner)corners;

//-(void)setShadow:(float)width color:(UIColor*)color;
//-(void)setShadowBorderWidth:(CGFloat)width borderColor:(UIColor*)color;
/**
 * 设置view 的 边线
 */
-(void)setBorderWidth:(CGFloat)width borderColor:(UIColor*)color;


/**
 设置实图阴影
 
 @param shadowRadius 阴影角度
 @param opacity 阴影线条大小
 @param offset 偏移量
 @param color 颜色
 */
-(void)setShadowRadius:(CGFloat)shadowRadius opacity:(CGFloat)opacity offset:(CGSize)offset color:(UIColor*)color;

@end

