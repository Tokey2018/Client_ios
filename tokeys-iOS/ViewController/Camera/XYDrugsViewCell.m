//
//  XYDrugsViewCell.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/28.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "XYDrugsViewCell.h"
@interface XYDrugsViewCell()
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *showlabel;

@end
@implementation XYDrugsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_showView setRoundViewByAngle:5.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setShowTitle:(NSString *)showTitle{
    _showTitle = showTitle;
    _showlabel.text= _showTitle;
}
-(void)setShowImage:(UIImage *)showImage{
    _showImage = showImage;
    _showImageView.image = _showImage;
}
@end
