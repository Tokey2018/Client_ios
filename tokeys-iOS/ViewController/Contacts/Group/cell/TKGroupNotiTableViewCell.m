//
//  TKGroupNotiTableViewCell.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/12.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKGroupNotiTableViewCell.h"

@implementation TKGroupNotiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.backView.layer.borderWidth = 1;
    self.backView.layer.cornerRadius = 4;
    // Initialization code
}

-(void)loadDatafrom:(TKGroupNotiModel *)model{
    
    self.owerName.text = model.title;
    self.timeLabel.text = model.addTime;
    self.notiLabel.text = model.content;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
