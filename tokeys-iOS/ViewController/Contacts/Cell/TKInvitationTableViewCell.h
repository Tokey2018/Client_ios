//
//  yaoqingTableViewCell.h
//  IMshuoyeah
//
//  Created by shuoyeah on 16/3/17.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKInvitationTableViewCell;

@protocol TKInvitationTableViewCellDelegate <NSObject>

-(void)invitationTableViewCell:(TKInvitationTableViewCell*)aCell departmentVideo:(NSString *)str;

@end

@interface TKInvitationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yaoqingLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (nonatomic,copy)NSString *userid;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;//圆
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;//文档图片 
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (nonatomic,assign)id<TKInvitationTableViewCellDelegate> delegate;
@end
