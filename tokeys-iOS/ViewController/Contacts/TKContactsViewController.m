//
//  TKContactsViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//

#import "TKContactsViewController.h"
#import "TKRecentChatItemCell.h"
#import "TKInvitationTableViewCell.h"
#import "TKUserSetting.h"
#import "TKContactsAction.h"
#import "TKChatTableViewCell.h"
#import "TKChatInfoViewController.h"

@interface TKContactsViewController ()<UITableViewDataSource,UITableViewDelegate,NIMLoginManagerDelegate,
NIMUserManagerDelegate,UIAlertViewDelegate,TKChatTableViewCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSArray * arr;//云信好友数据

@property (nonatomic,strong)NSArray * groupArr;//云信群数据

@property (nonatomic,strong)NSMutableArray * friArr;//本地服务器好友数据

@property (nonatomic,assign)BOOL isFresh;//是否刷新

@property (nonatomic,strong)NSMutableArray * dataArr;//自己建的群

@property (nonatomic,strong)NSMutableArray * dataOther;

@property (nonatomic,assign)NSInteger num;
@property (nonatomic,assign)NSInteger totalSec;//判断一共多少组

@end

@implementation TKContactsViewController

- (instancetype)init {
    return [self initWithNibName:@"TKContactsViewController" bundle:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] userManager] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr= [NSMutableArray array];
    _dataOther = [NSMutableArray array];
    
    _friArr = [[NSMutableArray alloc] initWithArray:[TKDataCore sharedCore].getUserAllFriend];
    
    [self loadData];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jianqun) name:@"jianqun" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jianqun) name:@"jieshanqun" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jianqun) name:@"tuiqun" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jianqun) name:@"qunxinxi" object:nil];
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[[NIMSDK sharedSDK] userManager] addDelegate:self];
    
}

- (void)loadData{
    
    _groupArr = [[[NIMSDK sharedSDK] teamManager] allMyTeams];
    
    if (_dataOther.count>0) {
        [_dataOther removeAllObjects];
    }
    if (_dataArr.count>0) {
        [_dataArr removeAllObjects];
    }
    for(NIMTeam * team in _groupArr){
        if([team.owner isEqualToString:[TKUserSetting sharedManager].username]){
            [_dataArr addObject:team];
        }else{
            
            [_dataOther addObject:team];
        }
    }
    
    _arr = [[[NIMSDK sharedSDK] userManager] myFriends];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[TKUserSetting sharedManager].username forKey:@"accid"];
    
    [TKContactsAction friendList:^(NSArray<TKFriendModel *> *friendList, NSString *aMessage) {
        if(self.friArr.count>0){
            [self.friArr removeAllObjects];
        }
        if (friendList!=nil) {
            [self.friArr addObjectsFromArray:friendList];
            
            [self.tableView reloadData];
        }
    }];
    
    /*
    [HttpRequest newGetWithURL:HTTP_URL(imperson_friendList) params:dict andNeedHub:NO success:^(id responseObject) {
        
        if(self.friArr.count>0){
            [self.friArr removeAllObjects];
        }
        
        NSArray * arr =responseObject[@"data"];
        if (arr == nil || arr.count ==0 ) {
            return;
        }
        [[XYDataCore sharedDataCore] saveUserAllFriend:arr];
        
        for(NSDictionary * diction in arr){
            
            myFriendModel * model = [[myFriendModel alloc]init];
            [model setValuesForKeysWithDictionary:diction];
            [_friArr addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    */
}

-(void)jianqun{
    
    [self loadData];
    // [self.tableView reloadData];
    
}

