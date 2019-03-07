//
//  TKGroupHeadTableViewCell.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKGroupHeadTableViewCell.h"
#import "TKMineInfoTableViewController.h"

@implementation TKGroupHeadTableViewCell

- (IBAction)bianjiAction:(UIButton *)sender {
    
    
}
-(UIViewController*)findViewController
{
    UIResponder* responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)responder;
        }
        responder = responder.nextResponder;
    } while (responder != nil);
    
    return  nil;
}

- (void)awakeFromNib {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.Back addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bianjilick)];
    [self.bianjiAction addGestureRecognizer:tap11];
    
    
    UITapGestureRecognizer * tap22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(renzhenglick)];
    [self.renzhen addGestureRecognizer:tap22];
    
    self.personLabel.layer.cornerRadius = 20;
    self.personLabel.clipsToBounds = YES;
    // Initialization code
}

-(void)bianjilick{
    
    TKMineInfoTableViewController* booking = [[TKMineInfoTableViewController alloc]init];
    [[self findViewController].navigationController pushViewController:booking animated:YES];
    
}

-(void)renzhenglick{
    
    [self.rdelegate groupHeadTableViewCell:self renzhengToPeople:nil];
    
}

-(void)tapClick{
    
    [self.delegate groupHeadTableViewCell:self selectToPeople:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)groupChat:(UIButton *)sender {
    if(_rdelegate){
        [_rdelegate groupHeadTableViewCell:self groupChatToCheck:nil];
    }
}

@end
