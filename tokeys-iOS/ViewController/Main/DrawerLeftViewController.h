//
//  DrawerLeftViewController.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawerLeftViewController;

@protocol DrawerLeftViewControllerDelegate <NSObject>

@optional
- (void)drawerLeftViewController:(DrawerLeftViewController*)drawerVC userHeaderClicked:(id)sender;
- (void)drawerLeftViewController:(DrawerLeftViewController*)drawerVC appCenterClicked:(id)sender;

@end

@interface DrawerLeftViewController : UIViewController

@property (weak , nonatomic) id<DrawerLeftViewControllerDelegate>delegate;

@end

