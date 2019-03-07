//
//  YLYTextView.h
//  zishu-ios
//
//  Created by 杨卢银 on 15/10/8.
//  Copyright © 2015年 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

typedef enum : NSUInteger {
    YLYTextViewTypeDefault,
    YLYTextViewTypeLimit,
} YLYTextViewType;

typedef enum ylytagBorderType
{
    YLYBorderTypeDashed,
    YLYBorderTypeSolid
}YLYBorderType;

@interface YLYTextView : UITextView
{
    CAShapeLayer *_shapeLayer;
    
    YLYBorderType _borderType;
    CGFloat _cornerRadius;
    CGFloat _borderWidth;
    NSUInteger _dashPattern;
    NSUInteger _spacePattern;
    UIColor *_borderColor;
}


@property (assign, nonatomic) YLYBorderType borderType;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) NSUInteger dashPattern;
@property (assign, nonatomic) NSUInteger spacePattern;
@property (strong, nonatomic) UIColor *borderColor;

@property(assign , nonatomic)YLYTextViewType textType;
/**
 * 提示文字
 */
@property(copy , nonatomic) NSString *placeholder;
@property(copy , nonatomic) UIColor  *placeholderColor;
@property(copy , nonatomic) UIFont   *placeholderFont;



@end
