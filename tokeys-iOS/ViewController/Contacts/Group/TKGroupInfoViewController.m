//
//  TKGroupInfoViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKGroupInfoViewController.h"
#import "PellTableViewSelect.h"
#import "TKMembersTableViewController.h"
#import "UIView+Toast.h"
#import "TKTeamAction.h"
#import "TKGroupNoticeViewController.h"
#import "TKGroupHeadTableViewCell.h"
#import "TKInvitationTableViewCell.h"
#import "TKInviteViewController.h"
#import "TKChatInfoViewController.h"

@interface TKGroupInfoViewController ()<UITableViewDataSource,UITableViewDelegate,TKGroupHeadSelectDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * memberArray;
@property (nonatomic,strong)NSArray * titleArray;
@property (nonatomic,strong)NSArray * tiPicArr;
@property (nonatomic,copy)NSString * groupOwner;//群管理者
@property (nonatomic,copy)NSString * ope ;//群消息状态
@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,copy)NSString *owerName;//群创建者
@property (nonatomic,copy)NSString * backImg;//群背景

@end

@implementation TKGroupInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    //   [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NIMTeam *team = [NIMSDK.sharedSDK.teamManager teamById:_groupID];
    if (team) {
        //_owerName = team.owner;
        _groupOwner = team.owner;
        //_qunming = team.teamName;
        [NIMSDK.sharedSDK.teamManager fetchTeamMembersFromServer:_groupID completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            NSLog(@"");
            if (_memberArray==nil) {
                _memberArray = [NSMutableArray array];
                for (NIMTeamMember *m in members) {
                    NSMutableDictionary *info = [NSMutableDictionary dictionary];
                    [info setObject:m.userId forKey:@"accid"];
                    [info setObject:m.nickname==nil?@"":m.nickname forKey:@"nick"];
                    [_memberArray addObject:info];
                    [_tableView reloadData];
                }
            }
        }];
    }
    self.title = self.qunming;
    self.memberArray  = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        [self loadData];
    });
    
    [self createUI];
    
    [self createLeftButton];
    
    // Do any additional setup after loading the view.
}

