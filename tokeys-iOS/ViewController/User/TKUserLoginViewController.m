//
//  TKUserLoginViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TKUserLoginViewController.h"
#import "WRNavigationBar.h"
#import "UIButton+TouchAreaInsets.h"
#import "TKSqliteTools.h"
#import "TKUserAction.h"
#import "TKUserSetting.h"
#import "TKUserRegisterViewController.h"
#import "TKUserFindPassVerifyPhoneViewController.h"
#import "TKAccountTVCell.h"
#import "MainSlideViewController.h"

@interface TKUserLoginViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIImageView * _headImgView;
    UITextField * _phoneText;
    UITextField * _passWordText;
}

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray * dataArr;


@end

@implementation TKUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarAppearence];
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)setNavBarAppearence
{
    UIColor *textColor = [UIColor colorWithRed:51.0026/255.0 green:51.0026/255.0 blue:51.0026/255.0 alpha:1];
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor clearColor]];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:textColor];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:textColor];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
}
-(void)createUI{
    
    _headImgView = [TokeyViewTools createImageViewWithFrame:CGRectMake(W_In_375(138), W_In_375(80), W_In_375(100), W_In_375(100)) andImageName:@"login_head_logo" andBgColor:nil];
    _headImgView.layer.cornerRadius = W_In_375(50);
    [self.view addSubview:_headImgView];
    //手机号
    UIImageView * phoneImg = [TokeyViewTools createImageViewWithFrame:CGRectMake(W_In_375(36), CGRectGetMaxY(_headImgView.frame)+W_In_375(90), W_In_375(21), W_In_375(23)) andImageName:@"login_user_icon" andBgColor:nil];
    [self.view addSubview:phoneImg];
    _phoneText = [TokeyViewTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(phoneImg.frame)+W_In_375(30), CGRectGetMaxY(_headImgView.frame)+W_In_375(90), W_In_375(240), W_In_375(23)) andPlaceholder:@"请输入您的手机号" andTextColor:[UIColor blackColor] andTextFont:FontSize(18) andReturnType:UIReturnKeyDone];
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneText];
    UIButton * unfoldBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(screen_width-W_In_375(48), CGRectGetMaxY(_headImgView.frame)+W_In_375(94), W_In_375(16), W_In_375(16)) andImage:[UIImage imageNamed:@"login_dec_icon"] andSelecter:@selector(unfoldClick:) andTarget:self];
    [self.view addSubview:unfoldBtn];
    unfoldBtn.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIView * phoneLine = [TokeyViewTools createViewWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(_phoneText.frame)+W_In_375(10), screen_width-W_In_375(48), 1) andBgColor:rgb(229,229,229)];
    [self.view addSubview:phoneLine];
    //密码
    UIImageView * passWordImg = [TokeyViewTools createImageViewWithFrame:CGRectMake(W_In_375(36), CGRectGetMaxY(phoneLine.frame)+W_In_375(30), W_In_375(21), W_In_375(23)) andImageName:@"login_pass_icon" andBgColor:nil];
    [self.view addSubview:passWordImg];
    _passWordText = [TokeyViewTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(passWordImg.frame)+W_In_375(30), CGRectGetMaxY(phoneLine.frame)+W_In_375(30), W_In_375(240), W_In_375(23)) andPlaceholder:@"请输入您的密码" andTextColor:[UIColor blackColor] andTextFont:FontSize(18) andReturnType:UIReturnKeyDone];
    _passWordText.secureTextEntry = YES;
    _passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passWordText];
    
    UIButton * visibleBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(screen_width-W_In_375(48), CGRectGetMaxY(phoneLine.frame)+W_In_375(34), W_In_375(16), W_In_375(16)) andImage:[UIImage imageNamed:@"login_pass_hide_icon"] andSelecter:@selector(visibleBtnClick:) andTarget:self];
    [visibleBtn setImage:[UIImage imageNamed:@"login_pass_dis_icon"] forState:UIControlStateSelected];
    visibleBtn.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:visibleBtn];
    UIView * passWordLine = [TokeyViewTools createViewWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(_passWordText.frame)+W_In_375(10), screen_width-W_In_375(48), 1) andBgColor:rgb(229,229,229)];
    [self.view addSubview:passWordLine];
    
    UIButton * loginBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(passWordLine.frame)+W_In_375(40), screen_width-W_In_375(48), W_In_375(45)) andTitle:@"登录" andTitleColor:[UIColor whiteColor] andBgColor:redMainColor andSelecter:@selector(loginClick) andTarget:self];
    loginBtn.layer.cornerRadius = W_In_375(6);
    [self.view addSubview:loginBtn];
    
    UIButton * forgetBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(W_In_375(24), CGRectGetMaxY(loginBtn.frame)+W_In_375(16), W_In_375(80), W_In_375(20)) andTitle:@"忘记密码?" andTitleColor:redMainColor andBgColor:nil andSelecter:@selector(forgetBtnClick) andTarget:self];
    forgetBtn.titleLabel.font = FontSize(W_In_375(15));
    [self.view addSubview:forgetBtn];
    
    UIButton * registerBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(screen_width-W_In_375(94), CGRectGetMaxY(loginBtn.frame)+W_In_375(16), W_In_375(70), W_In_375(20)) andTitle:@"快速注册" andTitleColor:redMainColor andBgColor:nil andSelecter:@selector(registerBtnClick) andTarget:self];
    registerBtn.titleLabel.font = FontSize(W_In_375(15));
    [self.view addSubview:registerBtn];
    
    
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_phoneText.frame),screen_width, W_In_375(160)) style:UITableViewStylePlain];
    _tableview.hidden = YES;
    _tableview.delegate =self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    [_tableview registerNib:[UINib nibWithNibName:@"TKAccountTVCell" bundle:nil] forCellReuseIdentifier:@"accountTVID"];
}

