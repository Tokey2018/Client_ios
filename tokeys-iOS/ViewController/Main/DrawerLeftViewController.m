//
//  DrawerLeftViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "DrawerLeftViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface DrawerLeftViewController ()

@property (strong , nonatomic) UIImageView *userHeaderImageView;

@property (strong , nonatomic) UILabel *userNameLabel;

@property (strong , nonatomic) UILabel *userPhoneLabel;

@end

@implementation DrawerLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars =YES;
    
    [self createUI];
}

-(void)createUI{
    
    UIImageView * headImg = [TokeyViewTools createImageViewWithFrame:CGRectMake(W_In_375(36), W_In_375(80), W_In_375(68), W_In_375(68)) andImageName:@"User" andBgColor:nil];
    [self.view addSubview:headImg];
    headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)];
    _userHeaderImageView = headImg;
    [_userHeaderImageView addGestureRecognizer:tapGesture];
    
    UILabel * nameLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(10)+CGRectGetMaxX(headImg.frame), W_In_375(85), W_In_375(200), W_In_375(30)) andTitle:@"用户名称" andTitleFont:FontSize(W_In_375(18)) andTitleColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:nameLabel];
    _userNameLabel = nameLabel;
    //_userNameLabel.text = [LJUserSetting sharedManager].nick;
    
    
    UILabel * phoneLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(10)+CGRectGetMaxX(headImg.frame), CGRectGetMaxY(nameLabel.frame), W_In_375(160), W_In_375(20)) andTitle:@"135 XXXX XXXX" andTitleFont:FontSize(W_In_375(14)) andTitleColor:RGB102 andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:phoneLabel];
    _userPhoneLabel = phoneLabel;
    
    NSString *tenDigitNumber = @"13218991231";//[LJUserSetting sharedManager].phone;
    tenDigitNumber = [tenDigitNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{4})(\\d{4})"
                                                               withString:@"$1 $2 $3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [tenDigitNumber length])];
    NSLog(@"%@", tenDigitNumber);
    
    _userPhoneLabel.text = tenDigitNumber;
    
    UIView * line1 = [TokeyViewTools createViewWithFrame:CGRectMake(0, CGRectGetMaxY(headImg.frame)+W_In_375(40), W_In_375(300), 1) andBgColor:rgb(246, 246, 246)];
    [self.view addSubview:line1];
    
   
    
    
}

/**
 应用中心
 */
-(void)appClick{
    
    
}
- (void)updateUI{
    
}
/**
 点击个人中心
 */
-(void)headClick{
    
    if (self.delegate) {
        [self.delegate drawerLeftLJJVC:self userHeaderClicked:nil];
    }
    
    //    personDataViewController * person = [[personDataViewController alloc]init];
    //    person.isJump = YES;
    //    //[self setViewController:person];
    //    [self.rootViewController.navigationController pushViewController:person animated:YES];
}

- (void)setViewController:(UIViewController *)viewController{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
    // UITabBarController * nav = (UITabBarController*)self.mm_drawerController.centerViewController;
    UINavigationController *vc = (UINavigationController*)self.mm_drawerController.centerViewController;
    [vc pushViewController:viewController animated:YES];
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