- (void)createLeftButton{
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(0, 0, 28, 7);
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseButton.layer.cornerRadius = 3;
    [releaseButton setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    // [releaseButton setBackgroundColor:[UIColor orangeColor]];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    
}


-(void)releaseInfo{
    if(_isBumen == YES||[self.groupID isEqualToString:[TKUserSetting sharedManager].tid]){
        if([self.ope isEqualToString:@"0"]){
            self.titleArray = @[@"静音",@"群公告"];
        }else{
            self.titleArray = @[@"取消静音",@"群公告"];
        }
        _tiPicArr = @[@"",@"",@"",@""];
    }else{
        if ([self.groupOwner isEqualToString:[TKUserSetting sharedManager].username]) {
            if([self.ope isEqualToString:@"0"]){
                self.titleArray = @[@"静音",@"群公告",@"解散群",@"退出本群"];
            }else{
                self.titleArray = @[@"取消静音",@"群公告",@"解散群",@"退出本群"];
            }
            _tiPicArr = @[@"",@"",@"",@""];
        }else{
            
            if([self.ope isEqualToString:@"0"]){
                self.titleArray = @[@"静音",@"群公告",@"退出本群"];
            }else{
                
                self.titleArray = @[@"取消静音",@"群公告",@"退出本群"];
            }
            _tiPicArr = @[@"",@"",@""];
        }
        
    }
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width-100, 55, 150, 200) selectData:self.titleArray images:_tiPicArr action:^(NSInteger index) {
        if(index == 3){
            
            if([self.groupOwner isEqualToString:[TKUserSetting sharedManager].username]){
                TKMembersTableViewController * liebiao = [[TKMembersTableViewController alloc]init];
                liebiao.title = @"选择新群主";
                liebiao.dataArr = [NSMutableArray arrayWithArray:self.memberArray];
                liebiao.groupID = self.groupID;
                [self.navigationController pushViewController:liebiao animated:YES];
                
            }else{
                
                UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否离开该群" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: @"取消",nil];
                aler.tag = 23;
                [aler show];
                
            }
            
        }else if(index==2&&self.titleArray.count==3){
            
            if([self.groupOwner isEqualToString:[TKUserSetting sharedManager].username]){
                TKMembersTableViewController * liebiao = [[TKMembersTableViewController alloc]init];
                liebiao.title = @"选择新群主";
                liebiao.dataArr = [NSMutableArray arrayWithArray:self.memberArray];
                liebiao.groupID = self.groupID;
                [self.navigationController pushViewController:liebiao animated:YES];
                
            }else{
                
                UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否离开该群" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: @"取消",nil];
                aler.tag = 23;
                [aler show];
                
            }
            
        }else if(index==2&&self.titleArray.count==4){
            
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否解散该群" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: @"取消",nil];
            aler.tag = 21;
            [aler show];
            
        }else if(index==0){//群消息接收提醒
            NSString * ssst;
            if([self.ope isEqualToString:@"0"]){
                self.ope = @"1";
                ssst = @"1";
            }else{
                self.ope = @"0";
                ssst = @"2";
            }
            [TKTeamAction updateMsgSwitch:self.groupID accid:[TKUserSetting sharedManager].username ope:ssst respose:^(BOOL aSuccess, NSString *aMessage) {
                if(aSuccess){
                    if([self.ope isEqualToString:@"1"]){
                        [XYHUDCore showSuccessWithStatus:@"关闭群提醒"];
                    }else{
                        [XYHUDCore showSuccessWithStatus:@"开启群提醒"];
                    }
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    
                    [XYHUDCore showErrorWithStatus:aMessage];
                }
            }];
            
            
        }else if(index==1){
            
            TKGroupNoticeViewController * noti = [[TKGroupNoticeViewController alloc]init];
            noti.groupID = self.groupID;
            noti.groupowner = self.groupOwner;
            [self.navigationController pushViewController:noti animated:YES];
        }
    } animated:YES];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==21){//解散群
        
        NSString * tidstr = [NSString stringWithFormat:@"%@",[TKUserSetting sharedManager].tid];
        if([self.groupID isEqualToString:tidstr]){
            
            [self.view makeToast:@"部门群不能随意解散哟" duration:1 position:CSToastPositionCenter];
            
            return;
        }
        
        if(buttonIndex==0){
            
            [TKTeamAction team_remove:self.groupID owner:[TKUserSetting sharedManager].username respose:^(BOOL aSuccess, NSString *aMessage) {
                if (aSuccess) {
                    [NIMSDK.sharedSDK.teamManager dismissTeam:self.groupID completion:^(NSError * _Nullable error) {
                        if (error==nil) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"jieshanqun" object:nil userInfo:nil];
                        }
                    }];
                    [XYHUDCore showSuccessWithStatus:@"解散成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"jieshanqun" object:nil userInfo:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [XYHUDCore showErrorWithStatus:aMessage];
                }
            }];
            
        }
    }else if(alertView.tag==22){//是群主
        
        
    }else if(alertView.tag==23){//不是群主
        
        NSString * tidstr = [NSString stringWithFormat:@"%@",[TKUserSetting sharedManager].tid];
        if([self.groupID isEqualToString:tidstr]){
            
            [self.view makeToast:@"部门群不能随意退出哟" duration:1 position:CSToastPositionCenter];
            return;
        }
        if(buttonIndex==0){
            
            [TKTeamAction team_leave:self.groupID accid:[TKUserSetting sharedManager].username respose:^(BOOL aSuccess, NSString *aMessage) {
                if (aSuccess) {
                    [XYHUDCore showSuccessWithStatus:@"离开了该群"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"tuiqun" object:nil userInfo:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            
        }
    }else if(alertView.tag == 25){//踢人
        if(buttonIndex==0){
            
            if([self.memberArray[_indexPath.row-2][@"maccid"] isEqualToString:[TKUserSetting sharedManager].username]){
                return;
            }
            NSArray * arr = @[self.memberArray[_indexPath.row-2][@"maccid"]];
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:nil];
            NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            
            [TKTeamAction team_kick:self.groupID owner:self.groupOwner members:myString respose:^(BOOL aSuccess, NSString *aMessage) {
                if (aMessage) {
                    [XYHUDCore showSuccessWithStatus:@"剔除成功"];
                    [self loadData];
                    [self.tableView reloadData];
                }
            }];
            
            
        }
        
    }
    
}



-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController]
    
}

- (void)loadData{
    
    [TKTeamAction team_detail:self.groupID respose:^(TKGroupNewModel *model, NSString *aMessage) {
        
        if (model!=nil&& model.members.count>0) {
            if (self.memberArray.count>0) {
                [self.memberArray removeAllObjects];
            }
        }
        if(model.owner == nil && model.owner.maccid==nil){
            for (NSDictionary *dictionary in model.members) {
                if([dictionary[@"isAdmin"] intValue]!=0){
                    self.groupOwner = dictionary[@"maccid"];
                    self.owerName = dictionary[@"nike"];
                }else{
                    [self.memberArray addObject:dictionary];
                }
            }
            [self.tableView reloadData];
        }else{
            self.groupOwner = model.owner.maccid;
            
            for (NSDictionary * dictionary in model.members) {
                if ([dictionary[@"maccid"] isEqualToString:[TKUserSetting sharedManager].username]&&[self.groupOwner isEqualToString:[TKUserSetting sharedManager].username]) {

                }else{
                    [self.memberArray addObject:dictionary];
                }
                
                
            }
            //self.owerName = model.owner.nickname;
            //self.owerName = model.team.tname;
            [self.tableView reloadData];
        }
        
    }];
}

