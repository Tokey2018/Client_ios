//
//  MainViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//

#import "MainViewController.h"
#import "MainSlideViewController.h"
#import "TKUserLoginViewController.h"
#import "TKNavigationController.h"
#import "TKUserSetting.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(pushHomeOrLogin) withObject:nil afterDelay:1];
}

-(void)pushHomeOrLogin{
    
//    if([TKUserSetting sharedManager].isFistInstall){
//
//    }else{
//        self.window.rootViewController =  [[welcomePageViewController alloc]init];
//    }
    
    
    if (![TKUserSetting sharedManager].isLogined) {
        TKUserLoginViewController *userlogin = [[TKUserLoginViewController alloc] init];
        TKNavigationController *nav = [[TKNavigationController alloc] initWithRootViewController:userlogin];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }else{
        
        [[TKCore shareCore] autoLogin];
        MainSlideViewController *homeVC = [[MainSlideViewController alloc] init];
        
        [self presentViewController:homeVC animated:YES completion:^{
            
        }];
    }
    
    
}

@end
