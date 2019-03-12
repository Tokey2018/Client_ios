//
//  XYCameraPhotoCell.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/7.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "XYCameraPhotoCell.h"
@interface XYCameraPhotoCell()
{
    void (^deleteButtonBack)(NSIndexPath*,UIButton*);
}
@end
@implementation XYCameraPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_closeBT setRoundView];
}
- (IBAction)closeBTSelect:(id)sender {
    if (deleteButtonBack) {
        deleteButtonBack(_indexPath,sender);
    }
}
-(void)closeButtonCheck:(void (^)(NSIndexPath *, UIButton *))callback{
    deleteButtonBack = callback;
}

@end
