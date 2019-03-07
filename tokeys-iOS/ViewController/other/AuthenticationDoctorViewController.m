//
//  AuthenticationDoctorViewController.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/20.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "AuthenticationDoctorViewController.h"

@interface AuthenticationDoctorViewController ()
@property (weak, nonatomic) IBOutlet UIButton *conmitBT;

@end

@implementation AuthenticationDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.conmitBT setRoundViewByAngle:5.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
