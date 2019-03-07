//
//  TKChatMessageCell.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKChatMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView* leftView;
@property (nonatomic, strong) UIImageView* rightView;
@property (nonatomic, strong) UILabel* leftLabel;
@property (nonatomic, strong) UILabel* rightLabel;

@property (nonatomic,strong) UIImageView * lheadimage;
@property (nonatomic,strong) UIImageView * lVideoImage;
@property (nonatomic,strong) UIImageView * rheadimage;
@property (nonatomic,strong) UIImageView * rVideoImage;

@property (nonatomic,strong)UILabel * nameLabel;//用于群聊名字显示

-(void)updateLayout;

@end

