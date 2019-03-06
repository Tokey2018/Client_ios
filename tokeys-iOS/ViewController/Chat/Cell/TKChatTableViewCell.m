//
//  TKChatTableViewCell.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//
#import "TKChatTableViewCell.h"

@implementation TKChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callback)];
    [self.callLabel addGestureRecognizer:tap];
}

-(void)callback{

    [self.delegate chatTableViewCell:self callTopeople:self.number];

}

- (IBAction)callButton:(UIButton *)sender {
    
    [self.delegate chatTableViewCell:self callTopeople:self.number];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
