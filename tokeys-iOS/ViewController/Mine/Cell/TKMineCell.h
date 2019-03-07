//
//  TKMineCell.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKMineCell : UITableViewCell

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *titleStr;

-(void)openRightImage;

@property (assign , nonatomic) BOOL rightIconOn;

@end

