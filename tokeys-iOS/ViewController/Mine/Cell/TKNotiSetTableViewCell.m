//
//  TKNotiSetTableViewCell.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKNotiSetTableViewCell.h"

@implementation TKNotiSetTableViewCell

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)awakeFromNib {
    // Initialization code
    [self.seleButton setRoundViewByAngle:5.0];
    [self.seleButton setBorderWidth:1.0 borderColor:[UIColor lightGrayColor]];
    
    [self.seleButton setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.seleButton setBackgroundImage:[self createImageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
    [self.seleButton setImage:nil forState:UIControlStateNormal];
    [self.seleButton setImage:[UIImage imageNamed:@"col_icon_sel"] forState:UIControlStateSelected];
}
- (IBAction)xuanzhe:(UIButton *)sender {
    
    self.seleButton.selected = !self.seleButton.selected;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
