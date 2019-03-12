//
//  TKDocHeaderTableViewCell.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKDocHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像

@property (weak, nonatomic) IBOutlet UILabel *code;//执业编码

@property (weak, nonatomic) IBOutlet UILabel *docName;//医生名字

@end