-(void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGR.minimumPressDuration = 1.0;
    [_tableView addGestureRecognizer:longPressGR];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TKInvitationTableViewCell" bundle:nil] forCellReuseIdentifier:@"yaoqingCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TKGroupHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"FUKEID"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
//长按手势
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    NSString * tidstr = [NSString stringWithFormat:@"%@",[TKUserSetting sharedManager].tid];
    if([self.groupID isEqualToString:tidstr]){
        
        [self.view makeToast:@"部门群不能随意踢人哟" duration:1 position:CSToastPositionCenter];
        
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gesture locationInView:_tableView];
        _indexPath = [_tableView indexPathForRowAtPoint:point];
        
        if(_indexPath.row>1&&[self.groupOwner isEqualToString:[TKUserSetting sharedManager].username]){
            
            NSString * string = [NSString stringWithFormat:@"是否移除%@该成员",self.memberArray[_indexPath.row-2][@"nike"]];
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
            aler.tag = 25;
            [aler show];
            
        }
        
    }
}
#pragma mark - tableViewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isBumen==YES){
        return self.memberArray.count+1;
    }else{
        return self.memberArray.count+2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        TKGroupHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FUKEID" forIndexPath:indexPath];
        cell.groupChatButton.hidden = YES;
        cell.nameLabel.text = [NSString stringWithFormat:@"    %@",self.owerName];
        cell.nameLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.personLabel.hidden = YES;
        [cell.groupHeadImage tk_setImageWithURL:_backImg placeholderImage:[UIImage imageNamed:@"group_chat_bg"]];
        
        
        // cell.personLabel.backgroundColor =labelColor;
        //        if (cell.nameLabel.text.length == 0) {
        //            cell.personLabel.text =@"空";
        //        }else{
        //            cell.personLabel.text = [cell.nameLabel.text substringToIndex:1];
        //        }
        return cell;
    }else if(indexPath.row==1&&!_isBumen){
        
        TKInvitationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"yaoqingCell" forIndexPath:indexPath];
        cell.headImage.hidden = NO;
        cell.headImage.image = [UIImage imageNamed:@"add_menber_icon"];
        cell.yaoqingLabel.text = @"添加";
        cell.headLabel.hidden = YES;
        return cell;
    }else{
        TKInvitationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"yaoqingCell" forIndexPath:indexPath];
        cell.headImage.image = [UIImage imageNamed:@"chat_d_img"];
        NSString *nike = @"";
        if(_isBumen==YES){
            nike =self.memberArray[indexPath.row-1][@"nike"];
        }else{
            nike =self.memberArray[indexPath.row-2][@"nike"];
        }
        cell.yaoqingLabel.text = nike;
        //cell.headImage.hidden = YES;
        cell.yaoqingLabel.textColor = [UIColor blackColor];
        cell.headLabel.hidden = NO;
        cell.headImage.hidden = NO;
        [cell.headImage setImage:[UIImage imageNamed:TK_ImgColor]];
        
       
        if (cell.yaoqingLabel.text.length == 0) {
            cell.headLabel.text =@"空";
        }else{
            cell.headLabel.text = [cell.yaoqingLabel.text substringToIndex:1];
        }
        cell.seeLabel.hidden = YES;
        
        return cell;
    }
    
}
#pragma mark TKGroupHeadSelectDelegate
-(void)groupHeadTableViewCell:(TKGroupHeadTableViewCell *)aCell selectToPeople:(id)asender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        UIImage * result;
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_backImg]];
        result = [UIImage imageWithData:data];
        if(result){
            return result.size.height/result.size.width*screen_width;
        }else{
            return screen_width/8*5;
        }
        
    }else{
        return 70;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row == 1 && !_isBumen){//添加成员
        
        NSString * tidstr = [NSString stringWithFormat:@"%@",[TKUserSetting sharedManager].tid];
        if([self.groupID isEqualToString:tidstr]){
            
            [self.view makeToast:@"部门群不能随意添加成员哟" duration:1 position:CSToastPositionCenter];
            
            return;
        }
        
        if([self.groupOwner isEqualToString:[TKUserSetting sharedManager].username]){
            TKInviteViewController * inv = [[TKInviteViewController alloc]init];
            inv.isYaoqin = YES;
            inv.isLaren = YES;
            inv.groupID = self.groupID;
            NSLog(@"%@",inv.dataArr);
            [self.navigationController pushViewController:inv animated:YES];
            
        }else{
            
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你不是群主" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            aler.tag = 110;
            [aler show];
            
        }
        
    }else if(indexPath.row==0){
        
    }else {
        
        
        TKChatInfoViewController * chatInfo = [[TKChatInfoViewController alloc]init];
        NIMSession *session = nil;
        if(_isBumen ==YES){
            
            chatInfo.userID =self.memberArray[indexPath.row-1][@"maccid"];
            chatInfo.nameStr = self.memberArray[indexPath.row-1][@"nickname"];
            session = [NIMSession session:self.memberArray[indexPath.row-1][@"maccid"] type:NIMSessionTypeP2P];
        }else{
            chatInfo.userID =self.memberArray[indexPath.row-2][@"maccid"];
            chatInfo.nameStr = self.memberArray[indexPath.row-2][@"nickname"];
            session = [NIMSession session:self.memberArray[indexPath.row-2][@"maccid"] type:NIMSessionTypeP2P];
        }
        chatInfo.session = session;
        [self.navigationController pushViewController:chatInfo animated:YES];
        
        
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