-(void)unfoldClick:(UIButton*)btn{
    
    btn.selected = !btn.selected;
    if(btn.selected){
        _tableview.hidden = NO;
        _dataArr = [NSMutableArray arrayWithArray:[[TKSqliteTools sharedSqliteTools] showAllApp]];
        if(_dataArr.count==0){
            _tableview.hidden = YES;
        }else{
            [_tableview reloadData];
        }
    }else{
        _tableview.hidden = YES;
    }
}

-(void)visibleBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    _passWordText.secureTextEntry = !_passWordText.secureTextEntry;
}

-(void)loginClick{
    [_phoneText resignFirstResponder];
    [_passWordText resignFirstResponder];
    
    if(_phoneText.text.length==0||_passWordText.text.length==0){
        [TokeyViewTools showAlertViewIn:self andNoti:@"用户名或密码不能为空"];
        return;
    }else if(_passWordText.text.length<6){
        [TokeyViewTools showAlertViewIn:self andNoti:@"密码不低于8位数"];
        return;
    }else if(_phoneText.text.length!=11){
        [TokeyViewTools showAlertViewIn:self andNoti:@"手机号输入有误"];
        return;
    }
    NSUserDefaults* userDefaultsss = [NSUserDefaults standardUserDefaults];
    [userDefaultsss setObject:_phoneText.text forKey:@"phone"];
    [userDefaultsss synchronize];
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    //判断授权状态
    if (status == kABAuthorizationStatusNotDetermined) {
        
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        
        ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                //查找所有联系人
                [self loginAction:[TokeyViewTools getMyPhoneBook]];
                
            }else
            {
                NSLog(@"授权失败");
            }
        });
    }else if (status == kABAuthorizationStatusAuthorized)
    {
        //已授权
        [self loginAction:[TokeyViewTools getMyPhoneBook]];
    }else{
        
        [self loginAction:[NSMutableArray array]];
    }
}

