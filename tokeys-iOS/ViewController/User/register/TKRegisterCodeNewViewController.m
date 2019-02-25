//
//  TKRegisterCodeNewViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/25.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKRegisterCodeNewViewController.h"
#import "UIButton+TKButton.h"
#import "TKCodeView.h"
#import "TKSMSAction.h"
#import "TKRegisterSetPassViewController.h"

@interface TKRegisterCodeNewViewController (){
    UIButton * _sendCodeBtn;
}

@end

@implementation TKRegisterCodeNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [_sendCodeBtn sendMessageBegin:redMainColor andChange:rgb(187,187,187)];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    UILabel * titleLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(20), W_In_375(100), screen_width-W_In_375(40), W_In_375(40)) andTitle:@"输入验证码" andTitleFont:BoldFontSize(W_In_375(36)) andTitleColor:rgb(51, 51, 51) andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:titleLabel];
    UILabel * introLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(20),CGRectGetMaxY(titleLabel.frame)+W_In_375(20), screen_width-W_In_375(40), W_In_375(16)) andTitle:[NSString stringWithFormat:@"已向%@发送验证码",self.phoneString] andTitleFont:FontSize(W_In_375(15)) andTitleColor:rgb(51, 51, 51) andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:introLabel];
    
    TKCodeView *v = [[TKCodeView alloc] initWithFrame:CGRectMake(W_In_375(40), CGRectGetMaxY(introLabel.frame)+W_In_375(120), screen_width-W_In_375(80), W_In_375(40))
                                              num:4
                                        lineColor:[UIColor blackColor]
                                         textFont:20];
    //下划线
    v.hasUnderLine = YES;
    //分割线
    v.hasSpaceLine = NO;
    //输入风格
    v.codeType = TKCodeViewTypeCustom;
    WEAKSELF
    v.EndEditBlcok = ^(NSString *str) {
        [weakSelf verificatCode:str];
    };
    [self.view addSubview:v];
    
    _sendCodeBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(W_In_375(60), CGRectGetMaxY(v.frame)+W_In_375(48), screen_width-W_In_375(120), W_In_375(40)) andTitle:@"重新获取验证码" andTitleColor:redMainColor andBgColor:nil andSelecter:@selector(sendCodeClick) andTarget:self];
    [self.view addSubview:_sendCodeBtn];
}

-(void)sendCodeClick{
    [TKSMSAction sendSMSCode:_phoneString respose:^(BOOL aSuccess, NSString *aMessage) {
        [self->_sendCodeBtn sendMessageBegin:redMainColor andChange:rgb(187,187,187)];
    }];
}

-(void)verificatCode:(NSString*)code{
    WEAKSELF
    [TKSMSAction verificatRegCode:_phoneString code:code respose:^(BOOL aSuccess, NSString *aMessage) {
        TKRegisterSetPassViewController * set = [[TKRegisterSetPassViewController alloc]init];
        set.phone = weakSelf.phoneString;
        set.code = code;
        [weakSelf.navigationController pushViewController:set animated:YES];
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
