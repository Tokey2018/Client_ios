//
//  TKFindPassVerificationCodeViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/25.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKFindPassVerificationCodeViewController.h"
#import "UIButton+TKButton.h"
#import "TKSMSAction.h"
#import "TKFindSetPassWordViewController.h"

@interface TKFindPassVerificationCodeViewController (){
    UITextField * _codeText;
    UIButton * _sendCodeBtn;
}

@end

@implementation TKFindPassVerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRightItem];
    [self createUI];
    [_sendCodeBtn sendMessageBegin:redMainColor andChange:rgb(187,187,187)];
    // Do any additional setup after loading the view.
}

-(void)createRightItem{
    UIButton * rightBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(0, 0, W_In_375(70), W_In_375(40)) andTitle:@"下一步" andTitleColor:redMainColor andBgColor:nil andSelecter:@selector(nextClick) andTarget:self];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)createUI{
    
    UILabel * titleLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(20), W_In_375(100), screen_width-W_In_375(40), W_In_375(40)) andTitle:@"验证码" andTitleFont:BoldFontSize(W_In_375(36)) andTitleColor:rgb(51, 51, 51) andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:titleLabel];
    
    UILabel * phoneLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(30), CGRectGetMaxY(titleLabel.frame)+W_In_375(93), W_In_375(60), W_In_375(17)) andTitle:@"验证码" andTitleFont:FontSize(W_In_375(18)) andTitleColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:phoneLabel];
    
    _codeText = [TokeyViewTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame)+W_In_375(30), CGRectGetMaxY(titleLabel.frame)+W_In_375(93), W_In_375(240), W_In_375(17)) andPlaceholder:@"请输入您的验证码" andTextColor:[UIColor blackColor] andTextFont:FontSize(W_In_375(18)) andReturnType:UIReturnKeyDone];
    _codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    // _codeText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_codeText];
    UIView *codeLine = [TokeyViewTools createViewWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(_codeText.frame)+W_In_375(13), screen_width-W_In_375(48), 1) andBgColor:rgb(229,229,229)];
    [self.view addSubview:codeLine];
    
    _sendCodeBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(W_In_375(60), CGRectGetMaxY(codeLine.frame)+W_In_375(48), screen_width-W_In_375(120), W_In_375(40)) andTitle:@"重新获取验证码" andTitleColor:redMainColor andBgColor:nil andSelecter:@selector(sendCodeClick) andTarget:self];
    _sendCodeBtn.titleLabel.font = FontSize(W_In_375(15));
    [self.view addSubview:_sendCodeBtn];
}

-(void)sendCodeClick{
    if([TKJudgeSummary valiMobile:self.phoneString].length!=0){
        [TokeyViewTools showAlertViewIn:self andNoti:[TKJudgeSummary valiMobile:self.phoneString]];
        return;
    }
    [TKSMSAction findPassSMS:_phoneString respose:^(BOOL aSuccess, NSString *aMessage) {
        [self->_sendCodeBtn sendMessageBegin:redMainColor andChange:rgb(187,187,187)];
    }];
}

/**
 下一步
 */
-(void)nextClick{
    if(_codeText.text.length==0){
        [TokeyViewTools showAlertViewIn:self andNoti:@"验证码不能为空"];
        return;
    }
    [TKSMSAction verificatPassCode:_phoneString code:_codeText.text respose:^(BOOL aSuccess, NSString *aMessage) {
        TKFindSetPassWordViewController * find = [[TKFindSetPassWordViewController alloc]init];
        find.phone = self.phoneString;
        find.code = self->_codeText.text;
        [self.navigationController pushViewController:find animated:YES];
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