-(void)loginAction:(NSMutableArray*)contactArr{
    
    
    [TKUserAction userLogin:_phoneText.text password:_passWordText.text phoneBook:contactArr respose:^(TKDoLoginModel *loginModel, NSString *yhsdLoginUrl, NSString *aMessage) {
        
        if(loginModel!=nil){
            
            [TKUserSetting sharedManager].yhsdLoginUrl = yhsdLoginUrl;
            
            [TKUserSetting sharedManager].uid = loginModel.user.uid;
            [TKUserSetting sharedManager].nick = loginModel.user.nick;
            [TKUserSetting sharedManager].phone = self->_phoneText.text;
            [TKUserSetting sharedManager].username = loginModel.user.accid;
            [TKUserSetting sharedManager].password = loginModel.user.imToken;
            [TKUserSetting sharedManager].token = loginModel.accessToken;
            [TKUserSetting sharedManager].isLogined = YES;
            [TKUserSetting sharedManager].userImg = loginModel.user.userImg;
            [TKUserSetting sharedManager].backgroupImg = loginModel.user.backgroupImg;
            [TKUserSetting sharedManager].roleCode = loginModel.user.roleCode;
            [TKUserSetting sharedManager].agencyTids = loginModel.user.agencyTids;
            [TKUserSetting sharedManager].auditStatus = loginModel.user.auditStatus;
            [TKUserSetting sharedManager].voice = @"11";//系统声音默认开启;
            [TKUserSetting sharedManager].shake = @"12";//系统震动默认开启;
            
            [[[NIMSDK sharedSDK] loginManager] login:loginModel.user.accid
                                               token:loginModel.user.imToken
                                          completion:^(NSError * _Nullable error) {
                                              if (error == nil){
                                                  
                                                  [XYHUDCore showSuccessWithStatus:@"登录成功"];
                                                  
                                                  if(![[TKSqliteTools sharedSqliteTools] isExistAppWithstring:self->_phoneText.text]){
                                                      
                                                      [[TKSqliteTools sharedSqliteTools] insertAppAccount:self->_phoneText.text andPass:self->_passWordText.text];
                                                  }else{
                                                      [[TKSqliteTools sharedSqliteTools] DeleteAppAccount:self->_phoneText.text];
                                                      [[TKSqliteTools sharedSqliteTools] insertAppAccount:self->_phoneText.text andPass:self->_passWordText.text];
                                                  }
                                                  
                                                  MainSlideViewController *mainVC = [[MainSlideViewController alloc] init];
                                                  self.view.window.rootViewController = mainVC;
                                              }else {
                                                  [XYHUDCore showErrorWithStatus:@"登录失败"];
                                              }
                                          }];
        }
    }];
    
}


-(void)forgetBtnClick{
    TKUserFindPassVerifyPhoneViewController * find = [[TKUserFindPassVerifyPhoneViewController alloc]init];
    [self.navigationController pushViewController:find animated:YES];
}

-(void)registerBtnClick{
    TKUserRegisterViewController * reg = [[TKUserRegisterViewController alloc]init];
    [self.navigationController pushViewController:reg animated:YES];
}
#pragma mark ------------微信登录-------------
//-(void)wechatBtnClick{
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [self sendAuthRequest];
//}
//-(void)sendAuthRequest
//{
//    //构造SendAuthReq结构体
//    SendAuthReq* req =[[SendAuthReq alloc ] init ];
//    req.scope = @"snsapi_userinfo" ;
//    req.state = @"123" ;
//    //第三方向微信终端发送一个SendAuthReq消息结构
//    [WXApi sendReq:req];
//
//}
//
//-(void)onResp:(BaseResp *)resp{
//
//}
#pragma mark tabelview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKAccountTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"accountTVID" forIndexPath:indexPath];
    if(indexPath.row<_dataArr.count){
        TKAccountPassWordModel * model = _dataArr[indexPath.row];
        cell.phoneLabel.text = model.account;
        WEAKSELF
        cell.myBlock = ^{
            [weakSelf.dataArr removeObject:model];
            [[TKSqliteTools sharedSqliteTools] DeleteAppAccount:model.account];
            [weakSelf.tableview reloadData];
        };
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableview.hidden = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TKAccountPassWordModel * model = _dataArr[indexPath.row];
    _phoneText.text = model.account;
    _passWordText.text = model.passWord;
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
