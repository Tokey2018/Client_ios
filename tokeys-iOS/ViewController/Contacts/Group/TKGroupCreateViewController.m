//
//  TKGroupCreateViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKGroupCreateViewController.h"
#import "TKInviteViewController.h"

@interface TKGroupCreateViewController ()

@property (nonatomic,strong)UITextField * textField;

@end

@implementation TKGroupCreateViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = backcolor;
    self.title = @"新群组";
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 104, screen_width-40, 40)];
    _textField.placeholder = @"群组名称";
    [self.view addSubview:_textField];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(20, 144, screen_width-40, 1)];
    view.backgroundColor = blcolor;
    [self.view addSubview:view];
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(0, 0, 60, 30);
    [releaseButton setTitle:@"下一步" forState:normal];
    [releaseButton setTitleColor:blcolor forState:UIControlStateNormal];
    releaseButton.layer.cornerRadius = 3;
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    // Do any additional setup after loading the view.
}
-(void)releaseInfo{
    if(_textField.text.length>32||_textField.text.length==0){
        UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"群名太长啦或为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [aler show];
        return;
    }
    
    TKInviteViewController * invite = [[TKInviteViewController alloc]init];
    invite.dataArr = [NSMutableArray arrayWithArray:self.arr];
    invite.titleStr = _textField.text;
    invite.isreateGroup = YES;
    [self.navigationController pushViewController:invite animated:YES];
    
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController]
    
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
