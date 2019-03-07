//
//  TKChatMessageCell.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKChatMessageCell.h"

@implementation TKChatMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeView];
    }
    return self;
}

- (void)makeView{
    //设定一行像素，一列像素，当图片拉伸的时候，只放大这两个像素
    //UIImage* leftImage = [UIImage imageNamed:@"对话框2"];
    //UIImage* rightImage = [UIImage imageNamed:@"气泡"];
    //leftImage = [leftImage stretchableImageWithLeftCapWidth:30 topCapHeight:35];
    //rightImage = [rightImage resizableImageWithCapInsets:UIEdgeInsetsMake(28, 32, 28, 32) resizingMode:UIImageResizingModeStretch];
    UIImage * heimage = [UIImage imageNamed:@"chat_d_img"];
    UIImage * video = [UIImage imageNamed:@"play_icon"];
    
    float headerViewSize = 40;
    
    //左边气泡
    self.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 12, 66, 40)];
    self.leftView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    //self.leftView.image = leftImage;
    [self.contentView addSubview:self.leftView];
    
    
    
    //群聊名字
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 0, 250, 10)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:12];
    self.nameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 1, 1)];
    self.leftLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.leftLabel.backgroundColor = [UIColor clearColor];
    self.leftLabel.numberOfLines = 0;
    [self.leftView addSubview:self.leftLabel];
    //头像
    self.lheadimage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, headerViewSize, headerViewSize)];
    self.lheadimage.image = heimage;
    [self.lheadimage setRoundView];
    [self.contentView addSubview:self.lheadimage];
    self.lVideoImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 7, 16, 16)];
    self.lVideoImage.image = video;
    [self.leftView addSubview:self.lVideoImage];
    self.lVideoImage.hidden = YES;
    
    //右边
    self.rightView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-106, 0, 66, 45)];
    self.rightView.backgroundColor = [UIColor colorWithRed:215/255.0 green:51/255.0 blue:10/255.0 alpha:1];
    //self.rightView.image = rightImage;
    [self.contentView addSubview:self.rightView];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 1, 1)];
    self.rightLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.numberOfLines = 0;
    self.rightLabel.textColor = [UIColor whiteColor];
    [self.rightView addSubview:self.rightLabel];
    
    self.rheadimage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-headerViewSize-10, 5, headerViewSize, headerViewSize)];
    self.rheadimage.image = heimage;
    self.rheadimage.layer.cornerRadius = 15;
    self.rheadimage.clipsToBounds = YES;
    [self.contentView addSubview:self.rheadimage];
    self.rVideoImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 7, 16, 16)];
    self.rVideoImage.image = video;
    self.rVideoImage.hidden = YES;
    [self.rightView addSubview:self.rVideoImage];
    
    //    self.lheadimage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 30, 30)];
    //    self.lheadimage.image = heimage;
    //    [self.contentView addSubview:self.lheadimage];
    
}

-(void)updateLayout{
    if (_leftView.hidden == NO) {
        [self.leftView setRoundViewByAngle:10.0 byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft |UIRectCornerBottomRight];
        _leftLabel.y = 0;
        _leftLabel.height = _leftView.height;
        self.leftView.x += 20;
    }
    if (_rightView.hidden == NO) {
        [self.rightView setRoundViewByAngle:10.0 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight |UIRectCornerBottomLeft];
        _rightLabel.y = 0;
        _rightLabel.height = _rightView.height;
        self.rightView.x -= 20;
    }
}

@end
