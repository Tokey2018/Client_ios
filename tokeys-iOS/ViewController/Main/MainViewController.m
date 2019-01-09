//
//  MainViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//

#import "MainViewController.h"
#import "MainSlideViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(pushHomeOrLogin) withObject:nil afterDelay:1];
}

-(void)pushHomeOrLogin{
    
    MainSlideViewController *homeVC = [[MainSlideViewController alloc] init];
    
    [self presentViewController:homeVC animated:YES completion:^{
        
    }];
}

@end
