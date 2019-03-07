//
//  registerViewController.h
//  IMshuoyeah
//
//  Created by shuoyeah on 16/3/23.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKRegistViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *regButton;
- (IBAction)bottomClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UILabel *bbutton;//底部电话
@property (weak, nonatomic) IBOutlet UILabel *yanzhenmaLabel;//验证码
@property (nonatomic,assign)BOOL isXiugai;//是否为修改密码
@end
