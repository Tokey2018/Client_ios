//
//  TokeyViewTools.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import<CommonCrypto/CommonDigest.h>
#import "TKJudgeSummary.h"

/**
 颜色相关
 */
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define WHSCALE_WIDTH            [UIScreen mainScreen].bounds.size.width/375.f
#define WHSCALE_HEIGHT           [UIScreen mainScreen].bounds.size.height/667.f
typedef void(^trueBack)(NSString * ss);

@interface TokeyViewTools : NSObject<UIAlertViewDelegate>{
    
    
}
@property (nonatomic , copy) trueBack  trueBack;
/*
 ==================================
 按钮
 ==================================
 */
/**基本按钮无图*/
+ (UIButton *)createButtonWithFrame:(CGRect)rect andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andBgColor:(UIColor *)bgColor andSelecter:(SEL)sel andTarget:(id)target;
/**基本按钮图*/
+ (UIButton *)createButtonWithFrame:(CGRect)rect andImage:(UIImage *)image andSelecter:(SEL)sel andTarget:(id)target;
/**按钮带图文字*/
+ (UIButton *)createButtonWithFrame:(CGRect)rect andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andImage:(UIImage *)image  andSelecter:(SEL)sel andTarget:(id)target andBgColor:(UIColor *)bgColor;
/*
 ================================================
 label
 ================================================
 */
/**基本label*/
+(UILabel *)createLabelWithFrame:(CGRect)rect andTitle:(NSString *)title andTitleFont:(UIFont *)titleFont andTitleColor:(UIColor *)titleColor andTextAlignment:(NSTextAlignment)alignment andBgColor:(UIColor *)bgColor;
/**行数 文字大小 自适应label高度*/
+(UILabel *)createLabelWithFrame:(CGRect)rect andTitle:(NSString *)title andTitleFont:(UIFont *)titleFont andTitleColor:(UIColor *)titleColor andTextAlignment:(NSTextAlignment)alignment  andBgColor:(UIColor *)bgColor andLines:(NSInteger)numberOfLines andAdjustsFontSizeToFiWidth:(BOOL)sizeBool;
/** 自适应文字高度*/
+(UILabel *)createLabelWithFrame:(CGRect)rect andTitle:(NSString *)title andTitleFont:(UIFont *)titleFont andTitleColor:(UIColor *)titleColor andTextAlignment:(NSTextAlignment)alignment  andBgColor:(UIColor *)bgColor andCGSizeWIDTH:(CGFloat )width;
/** label内容颜色不一样*/
+(UILabel *)createLabelTextWithView:(UILabel *)label andwithChangeColorTxt:(NSString *)string withColor:(UIColor *)color withFont:(UIFont*)font;
/** 计算文本内容高度*/
+(CGSize)countTxtWith:(NSString *)text andWithFont:(UIFont *)font with:(CGFloat)width;

/*
 ================================================
 导航栏按钮
 ================================================
 */
/**导航栏按钮*/

+(UIBarButtonItem *)createButtonItemWith:(UIView *)customView;

/*
 ================================================
 view
 ================================================
 */
/**基本view*/
+(UIView *)createViewWithFrame:(CGRect)rect andBgColor:(UIColor *)bgColor;
/**特殊View*/
+(UIView *)createViewWithFrame:(CGRect)rect andBgColor:(UIColor *)bgColor andCornerRaduis:(CGFloat)corner andBorderWidth:(CGFloat)border andBorderColor:(UIColor *)bdColor shadowColor:(UIColor *)shadowColor andShadowOffset:(CGSize)offset andShadowOpacity:(float)opacity andShadowRadius:(CGFloat)radius;
/*
 ================================================
 Image
 ================================================
 */
/**image*/
+(UIImageView *)createImageViewWithFrame:(CGRect)rect andImage:(UIImage *)image andBgColor:(UIColor *)bgColor;
/**imageName*/
+(UIImageView *)createImageViewWithFrame:(CGRect)rect andImageName:(NSString *)imageName andBgColor:(UIColor *)bgColor;
/**image路径*/
+(UIImageView *)createImageViewWithFrame:(CGRect)rect andImageResource:(NSString *)imageResource andImageType:(NSString *)typpe andBgColor:(UIColor *)bgColor;

/*
 ================================================
 UITextField
 ================================================
 */
/**
 textField
 */
+(UITextField *)createTextFieldFrame:(CGRect)rect andBgColor:(UIColor *)bgColor andPlaceholder:(NSString *)placeholder andTextColor:(UIColor *)textColor andTextFont:(UIFont * )font andTextAlignment:(NSTextAlignment)alignment andSecureText:(BOOL)secure andBorderStyle:(UITextBorderStyle)borderStyle andReturnType:(UIReturnKeyType)returnType andClearButtonMode:(UITextFieldViewMode)buttonMode;

/**
 简化输入框
 */
+(UITextField *)createTextFieldFrame:(CGRect)rect andPlaceholder:(NSString *)placeholder andTextColor:(UIColor *)textColor andTextFont:(UIFont * )font andReturnType:(UIReturnKeyType)returnType;
//RGB颜色转换
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

+(CGRect)boundsWithFonttext:(NSString *)text needWidth:(CGFloat)needWidth lineSpacing:(CGFloat )lineSpacing;
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
//-------------------------------------------------获取通讯录-----------------------

+(NSMutableArray *)getMyPhoneBook;

/**
 *  直接拨打电话
 *
 *  @param phoneNum 电话号码
 */
+ (void)directPhoneCallWithPhoneNum:(NSString *)phoneNum;

/**
 控件横向抖动
 
 @param view 要抖动的控件
 */
+(void)loadShakeAnimationForView:(UIView*)view;

+(UILabel *)createHeiLabelTextWithView:(UILabel *)label andwithChangeColorTxt:(NSString *)string withColor:(UIColor *)color withFont:(UIFont*)font;
/**
 设置圆角
 
 @param corners  UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 UIRectCornerAllCorners  = ~0UL
 
 @param cornerRadius float
 */
+ (void)roundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius with:(UIView*)setView;

/**
 提示快捷创建
 
 @param viewController self
 @param string 提示语
 */
+(void)showAlertViewIn:(UIViewController*)viewController andNoti:(NSString*)string;
@end
