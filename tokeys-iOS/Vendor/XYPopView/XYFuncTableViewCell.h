//
//  XYFuncTableViewCell.h
//  FUGenealogySDK
//
//  Created by 杨卢银 on 16/8/29.
//  Copyright © 2016年 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYFuncModel;
// cell的高度和宽度
static const CGFloat width = 150;
static const CGFloat rowH = 50;
@interface XYFuncTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (nonatomic, strong) XYFuncModel *funcModel;

@end
