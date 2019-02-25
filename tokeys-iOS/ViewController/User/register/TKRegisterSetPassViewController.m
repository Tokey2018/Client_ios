//
//  TKRegisterSetPassViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/25.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKRegisterSetPassViewController.h"
#import "TKUserAction.h"

@interface TKRegisterSetPassViewController (){
    UITextField * _passWordText;
}

@end

@implementation TKRegisterSetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    UILabel * titleLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(20), W_In_375(100), screen_width-W_In_375(40), W_In_375(40)) andTitle:@"设置登录密码" andTitleFont:BoldFontSize(W_In_375(36)) andTitleColor:rgb(51, 51, 51) andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:titleLabel];
    UILabel * introLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(W_In_375(20),CGRectGetMaxY(titleLabel.frame)+W_In_375(20), screen_width-W_In_375(40), W_In_375(16)) andTitle:@"8到20个字符，含数字、英文字母(区分大小写)" andTitleFont:FontSize(W_In_375(15)) andTitleColor:rgb(51, 51, 51) andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:introLabel];
    
    _passWordText = [TokeyViewTools createTextFieldFrame:CGRectMake(W_In_375(30), CGRectGetMaxY(introLabel.frame)+W_In_375(110), screen_width-W_In_375(60), W_In_375(20)) andPlaceholder:@"请设置您的登录密码" andTextColor:[UIColor blackColor] andTextFont:FontSize(W_In_375(18)) andReturnType:UIReturnKeyDone];
    // _passWordText.keyboardType = UIKeyboardTypeNumberPad;
    _passWordText.secureTextEntry = YES;
    _passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passWordText];
    UIView *passWordLine = [TokeyViewTools createViewWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(_passWordText.frame)+W_In_375(13), screen_width-W_In_375(48), 1) andBgColor:rgb(229,229,229)];
    [self.view addSubview:passWordLine];
    
    UIButton * registerBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(passWordLine.frame)+W_In_375(40), screen_width-W_In_375(48), W_In_375(45)) andTitle:@"注册" andTitleColor:[UIColor whiteColor] andBgColor:redMainColor andSelecter:@selector(registerClick) andTarget:self];
    registerBtn.layer.cornerRadius = W_In_375(6);
    [self.view addSubview:registerBtn];
}

-(void)registerClick{
    
    if(_passWordText.text.length<8||_passWordText.text.length>20){
        [TokeyViewTools showAlertViewIn:self andNoti:@"密码长度必须不低于8位不超过20位哦"];
        return;
    }
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    //判断授权状态
    if (status == kABAuthorizationStatusNotDetermined) {
        
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        
        ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                //查找所有联系人
                [self registerAction:[TokeyViewTools getMyPhoneBook]];
                
            }else
            {
                NSLog(@"授权失败");
            }
        });
    }else if (status == kABAuthorizationStatusAuthorized)
    {
        //已授权
        [self registerAction:[TokeyViewTools getMyPhoneBook]];
    }else{
        
        [self registerAction:[NSMutableArray array]];
    }
    
}

-(void)registerAction:(NSMutableArray*)contactArr{
    
    [TKUserAction register_save:_phone code:_code password:_passWordText.text phoneBook:contactArr respose:^(BOOL aSuccess, NSString *aMessage) {
        if (aSuccess) {
            [XYHUDCore showSuccessWithStatus:@"注册成功!"];
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
