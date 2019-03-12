//
//  TKAddFriendTableViewCell.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKAddFriendTableViewCell.h"

@implementation TKAddFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addFriend.layer.cornerRadius = 4;
    self.addFriend.layer.borderWidth = 1;
    self.addFriend.layer.borderColor = [blcolor CGColor];
    
    
    self.headImage.layer.cornerRadius = 30;
    self.headImage.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)addButton:(UIButton *)sender {
    
    [self.delegate addFriendTableViewCell:self addMyFriend:sender.tag];
}

@end