- (void)createTableView{
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"TKChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"chatCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TKInvitationTableViewCell" bundle:nil] forCellReuseIdentifier:@"yaoqingCell"];
   
    
    if(@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
}

- (void)requestData:(BOOL)isLoadMore
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!isLoadMore)
        {
            [self pushDon];
        }else{
            
            //[self xialafresh];
            
        }
        //5.结束动画
        [self.tableView reloadData];
    });
}
- (void)pushDon
{
    _isFresh = YES;
    //_pageNum = 1;
    [self loadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 0;
    }
    if (section == 2){
        return _dataArr.count;
    }
    if (section == 3){
        return _dataOther.count;
    }
    if (section == 4){
        return _friArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            TKRecentChatItemCell * cell = [TKRecentChatItemCell cellWithTableView:tableView];
            cell.headImg.backgroundColor = redMainColor;
            cell.headImg.image = [UIImage imageNamed:@"chat_invite_icon"];
            cell.titleLab.text = @"邀请好友";
            return cell;
        }else if(indexPath.row==1){
            TKRecentChatItemCell * cell = [TKRecentChatItemCell cellWithTableView:tableView];
            cell.headImg.image = [UIImage imageNamed:@"chat_doctor_icon"];
            cell.titleLab.text = @"新建群组";
            return cell;
        }
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            TKRecentChatItemCell * cell = [TKRecentChatItemCell cellWithTableView:tableView];
            cell.headImg.image = [UIImage imageNamed:@"contact_call_icon"];
            cell.titleLab.text = @"我的单位";
            return cell;
        }else if(indexPath.row==1){
            TKRecentChatItemCell * cell = [TKRecentChatItemCell cellWithTableView:tableView];
            cell.headImg.image = [UIImage imageNamed:@"contact_video_icon"];
            cell.titleLab.text = @"我的部门";
            return cell;
        }
    }else if(indexPath.section==2 || indexPath.section==3){
        TKInvitationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"yaoqingCell" forIndexPath:indexPath];
        NIMTeam * user = [[NIMTeam alloc]init];
        if (indexPath.section==2) {
            user = _dataArr[indexPath.row];
        }else{
            user = _dataOther[indexPath.row];
        }
        cell.yaoqingLabel.text =user.teamName;
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
    }else if(indexPath.section==4){
        
        TKChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
        if (indexPath.row>_friArr.count) {
            return cell;
        }
        TKFriendModel * model = _friArr[indexPath.row];
        cell.infoLabel.text = model.phone;
        cell.nameLabel.text = model.nick;
        cell.number = indexPath.row;
        cell.headLabel.hidden = NO;
        cell.headImage.hidden = NO;
        [cell.headImage setImage:[UIImage imageNamed:TK_ImgColor]];
        cell.headLabel.text = [cell.nameLabel.text substringToIndex:1];
        cell.infoLabel.textColor = [UIColor lightGrayColor];
        cell.timeLabel.hidden = YES;
        cell.delegate = self;
        cell.Lastbutton.hidden = YES;
        cell.callLabel.hidden = NO;
        return cell;
    }
    return nil;
}
#pragma mark -紧急呼叫
#pragma mark TKChatTableViewCellDelegate
-(void)chatTableViewCell:(TKChatTableViewCell *)aCell callTopeople:(NSInteger)number{
    _num = number;
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否需要紧急呼叫" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 100;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ((alertView.tag == 100)) {
        
        if(buttonIndex==1){
            self.navigationController.navigationBarHidden = NO;
            TKChatInfoViewController * chatInfo = [[TKChatInfoViewController alloc]init];
            TKFriendModel * user = [[TKFriendModel alloc]init];
            if (_groupArr.count==0) {
                user= _friArr[_num-1];
            }else{
                user = _friArr[_num];
            }
//            chatInfo.isCall = YES;
//            chatInfo.userID =user.accid;
//            chatInfo.nameStr = user.nick;
//            NIMSession *session = [NIMSession session:user.accid type:NIMSessionTypeP2P];
//            chatInfo.session = session;
            [self.navigationController pushViewController:chatInfo animated:YES];
//            NSDictionary *dict = @{NTESNotifyID :@"1",NTESCustomContent :NTESCustom};
//            NSData *data = [NSJSONSerialization dataWithJSONObject:dict
//                                                           options:0
//                                                             error:nil];
//            NSString *content = [[NSString alloc] initWithData:data
//                                                      encoding:NSUTF8StringEncoding];
//
//            NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
//            notification.apnsContent = [NSString stringWithFormat:@"%@发来了紧急呼叫",NTESCustom];
//            notification.sendToOnlineUsersOnly = NO;
//            NIMCustomSystemNotificationSetting *setting = [[NIMCustomSystemNotificationSetting alloc] init];
//            setting.apnsEnabled = YES;
//            notification.setting = setting;
//            notification.apnsPayload = dict;
//            notification.sendToOnlineUsersOnly = YES;
//            [[[NIMSDK sharedSDK] systemNotificationManager] sendCustomNotification:notification
//                                                                         toSession:session
//                                                                        completion:nil];
            
        }else{
            
            
        }
    }else if (alertView.tag == 230){
        
        if(buttonIndex == 1){
//            self.navigationController.navigationBarHidden = NO;
//            PersonDataViewController * person = [[PersonDataViewController alloc]init];
//            [self.navigationController pushViewController:person animated:YES];
        }
        
    }else if (alertView.tag == 231){
        
        if(buttonIndex == 1){
//            self.navigationController.navigationBarHidden = NO;
//            PersonDataViewController * person = [[PersonDataViewController alloc]init];
//            [self.navigationController pushViewController:person animated:YES];
        }
        
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            return 70;
        }else if(indexPath.row==1){
            return 70;
        }else if(indexPath.row==1){
            return 70;
        }else if(indexPath.row==1){
            return 70;
        }else{
            return 70;
        }
    }else{
        return 70;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0){
        return 20;
    }
    if(section==1 && _dataArr.count==0){
        return 0;
    }
    if(section==2 && _dataOther.count==0){
        return 0;
    }
    return 40;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    if(section==1 && _dataArr.count>0){
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 200, 20)];
        label.textColor = blcolor;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.text = @"   我的群组";
        return label;
        
    }else if(section==2 && _dataOther.count>0){
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 200, 20)];
        label.textColor = blcolor;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.text = @"   加入群组";
        return label;
    }else if(section==3 && _friArr.count>0){
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 200, 20)];
        label.textColor = blcolor;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.text = @"   我的好友";
        return label;
        
    }
    return nil;
}

