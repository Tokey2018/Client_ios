//
//  registerViewController.m
//  IMshuoyeah
//
//  Created by shuoyeah on 16/3/23.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "TKRegistViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TKUserAction.h"
#import "TKSMSAction.h"
#import "TKNavigationController.h"
#import "TKUserLoginViewController.h"

@interface TKRegistViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mima;

@property (nonatomic,strong)NSMutableArray * peopleArr;

@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;
@property (nonatomic,assign)BOOL isLogin;
@property (nonatomic,copy)NSString * string;
@end

@implementation TKRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backcolor;
    self.yanzhenmaLabel.layer.cornerRadius=3;
    self.yanzhenmaLabel.clipsToBounds = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendSMS)];
    [_yanzhenmaLabel addGestureRecognizer:tap];

    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
   // _passText.keyboardType = UIKeyboardTypeNumberPad;

    [self.yanzhenmaLabel setBackgroundColor:blcolor];
    [self.regButton setBackgroundColor:blcolor];
    self.regButton.layer.cornerRadius = 3;
     _peopleArr = [NSMutableArray array];
    if (_isXiugai == YES) {
        _string = @"忘记密码";
    }else{
    _string = self.title;
        if([_string isEqualToString:@"忘记密码"]){
        
        }else{
            // _nameView.hidden = NO;
        }
    }
    if([_string isEqualToString:@"忘记密码"]){
    
    [self.regButton setTitle:@"提交" forState:UIControlStateNormal];
    self.passText.placeholder = @"请输入新密码";
        self.mima.text = @"新密码";
    }
    

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

- (IBAction)bottomClick:(UIButton *)sender {
    if([_string isEqualToString:@"忘记密码"]){
    
    }else{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    //判断授权状态
    if (status == kABAuthorizationStatusNotDetermined) {
        
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        
        ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                //查找所有联系人
                [self address];
                
            }else
            {
                NSLog(@"授权失败");
            }
        });
    }else if (status == kABAuthorizationStatusAuthorized)
    {
        //已授权
        [self address];
    }
    }
    [self registerAction];
}

-(void)registerAction{
    if([_string isEqualToString:@"忘记密码"]){
    
        if(_phoneText.text.length==0||_passText.text.length==0){
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            aler.tag=8;
            [aler show];
            return;
        }else if(_passText.text.length<6){
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码必须大于6位数" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            aler.tag=9;
            [aler show];
            return;
            
        }else if(_phoneText.text.length!=11){
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码输入有误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            aler.tag=2;
            [aler show];
            return;
            
        }else if(_yanzhengmaText.text.length==0){
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            aler.tag=29;
            [aler show];
            return;
            
        }

        /*
          NSDictionary * dict = @{@"phone":_phoneText.text,@"newPwd":_passText.text,@"code":_yanzhengmaText.text};
        [HttpRequest potWithURL:HTTP_URL(@"/user/forget") params:dict success:^(id responseObject) {
            NSData *responseData1 = responseObject;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",responseDict);
            if([responseDict[@"code"]integerValue]==0){
            [XYHUDCore showSuccessWithStatus:@"设置成功"];
            }else{
            
                [XYHUDCore showErrorWithStatus:@"设置失败"];
            }
            
            if(self.isXiugai == YES){
                UIAlertView * alr = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alr.tag = 100;
                [alr show];
            }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            [XYHUDCore showErrorWithStatus:@"重置失败"];
        }];
         */
        [TKUserAction findpass_setNewPass:_phoneText.text code:_yanzhengmaText.text password:_passText.text confirmPass:_passText.text respose:^(BOOL aSuccess, NSString *aMessage) {
            if(aSuccess){
                [XYHUDCore showSuccessWithStatus:@"设置成功"];
            }else{
                
                [XYHUDCore showErrorWithStatus:@"设置失败"];
            }
            if(self.isXiugai == YES){
                UIAlertView * alr = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alr.tag = 100;
                [alr show];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }else{
        if(_phoneText.text.length==0||_passText.text.length==0){
        UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        aler.tag=11;
        [aler show];
        return;
        }
        if(_passText.text.length<7){
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码必须大于6位数" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            aler.tag=10;
            [aler show];
            return;
        }
        if(_phoneText.text.length!=11){
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码输入有误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            aler.tag=3;
            [aler show];
            return;
            
        }

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==12){
    if(_isLogin == YES){
     [self.navigationController popViewControllerAnimated:YES];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"yonghuming" object:nil userInfo:@{@"yonghuming":_phoneText.text}];
    }else{
    
    
    }

    }else if (alertView.tag==100){
        
        [[TKUserSetting sharedManager] UserSettingManagerDestroy];
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error){}];
        TKUserLoginViewController * login = [[TKUserLoginViewController alloc]init];
        TKNavigationController * nav = [[TKNavigationController alloc]initWithRootViewController:login];
        self.view.window.rootViewController = nav;
        
    }
}

- (void)address
{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return;
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];//存储每个联系人信息
        
        NSMutableDictionary * dicti = [NSMutableDictionary dictionary];
        NSMutableArray * phoneNum = [NSMutableArray array];//一个联系人电话
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }
        else {
            if ((__bridge id)abLastName != nil) {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        [dict setValue:nameString forKey:@"name"];
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        NSString *tel = (__bridge NSString*)value;
                        
                        //以下5行请勿删除,请勿修改,隐形代码,删改后果自负
                        tel = [tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
                        tel = [tel stringByReplacingOccurrencesOfString:@")" withString:@""];
                        tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        tel = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
                        tel = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
                        [phoneNum addObject:tel];
                        break;
                    }
                }
                CFRelease(value);
                           }
            CFRelease(valuesRef);
        }
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
        if (phoneNum.count==1) {
            [dict setValue:phoneNum[0] forKey:@"phone"];
            [_peopleArr addObject:dict];
        }else{
            for(NSString * tele in phoneNum){
                dicti=[NSMutableDictionary dictionary];
                [dicti setValue:nameString forKey:@"name"];
                [dicti setValue:tele forKey:@"phone"];
                [_peopleArr addObject:dicti];
            }
        }
 
        
    }
    NSLog(@"%@",_peopleArr);
}

- (void)sendSMS{
    
    if(_phoneText.text.length!=11){
        UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码输入有误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        aler.tag=3;
        [aler show];
        return;
        
    }
    
    _time = 60;
    self.yanzhenmaLabel.userInteractionEnabled = NO;
    [self.yanzhenmaLabel setBackgroundColor:[UIColor lightGrayColor]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    
    [TKSMSAction findPassSMS:_phoneText.text respose:^(BOOL aSuccess, NSString *aMessage) {
        
    }];
    
    
    
}
-(void)timeChange{
    if(_time==0){
        self.yanzhenmaLabel.userInteractionEnabled = YES;
        [_timer invalidate];
        _timer = nil;
    [self.yanzhenmaLabel setBackgroundColor:blcolor];
   [self.yanzhenmaLabel setText:@"获取验证码"];
    }else{
   [self.yanzhenmaLabel setText:[NSString stringWithFormat:@"%ldS后重发",_time]];
    _time--;
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

@end
