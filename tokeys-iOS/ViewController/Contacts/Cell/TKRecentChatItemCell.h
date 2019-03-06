//
//  TKRecentChatItemCell.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKRecentChatItemCell : UITableViewCell

@property(nonatomic,strong)UIImageView * headImg;

@property(nonatomic,strong)UILabel * titleLab;

+(id)cellWithTableView:(UITableView *)tableView;

@end

