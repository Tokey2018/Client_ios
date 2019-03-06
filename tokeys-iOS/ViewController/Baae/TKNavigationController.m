//
//  TKNavigationController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKNavigationController.h"
#import "UIView+TouchAreaInsets.h"

@interface TKNavigationController ()

@end

@implementation TKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航控制器
    self.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0){
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_btn_back_icon.png"] landscapeImagePhone:[UIImage imageNamed:@"nav_btn_back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:viewController animated:animated];
    
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
