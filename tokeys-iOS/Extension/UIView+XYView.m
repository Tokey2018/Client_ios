//
//  UIView+XYView.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "UIView+XYView.h"

@implementation UIView (XYView)

- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}
- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

-(CGFloat)height{
    return self.frame.size.height;
}
-(CGFloat)width{
    return self.frame.size.width;
}
-(void)setHeight:(CGFloat)height{
    CGRect rect   = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
-(void)setWidth:(CGFloat)width{
    CGRect rect   = self.frame;
    rect.size.width= width;
    self.frame = rect;
}
-(CGFloat)x{
    return self.frame.origin.x;
}
-(CGFloat)y{
    return self.frame.origin.y;
}
-(void)setX:(CGFloat)x{
    CGRect rect   = self.frame;
    rect.origin.x= x;
    self.frame = rect;
}
-(void)setY:(CGFloat)y{
    CGRect rect   = self.frame;
    rect.origin.y= y;
    self.frame = rect;
}
-(void)setMaxX:(CGFloat)maxX{
    CGRect rect   = self.frame;
    rect.origin.x= maxX-self.frame.size.width;
    self.frame = rect;
}
-(void)setMaxY:(CGFloat)maxY{
    CGRect rect   = self.frame;
    rect.origin.y= maxY-self.frame.size.height;
    self.frame = rect;
}
-(CGFloat)maxX{
    return self.frame.origin.x+self.frame.size.width;
}
-(CGFloat)maxY{
    return self.frame.origin.y+self.frame.size.height;
}
//***************************************************************************************************************
//************************************          小红点 设置        **********************************************
//***************************************************************************************************************

-(NSString *)badgeString{
    UIView *view = (UIView*)[self viewWithTag:111111];
    UILabel *label = (UILabel*)[view viewWithTag:111112];
    return label.text;
}
-(void)setBadgeString:(NSString *)badgeString{
    UIView *view = (UIView*)[self viewWithTag:111111];
    
    if (badgeString) {
        if (view==nil) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.width-20, -5, 25, 25)];
            UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
            label.text = badgeString;
            view.backgroundColor = [UIColor redColor];
            [self addSubview:view];
            [view addSubview:label];
            view.tag = 111111;
            label.tag= 111112;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            [view setRoundView];
        }else{
            UILabel *label = (UILabel*)[view viewWithTag:111112];
            label.text = badgeString;
        }
        
    }else{
        [view removeFromSuperview];
        view = nil;
    }
}


//***************************************************************************************************************
//************************************          视图形态设置        **********************************************
//***************************************************************************************************************
-(void)setRoundView{
    self.layer.cornerRadius = self.bounds.size.height/2.0;
    self.clipsToBounds = YES;
    //self.layer.masksToBounds = YES;
}
-(void)setRoundViewByAngle:(float)angle{
    self.layer.cornerRadius = angle;
    self.clipsToBounds = YES;
    //self.layer.masksToBounds = YES;
}

-(void)setRoundViewByAngle:(float)angle byRoundingCorners:(UIRectCorner)corners{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(angle, angle)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}
-(void)setBorderWidth:(CGFloat)width borderColor:(UIColor *)color{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}
-(void)setShadowRadius:(CGFloat)shadowRadius opacity:(CGFloat)opacity offset:(CGSize)offset color:(UIColor*)color{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = shadowRadius;
}

@end
