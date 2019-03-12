//
//  TKGroupNoticeEditViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/12.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKGroupNoticeEditViewController.h"
#import "CustomTextVeiw.h"
#import "UIView+Toast.h"
#import "TKTeamAction.h"

@interface TKGroupNoticeEditViewController ()

@property (nonatomic,strong)CustomTextVeiw * writeText;
@property (nonatomic,strong)UITextField * textFiled;
@end

@implementation TKGroupNoticeEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建公告";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _writeText = [[CustomTextVeiw alloc]initWithFrame:CGRectMake(10, 180, screen_width-20, 160)];
    _writeText.layer.borderWidth = 1;
    _writeText.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _writeText.layer.cornerRadius = 3;
    _writeText.customPlaceholder = @"公告内容...";
    [self.view addSubview:_writeText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(writeTextDidChange) name:UITextViewTextDidChangeNotification object:_writeText];
    
    
    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, screen_width-20, 40)];
    _textFiled.placeholder = @"标题...";
    _textFiled.layer.borderWidth = 1;
    _textFiled.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _textFiled.layer.cornerRadius = 3;
    [self.view addSubview:_textFiled];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:_textFiled];
    
    
    // Do any additional setup after loading the view.
}

-(void)writeTextDidChange{
    
    if(_writeText.text.length>50){
        _writeText.text = [_writeText.text substringToIndex:50];
        [self.view makeToast:@"内容限制50字以内" duration:1 position:CSToastPositionCenter];
    }
    
}

-(void)textFieldDidChange{
    
    if(_textFiled.text.length>30){
        [self.view makeToast:@"标题限制30字以内" duration:1 position:CSToastPositionCenter];
        _textFiled.text = [_textFiled.text substringToIndex:30];
        
    }
    
    
}

-(void)createUI{
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(0, 0, 40, 30);
    [releaseButton setTitle:@"发布" forState:normal];
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseButton.layer.cornerRadius = 3;
    [releaseButton setBackgroundColor:blcolor];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
}

-(void)releaseInfo{
    if(_writeText.text.length==0||_textFiled.text.length==0){
        UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [aler show];
        return;
    }
    
    [TKTeamAction sendNotice:self.groupID owerAccid:[TKUserSetting sharedManager].username title:_textFiled.text content:_writeText.text respose:^(BOOL aSuccess, NSString *aMessage) {
        if(aSuccess){
            [XYHUDCore showSuccessWithStatus:@"更新群公告成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"freshNoti" object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [XYHUDCore showErrorWithStatus:aMessage];
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
