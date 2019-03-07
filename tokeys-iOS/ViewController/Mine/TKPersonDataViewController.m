//
//  TKPersonDataViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKPersonDataViewController.h"
#import "TKUserSetting.h"
#import "TKMineInfoTableViewController.h"
#import "TKGroupHeadTableViewCell.h"
#import "TKMineCell.h"
#import "TKNotiSetTableViewCell.h"
#import "UIView+Toast.h"
#import "TKNavigationController.h"
#import "TKUserLoginViewController.h"
#import "TKRegistViewController.h"
#import "AuthenticationViewController.h"

@interface TKPersonDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,TKGroupHeadRenzhengDelegate>
{
    BOOL openTZ;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * arr;
@property (nonatomic,strong)NSArray * picArr;
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,copy)NSString * headUrl;
@property (nonatomic,strong) NSMutableArray *choseArray;
@end

@implementation TKPersonDataViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //[self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    //    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //    self.navigationItem.leftBarButtonItem = leftBarButton;
    //    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    openTZ = NO;
    self.title = @"设置";
    _choseArray = [NSMutableArray arrayWithArray:@[[TKUserSetting sharedManager].shake,[TKUserSetting sharedManager].voice]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    _arr = @[@[@""],
             @[@{@"title":@"通知",@"image":@"tz_icon"},
               @{@"title":@"震动",@"image":@""},
               @{@"title":@"灯光",@"image":@""},
               @{@"title":@"声音",@"image":@""},
               @{@"title":@"弹出窗口",@"image":@""},],
             @[@{@"title":@"关闭聊天记录",@"image":@"chat_icon"},
               @{@"title":@"删除聊天记录",@"image":@"del_icon"}],
             @[@{@"title":@"账户设置",@"image":@"setting_icon"}],
             @[@"退出登录"]];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhuangtai) name:@"zhuangtai" object:nil];
    // Do any additional setup after loading the view.
}

-(void)zhuangtai{
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)releaseInfo{
    
    TKMineInfoTableViewController* booking = [[TKMineInfoTableViewController alloc]init];
    booking.isJump = self.isJump;
    [self.navigationController pushViewController:booking animated:YES];
    
}