-(void)jumpToNext:(NSInteger)number{
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setBackNav];
    //NSLog(@"%@",selfmodel.aid);
    if(indexPath.section==0){
        if(indexPath.row==0){//---------------邀请好友
//            selectFriViewController * fri = [[selectFriViewController alloc]init];
//            [self.navigationController pushViewController:fri animated:YES];
        }else if(indexPath.row==1){//--------------新建群组-------------
            
            
//            qunmingViewController * invite = [[qunmingViewController alloc]init];
//            invite.arr = self.friArr;
//            [self.navigationController pushViewController:invite animated:YES];
        }
        
    }else if(indexPath.section==1){
        
    }else if(indexPath.section==2 || indexPath.section==3){
        TKChatInfoViewController * chatInfo = [[TKChatInfoViewController alloc]init];
        NIMTeam * user = [[NIMTeam alloc]init];
        if (indexPath.section==2) {
            user = _dataArr[indexPath.row];
        }else{
            user = _dataOther[indexPath.row];
        }
//        chatInfo.userID = user.teamId;
//        chatInfo.type = 1;
//
//        NSString * title = [NSString stringWithFormat:@"%@(%zd人)",[user teamName],[user memberNumber]];
//        chatInfo.nameStr =title;
//
//        NIMSession *session = [NIMSession session:user.teamId type:NIMSessionTypeTeam];
//        chatInfo.session = session;
        [self.navigationController pushViewController:chatInfo animated:YES];
        
    }else if(indexPath.section==4){
        TKChatInfoViewController * chatInfo = [[TKChatInfoViewController alloc]init];
//        myFriendModel * user = [[myFriendModel alloc]init];
//        user = _friArr[indexPath.row];
//        chatInfo.userID =user.accid;
//        chatInfo.nameStr = user.nick;
//        NIMSession *session = [NIMSession session:user.accid type:NIMSessionTypeP2P];
//        chatInfo.session = session;
        [self.navigationController pushViewController:chatInfo animated:YES];
        
    }
}
-(void)setBackNav{
    CGRect rect = self.navigationController.navigationBar.frame;
    rect.origin.y = 20;
    self.navigationController.navigationBar.frame = rect;
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

