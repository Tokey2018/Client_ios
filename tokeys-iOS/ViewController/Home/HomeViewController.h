//
//  HomeViewController.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeViewController;

@protocol HomeViewControllerDelegate <NSObject>
    
@optional
- (void)homeViewController:(HomeViewController*)homeVC leftBtnClicked:(id)sender;
- (void)homeViewController:(HomeViewController*)homeVC closeBtnClicked:(id)sender;
    
@end


@interface HomeViewController : UIViewController
    
@property (weak, nonatomic) id<HomeViewControllerDelegate> delegate;

@end

