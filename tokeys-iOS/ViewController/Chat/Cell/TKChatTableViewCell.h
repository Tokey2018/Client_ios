//
//  TKChatTableViewCell.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKChatTableViewCell;

@protocol TKChatTableViewCellDelegate <NSObject>

-(void)chatTableViewCell:(TKChatTableViewCell*)aCell callTopeople:(NSInteger)number;

@end


@interface TKChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *Lastbutton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;//文档图片
@property (nonatomic,assign)NSInteger number;//当前会话;
@property (weak, nonatomic) IBOutlet UILabel *callLabel;
@property (nonatomic,assign)id<TKChatTableViewCellDelegate>delegate;

@end
