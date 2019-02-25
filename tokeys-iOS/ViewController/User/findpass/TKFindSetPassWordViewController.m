//
//  TKFindSetPassWordViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/25.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKFindSetPassWordViewController.h"
#import "TKUserAction.h"

@interface TKFindSetPassWordViewController (){
    UITextField * _newPassWordText;
    UITextField * _surePassWordText;
}

@end

@implementation TKFindSetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    
    UILabel * titleLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(20), W_In_375(100), screen_width-W_In_375(40), W_In_375(40)) andTitle:@"忘记登录密码" andTitleFont:BoldFontSize(W_In_375(36)) andTitleColor:rgb(51, 51, 51) andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:titleLabel];
    
    UILabel * newPassLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(30), CGRectGetMaxY(titleLabel.frame)+W_In_375(93), W_In_375(60), W_In_375(17)) andTitle:@"新密码" andTitleFont:FontSize(W_In_375(18)) andTitleColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:newPassLabel];
    _newPassWordText = [TokeyViewTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(newPassLabel.frame)+W_In_375(30), CGRectGetMaxY(titleLabel.frame)+W_In_375(93), W_In_375(240), W_In_375(17)) andPlaceholder:@"8-20位数字或英文字母" andTextColor:[UIColor blackColor] andTextFont:FontSize(W_In_375(18)) andReturnType:UIReturnKeyDone];
    _newPassWordText.secureTextEntry = YES;
    [self.view addSubview:_newPassWordText];
    UIView *newPassLine = [TokeyViewTools createViewWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(_newPassWordText.frame)+W_In_375(13), screen_width-W_In_375(48), 1) andBgColor:rgb(229,229,229)];
    [self.view addSubview:newPassLine];
    
    UILabel * surePassLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(30), CGRectGetMaxY(newPassLine.frame)+W_In_375(20), W_In_375(80), W_In_375(17)) andTitle:@"确认密码" andTitleFont:FontSize(W_In_375(18)) andTitleColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:surePassLabel];
    _surePassWordText = [TokeyViewTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(surePassLabel.frame)+W_In_375(20), CGRectGetMaxY(newPassLine.frame)+W_In_375(20), W_In_375(240), W_In_375(17)) andPlaceholder:@"8-20位数字或英文字母" andTextColor:[UIColor blackColor] andTextFont:FontSize(W_In_375(18)) andReturnType:UIReturnKeyDone];
    _surePassWordText.secureTextEntry = YES;
    [self.view addSubview:_surePassWordText];
    UIView *surePassLine = [TokeyViewTools createViewWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(_surePassWordText.frame)+W_In_375(13), screen_width-W_In_375(48), 1) andBgColor:rgb(229,229,229)];
    [self.view addSubview:surePassLine];
    
    UIButton * sureBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(surePassLine.frame)+W_In_375(40), screen_width-W_In_375(48), W_In_375(45)) andTitle:@"确定" andTitleColor:[UIColor whiteColor] andBgColor:redMainColor andSelecter:@selector(sureClick) andTarget:self];
    sureBtn.layer.cornerRadius = W_In_375(6);
    [self.view addSubview:sureBtn];
    
    
}

-(void)sureClick{
    
    if(![_surePassWordText.text isEqualToString:_newPassWordText.text]){
        [TokeyViewTools showAlertViewIn:self andNoti:@"两次密码不一致哦"];
        return;
    }
    if(_newPassWordText.text.length<8||_newPassWordText.text.length>20){
        [TokeyViewTools showAlertViewIn:self andNoti:@"密码长度必须不低于8位不超过20位哦"];
        return;
    }
    /*
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setValue:self.phone forKey:@"phone"];
    [parms setValue:self.code forKey:@"code"];
    [parms setValue:_newPassWordText.text forKey:@"password"];
    [parms setValue:_surePassWordText.text forKey:@"confirmPass"];
    [HttpRequest newPostWithURL:HTTP_URL(set_NewPass) params:parms andNeedHub:YES success:^(id responseObject) {
        [XYHUDCore showSuccessWithStatus:@"找回密码成功!"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
     */
    [TKUserAction findpass_setNewPass:self.phone code:self.code password:_newPassWordText.text confirmPass:_surePassWordText.text respose:^(BOOL aSuccess, NSString *aMessage) {
        if (aSuccess) {
            [XYHUDCore showSuccessWithStatus:@"找回密码成功!"];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
