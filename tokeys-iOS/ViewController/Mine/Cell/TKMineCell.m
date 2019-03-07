//
//  TKMineCell.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKMineCell.h"

@interface TKMineCell()

@property (nonatomic, weak) UIImageView *cellImg;

@property (nonatomic, weak) UIImageView *rightImg;

@property (nonatomic, weak) UILabel *cellTitle;

@end

@implementation TKMineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *cellImg=[[UIImageView alloc] init];
        cellImg.frame=CGRectMake(15, (50-25)/2.0, 25, 25);
        self.cellImg=cellImg;
        [self addSubview:cellImg];
        
        UILabel *cellTitle=[[UILabel alloc]init];
        [cellTitle setBackgroundColor:[UIColor clearColor]];
        [cellTitle setTextColor:[UIColor darkGrayColor]];
        [cellTitle setFont:[UIFont boldSystemFontOfSize:15]];
        cellTitle.textAlignment=NSTextAlignmentLeft;
        [self addSubview:cellTitle];
        cellTitle.frame=CGRectMake(15+CGRectGetMaxX(cellImg.frame), 0,[UIScreen mainScreen].bounds.size.width-(15+CGRectGetMaxX(cellImg.frame)), 50);
        self.cellTitle=cellTitle;
        
        
    }
    return self;
}

- (void)setImageName:(NSString *)imageName
{
    self.cellImg.image=[UIImage imageNamed:imageName];
}

- (void)setTitleStr:(NSString *)titleStr
{
    self.cellTitle.text=titleStr;
    
}
-(void)openRightImage{
    if (!_rightImg) {
        float  s = 20;
        UIImageView *rimge=[[UIImageView alloc] init];
        rimge.frame=CGRectMake(screen_width - s - 10, (50-s)/2.0, s, s);
        rimge.image = [UIImage imageNamed:@"call_icon_list"];
        self.rightImg=rimge;
        [self addSubview:self.rightImg];
    }
}
-(void)setRightIconOn:(BOOL)rightIconOn{
    _rightIconOn = rightIconOn;
    if (_rightIconOn==YES) {
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(90.0 * M_PI/180.0);
            [self.rightImg setTransform:transform];
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(0 * M_PI/180.0);
            [self.rightImg setTransform:transform];
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
