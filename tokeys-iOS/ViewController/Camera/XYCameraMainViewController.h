//
//  XYCameraMainViewController.h
//  tokeys
//
//  Created by 杨卢银 on 2018/6/28.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYCameraMainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(void)openMenu;
-(void)dismissMenu;

@end
