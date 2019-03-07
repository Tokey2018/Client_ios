//
//  AuthenticationViewController.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/20.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "AuthenticationDoctorViewController.h"
#import "AuthenticationSurgeonViewController.h"

@interface AuthenticationViewController ()
{
    NSInteger _selectIndex;
}
@property (strong , nonatomic) AuthenticationDoctorViewController  *doctorVC;
@property (strong , nonatomic) AuthenticationSurgeonViewController *surgeonVC;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"医生认证";
    _selectIndex= 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self buildSubViewCotrollers];
}
- (IBAction)segmentChange:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0){
        self.title = @"医生认证";
        if (_selectIndex != 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(0, 0);
            } completion:^(BOOL finished) {
                _selectIndex = 0;
            }];
        }
    }else{
        self.title = @"军医认证";
        if (_selectIndex!=1) {
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(self.scrollView.width, 0);
            } completion:^(BOOL finished) {
                _selectIndex = 1;
            }];
        }
    }
}
-(void)buildSubViewCotrollers{
    self.doctorVC.view.frame = CGRectMake(0, 0, _scrollView.width, _scrollView.height);
    [self.scrollView addSubview:self.doctorVC.view];
    
    self.surgeonVC.view.frame = CGRectMake(_scrollView.width, 0, _scrollView.width, _scrollView.height);
    [self.scrollView addSubview:self.surgeonVC.view];
    self.scrollView.contentSize = CGSizeMake(_scrollView.width*2.0, _scrollView.height);
    self.scrollView.pagingEnabled = YES;
    
}
#pragma mark setget
-(AuthenticationDoctorViewController *)doctorVC{
    if (!_doctorVC) {
        _doctorVC = [[AuthenticationDoctorViewController alloc] init];
    }
    return _doctorVC;
}
-(AuthenticationSurgeonViewController *)surgeonVC{
    if (!_surgeonVC) {
        _surgeonVC = [[AuthenticationSurgeonViewController alloc] init];
    }
    return _surgeonVC;
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
