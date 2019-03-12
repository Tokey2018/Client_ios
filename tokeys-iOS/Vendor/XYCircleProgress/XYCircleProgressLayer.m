//
//  XYCircleProgressLayer.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/7.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "XYCircleProgressLayer.h"

@implementation XYCircleProgressLayer

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat radius = self.bounds.size.width / 2;
    CGFloat lineWidth = 5.0;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius - lineWidth / 2 startAngle:M_PI * (-0.5) endAngle:(M_PI * 2 * self.progress) - M_PI_2 clockwise:YES];
    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.9, 1.0);//笔颜色
    CGContextSetLineWidth(ctx, lineWidth);//线条宽度
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
}
- (instancetype)initWithLayer:(XYCircleProgressLayer *)layer {
    if (self = [super initWithLayer:layer]) {
        self.progress = layer.progress;
    }
    return self;
}
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

@end