- (UIImage*)createImageWithColor:(UIColor*)color{
    //绘图
    //定义显示区域
    CGRect rect = CGRectMake(0, 0, 1, 1);//返回图片的尺寸
    //创建画笔
    UIGraphicsBeginImageContext(rect.size);
    //根据所传颜色绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将所选区域铺满
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //联系显示区域
    CGContextFillRect(context, rect);
    //得到图片信息
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //把画笔消除
    UIGraphicsEndImageContext();
    return image;
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UINavBar_Height, screen_width, screen_height-UINavBar_Height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TKNotiSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"seleID"];
    [_tableView registerNib:[UINib nibWithNibName:@"TKGroupHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"FUKEID"];
    if (@available(iOS 11.0, *)){
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==1){
        if (openTZ==NO) {
            return 1;
        }
        return 5;
    }else if(section==2){
        
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // NSLog(@"%@",USER_info);
    
    if (indexPath.section==0) {
        TKGroupHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FUKEID" forIndexPath:indexPath];
        cell.renzhen.hidden = NO;
        cell.rdelegate = self;
        cell.personLabel.hidden = YES;
        //审核状态
        cell.shenheImage.hidden = NO;
        
        if(auditStatusNum==0){
            cell.nameLabel.text=@"未审核";
            cell.penButton.hidden = NO;
            cell.shenheImage.image = [UIImage imageNamed:@"non_ren_zheng"];
        }else if (auditStatusNum==1){
            cell.nameLabel.text=@"审核中";
            cell.penButton.hidden = YES;
            cell.shenheImage.image = [UIImage imageNamed:@"non_ren_zheng"];
        }else if(auditStatusNum==-1){
            cell.nameLabel.text=@"审核未通过";
            cell.penButton.hidden = NO;
            cell.shenheImage.image = [UIImage imageNamed:@"non_ren_zheng"];
        }else{
            cell.nameLabel.text=@"审核通过";
            cell.penButton.hidden = YES;
            cell.shenheImage.image = [UIImage imageNamed:@"have_ren_zheng"];
        }
        
        [cell.groupHeadImage tk_setImageWithURL:[TKUserSetting sharedManager].backgroupImg placeholderImage:[UIImage imageNamed:@"user_bg"]];
        if(_headUrl.length==0){
        }else{
            [cell.groupHeadImage tk_setImageWithURL:_headUrl placeholderImage:[UIImage imageNamed:@"user_bg"]];
        }
        // cell.groupChatButton.hidden = YES;
        return cell;
    }else if(indexPath.section==1 ){
        NSDictionary *dic = _arr[indexPath.section][indexPath.row];
        if (indexPath.row == 0) {
            //call_icon_list
            NSString *ID = @"TXCELL";
            TKMineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[TKMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            
            [cell openRightImage];
            cell.imageName = dic[@"image"];
            cell.titleStr =  dic[@"title"];
            return cell;
        }
        TKNotiSetTableViewCell * cell11 = [tableView dequeueReusableCellWithIdentifier:@"seleID" forIndexPath:indexPath];
        cell11.titl.text = dic[@"title"];
        cell11.titl.textAlignment = NSTextAlignmentLeft;
        NSString*  selectRow  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        if ([self.choseArray  containsObject:selectRow]) {
            
            cell11.seleButton.selected = YES;
        }else{
            cell11.seleButton.selected = NO;
        }
        return cell11;
    }else if(indexPath.section==4){
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
        
    }else{
        NSString *ID = @"myViewControllercell";
        TKMineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[TKMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSDictionary *dic = _arr[indexPath.section][indexPath.row];
        
        cell.imageName = dic[@"image"];
        cell.titleStr =  dic[@"title"];
        
        return cell;
    }
    
    
}
#pragma mark TKGroupHeadRenzhengDelegate
-(void)groupHeadTableViewCell:(TKGroupHeadTableViewCell *)aCell renzhengToPeople:(id)asender{
    
    if(auditStatusNum==0||auditStatusNum==-1){
        /*
         authenticationTableViewController * doc = [[authenticationTableViewController alloc]init];
         doc.isJump = self.isJump;
         [self.navigationController pushViewController:doc animated:YES];
         */
        AuthenticationViewController *doc = [[AuthenticationViewController alloc] init];
        [self.navigationController pushViewController:doc animated:YES];
        
    }else if (auditStatusNum==1){
        [self.view makeToast:@"正在审核中..." duration:1 position:CSToastPositionCenter];
    }else{
        
    }
    
    
    
}
-(void)groupHeadTableViewCell:(TKGroupHeadTableViewCell *)aCell groupChatToCheck:(id)asender{
    TKMineInfoTableViewController* booking = [[TKMineInfoTableViewController alloc]init];
    booking.isJump = self.isJump;
    [self.navigationController pushViewController:booking animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 190;
    }else{
        return 50.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==1){
        return 10.0;
    }else{
        return 10.0;
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==3){
        //        zhanghuViewController * zhang = [[zhanghuViewController alloc]init];
        //        [self.navigationController pushViewController:zhang animated:YES];
        TKRegistViewController * regs = [[TKRegistViewController alloc]init];
        regs.title = @"修改密码";
        regs.isXiugai = YES;
        [self.navigationController pushViewController:regs animated:YES];
        
    }else if(indexPath.section==2&&indexPath.row==0){//清除聊天历史
        
        UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除历史消息" delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
        // aler.tag = 25;
        [aler show];
    }else if(indexPath.section==4){
        
        [[TKUserSetting sharedManager] UserSettingManagerDestroy];
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error){}];
        TKUserLoginViewController * vc = [[TKUserLoginViewController alloc]init];
        TKNavigationController * nav = [[TKNavigationController alloc]initWithRootViewController:vc];
        vc.title = @"登录";
        self.view.window.rootViewController = nav;
        
    }else if(indexPath.section==0){
        
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"相机", nil];
        [sheet showInView:self.view];
        
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            TKMineCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            
            if (cell.rightIconOn == NO) {
                openTZ = YES;
                [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1],
                                                    [NSIndexPath indexPathForRow:2 inSection:1],
                                                    [NSIndexPath indexPathForRow:3 inSection:1],
                                                    [NSIndexPath indexPathForRow:4 inSection:1]] withRowAnimation:UITableViewRowAnimationBottom];
            }else{
                openTZ = NO;
                [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1],
                                                    [NSIndexPath indexPathForRow:2 inSection:1],
                                                    [NSIndexPath indexPathForRow:3 inSection:1],
                                                    [NSIndexPath indexPathForRow:4 inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
            }
            cell.rightIconOn = !cell.rightIconOn;
            return;
        }
        if(indexPath.row==3){
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"在iPhone的设置-通知中心功能,找到应用程序 智疗,可以更改智疗新消息提醒设置" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }
        NSString*  selectRow  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        //判断数组中有没有被选中行的行号,
        if ([self.choseArray containsObject:selectRow]) {
            [self.choseArray removeObject:selectRow];
            if(selectRow.integerValue==1){
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"5" forKey:@"shake"];
                [userDefaults synchronize];
            }
            if(selectRow.integerValue==2){
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"5" forKey:@"voice"];
                [userDefaults synchronize];
            }
            
        }else{
            [self.choseArray addObject:selectRow];
            if(selectRow.integerValue==1){
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"1" forKey:@"shake"];
                [userDefaults synchronize];
            }
            if(selectRow.integerValue==2){
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"2" forKey:@"voice"];
                [userDefaults synchronize];
            }
            
        }
        NSLog(@"你选中了第%ld",(long)indexPath.row);
        //cell刷新
        NSIndexPath *index=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(buttonIndex==0){
        
        NIMDeleteMessagesOption * option = [[NIMDeleteMessagesOption alloc]init];
        option.removeSession = YES;
        [[[NIMSDK sharedSDK]conversationManager]deleteAllMessages:option];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"freshChat" object:nil userInfo:nil];
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"buttonIndex = [%d]",buttonIndex);
    switch (buttonIndex) {
            
        case 0://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        case 1://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:@"currentImage.png"];
    //NSLog(@"%@",editingInfo);
    NSMutableDictionary* dic =[NSMutableDictionary dictionary];
    [dic setObject:[TKUserSetting sharedManager].uid forKey:@"uid"];
    /*
    [HttpRequest requestImageWithURL:HTTP_URL(@"/user/uploadBackGroup") params:dic path:@"backgroup" photos:image success:^(id result) {
        NSLog(@"result:%@",result);
        NSData *responseData1 = result;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableContainers error:nil];
        
        // [SVProgressHUD dismiss];
        _headUrl = responseDict[@"data"];
        
        [LJUserSetting sharedManager].backgroupImg = _headUrl;
        
        NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSError * error) {
        NSLog(@"失败了");
        [XYHUDCore showErrorWithStatus:@"上传失败"];
        
    }];
     */
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
