//
//  yaoqingTableViewCell.m
//  IMshuoyeah
//
//  Created by shuoyeah on 16/3/17.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "TKInvitationTableViewCell.h"

@implementation TKInvitationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)departmentVideo:(UIButton *)sender {
    
    [self.delegate invitationTableViewCell:self departmentVideo:self.userid];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
