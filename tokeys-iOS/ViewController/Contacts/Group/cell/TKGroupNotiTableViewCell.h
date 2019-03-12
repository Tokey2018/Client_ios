//
//  TKGroupNotiTableViewCell.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/12.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKGroupNotiModel.h"

@interface TKGroupNotiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *owerName;//标题
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *notiLabel;//公告
@property (weak, nonatomic) IBOutlet UIView *backView;//背景

-(void)loadDatafrom:(TKGroupNotiModel *)model;

@end

