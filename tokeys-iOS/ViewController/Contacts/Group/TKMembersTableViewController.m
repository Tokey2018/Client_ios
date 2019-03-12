//
//  TKMembersTableViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/12.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKMembersTableViewController.h"
#import "TKInvitationTableViewCell.h"
#import "TKTeamAction.h"

@interface TKMembersTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy)NSString * newower;//新群主

@end

@implementation TKMembersTableViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TKInvitationTableViewCell" bundle:nil] forCellReuseIdentifier:@"yaoqingCell"];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    TKInvitationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"yaoqingCell"];
    cell.yaoqingLabel.text = _dataArr[indexPath.row][@"nike"];
    cell.headImage.layer.cornerRadius = 25;
    cell.clipsToBounds = YES;
    
    // cell.headImage.hidden = YES;
    cell.headLabel.hidden = NO;
    cell.headImage.hidden = NO;
    [cell.headImage setImage:[UIImage imageNamed:TK_ImgColor]];
    
    //    cell.headLabel.backgroundColor = labelColor;
    //    cell.headLabel.layer.cornerRadius = 25;
    //    cell.headLabel.clipsToBounds = YES;
    cell.headLabel.text = [cell.yaoqingLabel.text substringToIndex:1];
    cell.seeLabel.hidden = YES;
    
    return cell;
    // Configure the cell...
    
    //return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _newower = _dataArr[indexPath.row][@"maccid"];
    NSLog(@"%@",_dataArr[indexPath.row]);
    NSString * str = [NSString stringWithFormat:@"是否任命%@为新群主",_dataArr[indexPath.row][@"nike"]];
    UIAlertView * aler = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"任命并离开该群",@"任命并成为普通成员",nil];
    // aler.tag = 21;
    [aler show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString * leave;
    NSLog(@"%ld",buttonIndex);
    if(buttonIndex==1){
        leave = @"1";
    }else if(buttonIndex==2){
        
        leave = @"2";
    }
    if(buttonIndex != 0){
        
        [TKTeamAction replaceMaster:_groupID owner:[TKUserSetting sharedManager].username newowner:_newower leave:leave respose:^(BOOL aSuccess, NSString *aMessage) {
            if(aSuccess){
                [XYHUDCore showSuccessWithStatus:@"更新成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                
                [XYHUDCore showErrorWithStatus:aMessage];
            }
            
        }];
        
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
