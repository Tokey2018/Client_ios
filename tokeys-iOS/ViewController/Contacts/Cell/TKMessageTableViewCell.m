//
//  messageTableViewCell.m
//  IMshuoyeah
//
//  Created by shuoyeah on 16/3/23.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "TKMessageTableViewCell.h"

@implementation TKMessageTableViewCell

- (void)awakeFromNib {
    //if(self.)
    self.selectButton.layer.cornerRadius = 12;
    self.selectButton.clipsToBounds = YES;
    // Initialization code
   
}
- (IBAction)yaoqing:(UIButton *)sender {
    
    [self.delegate messageTableViewCell:self selectToPeople:self.is];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
