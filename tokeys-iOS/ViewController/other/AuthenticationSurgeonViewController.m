//
//  AuthenticationSurgeonViewController.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/20.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "AuthenticationSurgeonViewController.h"
#import "FSActionSheet.h"

@interface AuthenticationSurgeonViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate>
{
    NSInteger _phototag;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIButton *conmitBT;

@end

@implementation AuthenticationSurgeonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.conmitBT setRoundViewByAngle:5.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showCamera{
    //显示拍照
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不支持拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
    
}
-(void)showPhoto{
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (_phototag==1) {
        _imageView1.image = image;
    }else{
        _imageView2.image = image;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark FSActionSheetDelegate
-(void)FSActionSheet:(FSActionSheet *)actionSheet selectedIndex:(NSInteger)selectedIndex{
    if(selectedIndex == 0){
        [self showPhoto];
    }else if (selectedIndex == 1){
        [self showCamera];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)choosePhoto1:(UIControl *)sender {
    [self showActionSheet:1];
}
- (IBAction)imageTap1Select:(UITapGestureRecognizer *)sender {
    [self showActionSheet:1];
}
- (IBAction)choosePhoto2:(UIControl *)sender {
    [self showActionSheet:2];
}
- (IBAction)imageTap2Select:(UITapGestureRecognizer *)sender {
    [self showActionSheet:2];
}

-(void) showActionSheet:(NSInteger)tag{
    _phototag = tag;
    FSActionSheet *ac = [[FSActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"相册选取",@"拍照"]];
    ac.tag = tag;
    [ac show];
}
@end
