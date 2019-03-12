//
//  TKAddFriendTableViewCell.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKAddFriendTableViewCell;

@protocol TKAddFriendTableViewCellDelegate <NSObject>

-(void)addFriendTableViewCell:(TKAddFriendTableViewCell*)aCell addMyFriend:(NSInteger)num;

@end

@interface TKAddFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *name;//姓名
@property (weak, nonatomic) IBOutlet UILabel *zhicheng;//职称
@property (weak, nonatomic) IBOutlet UILabel *section;//部门
@property (weak, nonatomic) IBOutlet UILabel *hospital;//医院
@property (weak, nonatomic) IBOutlet UIButton *addFriend;//添加朋友
@property (nonatomic,assign)id<TKAddFriendTableViewCellDelegate>delegate;
- (IBAction)addButton:(UIButton *)sender;

@end

