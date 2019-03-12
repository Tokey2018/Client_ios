//
//  XYCircleProgress.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/7.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "XYCircleProgress.h"

@implementation XYCircleProgress

- (void)drawRect:(CGRect)rect {
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.circleProgressLayer = [XYCircleProgressLayer layer];
        self.circleProgressLayer.frame = self.bounds;
        //像素大小比例
        self.circleProgressLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.circleProgressLayer];
        
        self.progressLabel = [[UILabel alloc]initWithFrame:self.bounds];
        self.progressLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.9 alpha:1.0];
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        self.progressLabel.font = [UIFont systemFontOfSize:30.0];
        self.progressLabel.text = @"0 %";
        [self addSubview:self.progressLabel];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"progress"];
    ani.duration = 5.0 * fabs(progress - _progress);
    ani.toValue = @(progress);
    ani.removedOnCompletion = YES;
    ani.fillMode = kCAFillModeForwards;
    ani.delegate = self;
    [self.circleProgressLayer addAnimation:ani forKey:@"progressAni"];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%0.f%%", progress * 100];
    _progress = progress;
    //    self.circleProgressLayer.progress = progress;
    //    [self.circleProgressLayer setNeedsDisplay];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.circleProgressLayer.progress = self.progress;
}
@end
