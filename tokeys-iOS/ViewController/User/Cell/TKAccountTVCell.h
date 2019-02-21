//
//  TKAccountTVCell.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKAccountTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

- (IBAction)deleteClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property(nonatomic,copy) void(^myBlock)(void);


@end

