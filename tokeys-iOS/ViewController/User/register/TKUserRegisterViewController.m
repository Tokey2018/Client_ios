//
//  TKUserRegisterViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKUserRegisterViewController.h"
#import "TKWebViewController.h"
#import "TKSMSAction.h"
#import "TKRegisterCodeNewViewController.h"

@interface TKUserRegisterViewController (){
    
    UITextField * _phoneText;
    
}

@end

@implementation TKUserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    
    UILabel * titleLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(20), W_In_375(100), screen_width-W_In_375(40), W_In_375(40)) andTitle:@"快速注册" andTitleFont:BoldFontSize(W_In_375(36)) andTitleColor:rgb(51, 51, 51) andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:titleLabel];
    
    UILabel * placeLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(30), CGRectGetMaxY(titleLabel.frame)+W_In_375(90), W_In_375(90), W_In_375(17)) andTitle:@"国家/地区" andTitleFont:FontSize(W_In_375(18)) andTitleColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:placeLabel];
    UILabel * countryLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(screen_width-W_In_375(230), CGRectGetMaxY(titleLabel.frame)+W_In_375(90), W_In_375(200), W_In_375(17)) andTitle:@"中国大陆" andTitleFont:FontSize(W_In_375(18)) andTitleColor:rgb(187,187,187) andTextAlignment:NSTextAlignmentRight andBgColor:nil];
    [self.view addSubview:countryLabel];
    UIView *placeLine = [TokeyViewTools createViewWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(countryLabel.frame)+W_In_375(13), screen_width-W_In_375(48), 1) andBgColor:rgb(229,229,229)];
    [self.view addSubview:placeLine];
    
    UILabel * phoneLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(30), CGRectGetMaxY(placeLine.frame)+W_In_375(30), W_In_375(60), W_In_375(17)) andTitle:@"+86" andTitleFont:FontSize(W_In_375(18)) andTitleColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:phoneLabel];
    
    _phoneText = [TokeyViewTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame)+W_In_375(30), CGRectGetMaxY(placeLine.frame)+W_In_375(30), W_In_375(240), W_In_375(17)) andPlaceholder:@"手机号码" andTextColor:[UIColor blackColor] andTextFont:FontSize(W_In_375(18)) andReturnType:UIReturnKeyDone];
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_phoneText];
    UIView *phoneLine = [TokeyViewTools createViewWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(_phoneText.frame)+W_In_375(13), screen_width-W_In_375(48), 1) andBgColor:rgb(229,229,229)];
    [self.view addSubview:phoneLine];
    
    UIButton * registerBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(phoneLine.frame)+W_In_375(40), screen_width-W_In_375(48), W_In_375(45)) andTitle:@"注册" andTitleColor:[UIColor whiteColor] andBgColor:redMainColor andSelecter:@selector(registerClick) andTarget:self];
    registerBtn.layer.cornerRadius = W_In_375(6);
    [self.view addSubview:registerBtn];
    
    
    float otherLabelbuttonW = 138;
    
    UILabel * otherLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(registerBtn.frame)+W_In_375(16), screen_width-W_In_375(48+otherLabelbuttonW), W_In_375(20)) andTitle:@"注册即代表您已经同意" andTitleFont:FontSize(W_In_375(16)) andTitleColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentRight andBgColor:nil];
    [self.view addSubview:otherLabel];
    
    
    UIButton *otherLabelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherLabelbutton setTitle:@"《智疗服务协议》" forState:UIControlStateNormal];
    [otherLabelbutton setTitleColor:redMainColor forState:UIControlStateNormal];
    otherLabelbutton.titleLabel.font = otherLabel.font;
    otherLabelbutton.frame = CGRectMake(screen_width-W_In_375(24)-W_In_375(otherLabelbuttonW), CGRectGetMaxY(registerBtn.frame)+W_In_375(16), W_In_375(otherLabelbuttonW), W_In_375(20));
    [otherLabelbutton addTarget:self action:@selector(showUserXiyi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherLabelbutton];
    
    
    
    
    
    
    //[myLjjTools createLabelTextWithView:otherLabel andwithChangeColorTxt:@"《智疗服务协议》" withColor:redMainColor withFont:nil];
}

-(void)showUserXiyi{
    TKWebViewController *vc = [[TKWebViewController alloc] init];
    vc.url = @"http://www.jujumt.com/user.html";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)registerClick{
    
    [_phoneText resignFirstResponder];
    
    if([TKJudgeSummary valiMobile:_phoneText.text].length!=0){
        [TokeyViewTools showAlertViewIn:self andNoti:[TKJudgeSummary valiMobile:_phoneText.text]];
        return;
    }
    
    [TKSMSAction sendSMSCode:_phoneText.text respose:^(BOOL aSuccess, NSString *aMessage) {
        if (aSuccess) {
            TKRegisterCodeNewViewController * code = [[TKRegisterCodeNewViewController alloc]init];
            code.phoneString = _phoneText.text;
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
