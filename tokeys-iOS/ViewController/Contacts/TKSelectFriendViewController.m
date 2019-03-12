//
//  TKSelectFriendViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKSelectFriendViewController.h"
#import "TKMineCell.h"
#import "TKAddFriendViewController.h"
@interface TKSelectFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * arr;

@end

@implementation TKSelectFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    _arr = @[@"添加好友",@"邀请通讯录好友"];
}

-(void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UINavBar_Height, screen_width, screen_height-UINavBar_Height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    if(@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"myViewControllercell";
    TKMineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TKMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.imageName = _arr[indexPath.row];
    cell.titleStr = _arr[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0){
        TKAddFriendViewController * add = [[TKAddFriendViewController alloc]init];
        [self.navigationController pushViewController:add animated:YES];
    }else{
//        [HttpRequest potWithURL:HTTP_URL(@"/user/noRegisterPhones") params:@{@"accid":[LJUserSetting sharedManager].username,@"pageNumber":@"1",@"pageSize":@"10"} success:^(id responseObject) {
//            [SVProgressHUD dismiss];
//            NSData *responseData1 = responseObject;
//            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",responseDict[@"message"]);
//            inviteViewController * inv  = [[inviteViewController alloc]init];
//            inv.dataArr = [NSMutableArray arrayWithArray:responseDict[@"data"]];
//            inv.isYaoqin = YES;
//            [self.navigationController pushViewController:inv animated:YES];
//        } failure:^(NSError *error) {
//            [XYHUDCore showErrorWithStatus:@"请求失败"];
//        }];
        
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

@end
