//
//  XYCameraPhotoCell.h
//  tokeys
//
//  Created by 杨卢银 on 2018/6/7.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYCameraPhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBT;
@property (strong , nonatomic) NSIndexPath *indexPath;
-(void)closeButtonCheck:(void(^)(NSIndexPath *aIndexPath,UIButton*sender))callback;

@end
