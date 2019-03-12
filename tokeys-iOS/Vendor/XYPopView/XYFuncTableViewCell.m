//
//  XYFuncTableViewCell.m
//  FUGenealogySDK
//
//  Created by 杨卢银 on 16/8/29.
//  Copyright © 2016年 杨卢银. All rights reserved.
//

#import "XYFuncTableViewCell.h"
#import "XYFuncModel.h"

@implementation XYFuncTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, rowH - 0.5)];
    [path addLineToPoint:CGPointMake(width - 10, rowH - 0.5)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.path = path.CGPath;
    layer.lineWidth = 0.5;
    [self.layer addSublayer:layer];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setFuncModel:(XYFuncModel *)funcModel{
    _funcModel = funcModel;
    self.titleLabel.text = _funcModel.title;
    self.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    self.iconImgView.image = [UIImage imageNamed:_funcModel.iconName];
}

@end
