//
//  TKGroupHeadTableViewCell.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKGroupHeadTableViewCell;

@protocol TKGroupHeadSelectDelegate <NSObject>

- (void)groupHeadTableViewCell:(TKGroupHeadTableViewCell*)aCell selectToPeople:(id)asender;

@end
@protocol TKGroupHeadRenzhengDelegate <NSObject>

- (void)groupHeadTableViewCell:(TKGroupHeadTableViewCell*)aCell renzhengToPeople:(id)asender;

- (void)groupHeadTableViewCell:(TKGroupHeadTableViewCell*)aCell groupChatToCheck:(id)asender;

@end

@interface TKGroupHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Back;
@property (weak, nonatomic) IBOutlet UILabel*personLabel;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//姓名
@property (weak, nonatomic) IBOutlet UIButton *groupChatButton;//群聊
@property (weak, nonatomic) IBOutlet UIImageView *groupHeadImage;//群头像
- (IBAction)groupChat:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *bianji;
@property (weak, nonatomic) IBOutlet UILabel *bianjiAction;
@property (weak, nonatomic) IBOutlet UILabel *renzhen;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *shenheImage;//审核状态图片
@property (weak, nonatomic) IBOutlet UIButton *penButton;

@property (weak, nonatomic) IBOutlet UIButton *bianjiClick;//编辑按钮
@property (nonatomic,assign) id<TKGroupHeadSelectDelegate>delegate;
@property (nonatomic,assign) id<TKGroupHeadRenzhengDelegate>rdelegate;

@end

