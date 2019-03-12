//
//  messageTableViewCell.h
//  IMshuoyeah
//
//  Created by shuoyeah on 16/3/23.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKMessageTableViewCell;

@protocol TKMessageTableViewCellDelegate <NSObject>

- (void)messageTableViewCell:(TKMessageTableViewCell*)aCell selectToPeople:(NSIndexPath*)number;

@end
@interface TKMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *namelABEL;//名字
@property (weak, nonatomic) IBOutlet UILabel *INFO;//介绍
@property (nonatomic,strong)NSIndexPath *is;
@property (nonatomic,assign)BOOL isselel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *mainLbael;//单行显示名字
@property (nonatomic,assign) id<TKMessageTableViewCellDelegate>delegate;
@end
