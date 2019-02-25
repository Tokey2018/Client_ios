//
//  TKUserFindPassVerifyPhoneViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKUserFindPassVerifyPhoneViewController.h"
#import "TKSMSAction.h"
#import "TKFindPassVerificationCodeViewController.h"

@interface TKUserFindPassVerifyPhoneViewController ()
{
    UITextField * _phoneText;
}

@end

@implementation TKUserFindPassVerifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全检测";
    [self back_safety_icon];
    
    // Do any additional setup after loading the view.
}

-(void)createRightItem{
    UIButton * rightBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(0, 0, W_In_375(70), W_In_375(40)) andTitle:@"下一步" andTitleColor:redMainColor andBgColor:nil andSelecter:@selector(nextClick) andTarget:self];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)back_safety_icon{
    
    
    UIView *back_safetyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    [self.view addSubview:back_safetyView];
    float size = 160;
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((back_safetyView.width - size)/2.0, 180, size, size)];
    centerImageView.image = [UIImage imageNamed:@"back_safety_icon"];
    [back_safetyView addSubview:centerImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, centerImageView.maxY+20, back_safetyView.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"安全检测中...";
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor colorWithRed:51.0026/255.0 green:51.0026/255.0 blue:51.0026/255.0 alpha:1];
    [back_safetyView addSubview:label];
    
    [self performSelector:@selector(setup:) withObject:back_safetyView afterDelay:2.0];
    
}

-(void)setup:(UIView*)sender{
    self.title = @"";
    sender.hidden = YES;
    [self createRightItem];
    [self createUI];
}
-(void)createUI{
    
    UILabel * titleLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(20), W_In_375(100), screen_width-W_In_375(40), W_In_375(40)) andTitle:@"验证手机号" andTitleFont:BoldFontSize(W_In_375(36)) andTitleColor:rgb(51, 51, 51) andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:titleLabel];
    
    UILabel * phoneLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(30), CGRectGetMaxY(titleLabel.frame)+W_In_375(93), W_In_375(60), W_In_375(17)) andTitle:@"手机号" andTitleFont:FontSize(W_In_375(18)) andTitleColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:phoneLabel];
    
    _phoneText = [TokeyViewTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame)+W_In_375(30), CGRectGetMaxY(titleLabel.frame)+W_In_375(93), W_In_375(240), W_In_375(17)) andPlaceholder:@"请输入您的手机号" andTextColor:[UIColor blackColor] andTextFont:FontSize(W_In_375(18)) andReturnType:UIReturnKeyDone];
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneText];
    UIView *phoneLine = [TokeyViewTools createViewWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(_phoneText.frame)+W_In_375(13), screen_width-W_In_375(48), 1) andBgColor:rgb(229,229,229)];
    [self.view addSubview:phoneLine];
    
}

/**
 下一步
 */
-(void)nextClick{
    
    [_phoneText resignFirstResponder];
    
    if([TKJudgeSummary valiMobile:_phoneText.text].length!=0){
        [TokeyViewTools showAlertViewIn:self andNoti:[TKJudgeSummary valiMobile:_phoneText.text]];
        return;
    }
    
    [TKSMSAction findPassSMS:_phoneText.text respose:^(BOOL aSuccess, NSString *aMessage) {
        if (aSuccess == YES) {
            TKFindPassVerificationCodeViewController * code = [[TKFindPassVerificationCodeViewController alloc]init];
            code.phoneString = self->_phoneText.text;
            [self.navigationController pushViewController:code animated:YES];
        }
    }];
    
    
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
