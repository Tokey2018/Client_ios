//
//  TKChatListViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//

#import "TKChatListViewController.h"
#import "NTESVideoChatViewController.h"
#import "NTESAudioChatViewController.h"
#import "NTESWhiteboardViewController.h"
#import "NTESChartletAttachment.h"
#import "NTESWhiteboardAttachment.h"
#import "TKChatInfoViewController.h"
#import "TKPersonDataViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UITableView+PullRefresh.h"
#import "TKChatTableViewCell.h"
#import "TKRecentChatItemCell.h"
#import "TKUserSetting.h"
#import "TKSystemNotiViewController.h"
#import "TKMessageAlert.h"

@interface TKChatListViewController ()<UITableViewDataSource,UITableViewDelegate,NIMConversationManagerDelegate,NIMTeamManagerDelegate,NIMUserManagerDelegate,NIMNetCallManagerDelegate,NIMRTSManagerDelegate,NIMSystemNotificationManagerDelegate,NIMChatManagerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * arr;
@property (nonatomic,assign)BOOL isFresh;//是否刷新
@property (nonatomic,strong) AVAudioPlayer *player; //播放提示音
@property (nonatomic,assign)NSInteger numNoti;//时间记录
@property (nonatomic,assign)BOOL isNoti;//是否有通知
@property (nonatomic,assign)id xiaoxiNumber;//接收到的消息数
@property (nonatomic,strong)UILabel * label;

@end

@implementation TKChatListViewController

- (instancetype)init {
    return [self initWithNibName:@"TKChatListViewController" bundle:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(freshChat) name:@"freshChat" object:nil];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [[[NIMAVChatSDK sharedSDK]netCallManager] addDelegate:self];
    [[NIMSDK sharedSDK].teamManager addDelegate:self];
    [[NIMAVChatSDK sharedSDK].rtsManager addDelegate:self];
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    [[[NIMSDK sharedSDK] chatManager]addDelegate:self];
    [self createTableVIew];
    _arr=[NSMutableArray array];
    [self createData];
    [self.tableView reloadData];
    _numNoti = 0;
    _isNoti = NO;
    
}

-(void)loadNewMessage{
    
    _numNoti++;
    
    if(_arr.count==0){
        
        _label.hidden = NO;
        
    }else{
        _label.hidden = YES;
        
    }
    
    
    //TODO:---------向后台发送在线消息----------
    if (_numNoti==6) {
        _numNoti=0;
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeSp1 = [NSString stringWithFormat:@"%lld", (long long)a];
        //  NSLog(@"%@",timeSp1);
//        [HttpRequest getWithURL:HTTP_URL(@"/user/checkUserOnline") params:@{@"uid":[LJUserSetting sharedManager].uid,@"timetamp":timeSp1} success:^(id responseObject) {
//        } failure:^(NSError *error) {
//            [XYHUDCore showErrorWithStatus:@"请求失败"];
//        }];
    }
    
}


-(void)freshChat{
    _arr=[NSMutableArray array];
    [self createData];
    [self.tableView reloadData];
    
    
}

-(void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallType)type message:(NSString *)extendMessage{
    
    NTESVideoChatViewController* vc = [[NTESVideoChatViewController alloc] initWithCaller:caller callId:callID];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:NO];
    
    
}
-(void)onRTSRequest:(NSString *)sessionID
               from:(NSString *)caller
           services:(NSUInteger)types message:(NSString *)extendMessage{
    
    NTESWhiteboardViewController *vc = [[NTESWhiteboardViewController alloc] initWithSessionID:sessionID
                                                                                        peerID:caller
                                                                                         types:types
                                                                                          info:extendMessage];
    [self presentViewController:vc animated:NO completion:nil];
    
    
    
}

- (void)createData{
    
    _arr =[NSMutableArray arrayWithArray:[[NIMSDK sharedSDK].conversationManager allRecentSessions]];
    if(_arr.count==0){
        
        _label.hidden = NO;
        
    }else{
        _label.hidden = YES;
        
    }
    // NSLog(@"%@",_arr);
    
}

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    [self.arr addObject:recentSession];
    _label.hidden = YES;
    
    [self.tableView reloadData];
}
- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    for (NIMRecentSession *recent in self.arr) {
        if ([recentSession.session.sessionId isEqualToString:recent.session.sessionId]) {
            [self.arr removeObject:recent];
            break;
        }
    }
    NSInteger insert = [self findInsertPlace:recentSession];
    [self.arr insertObject:recentSession atIndex:insert];
    if(_arr.count==0){
        
        _label.hidden = NO;
        
    }else{
        _label.hidden = YES;
        
    }
    
    [self.tableView reloadData];
    
    
    
}

- (NSInteger)findInsertPlace:(NIMRecentSession *)recentSession{
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp) {
            *stop = YES;
            find  = YES;
            matchIdx = idx;
        }
    }];
    if (find) {
        return matchIdx;
    }else{
        return self.arr.count;
    }
}


- (void)createTableVIew{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, screen_width, screen_height-49-30) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0,W_In_375(330), screen_width, 60)];
    _label.font = [UIFont boldSystemFontOfSize:17];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = blcolor;
    _label.text = @"暂无聊天记录哦";
    _label.hidden = YES;
    [_tableView addSubview:_label];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TKChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"chatCell"];
    
    if (@available(iOS 11.0, *)){
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //1.在开启下拉或者上拉前调用
    [self.tableView setup];
    //2.开启下拉刷新
    [self.tableView setPullDownEnable:YES];
    //4.设置回调函数
    __weak typeof(self)weakSelf = self;
    [self.tableView setLoadingBlock:^(BOOL pullDown) {
        
        [weakSelf requestData:!pullDown];
    }];
    
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
    [self createData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1){
        return 0;
    }else if (section==2) {
        return _arr.count;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return W_In_375(10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0||indexPath.section==1){
        if(indexPath.section==0&&indexPath.row==1){
            TKChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
            cell.nameLabel.text = @"医仙小助手";
            cell.headImage.image = [UIImage imageNamed:@"chat_doctor_icon"];
            return cell;
        }else{
            TKRecentChatItemCell * cell = [TKRecentChatItemCell cellWithTableView:tableView];
            if(indexPath.section==0&&indexPath.row==0){
                cell.headImg.backgroundColor = redMainColor;
                cell.headImg.image = [UIImage imageNamed:@"chat_invite_icon"];
                cell.titleLab.text = @"邀请好友";
            }else if(indexPath.section==1&&indexPath.row==0){
                cell.headImg.backgroundColor = [UIColor clearColor];
                cell.headImg.image = [UIImage imageNamed:@"chat_call_icon"];
                cell.titleLab.text = @"电话会议";
            }else if(indexPath.section==1&&indexPath.row==1){
                cell.headImg.backgroundColor = [UIColor clearColor];
                cell.headImg.image = [UIImage imageNamed:@"chat_video_icon"];
                cell.titleLab.text = @"视频会议";
            }
            return cell;
        }
        
        
        
    }else{
        TKChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
        NIMRecentSession * rsession = [[NIMRecentSession alloc]init];
        rsession = _arr[indexPath.row];
        if(rsession.unreadCount==0){
            cell.tishiLabel.hidden = YES;
        }else{
            cell.tishiLabel.layer.cornerRadius = 11;
            cell.tishiLabel.clipsToBounds = YES;
            cell.tishiLabel.textAlignment = NSTextAlignmentCenter;
            cell.tishiLabel.textColor = [UIColor whiteColor];
            cell.tishiLabel.hidden = NO;
            cell.tishiLabel.text = [NSString stringWithFormat:@"%ld",rsession.unreadCount];
        }
        if(rsession.session.sessionType==NIMSessionTypeTeam){
            cell.nameLabel.text =[[[NIMSDK sharedSDK].teamManager teamById:rsession.session.sessionId]teamName];
            cell.headImage.image = [UIImage imageNamed:@"moren_group"];//设置群头像
        }else{
            NSString * str =[[[NIMSDK sharedSDK]userManager]userInfo:rsession.session.sessionId].alias;
            NSString * headUrl = [[[NIMSDK sharedSDK]userManager]userInfo:rsession.session.sessionId].userInfo.avatarUrl;
            cell.headImage.layer.cornerRadius = 25;
            cell.headImage.clipsToBounds = YES;
            [cell.headImage tk_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"chat_d_img"]];
            if(str.length>0){
                cell.nameLabel.text = str;
            }else{
                if([rsession.session.sessionId isEqualToString:[TKUserSetting sharedManager].username]){
                    cell.nameLabel.text = @"自己";
                }else{
                    cell.nameLabel.text = rsession.session.sessionId;
                }
            }
        }
        if(rsession.lastMessage.messageType== NIMMessageTypeImage){
            cell.infoLabel.text = @"[图片]";
        }else if(rsession.lastMessage.messageType == NIMMessageTypeVideo){
            cell.infoLabel.text = @"[视频]";
        }else if(rsession.lastMessage.messageType == NIMMessageTypeFile){
            cell.infoLabel.text = @"[文件]";
        }else if(rsession.lastMessage.messageType == 2){
            cell.infoLabel.text = @"[声音]";
        }else if(rsession.lastMessage.messageType == NIMMessageTypeCustom){
            
            NIMCustomObject *object = rsession.lastMessage.messageObject;
            
            if ([object.attachment isKindOfClass:[NTESChartletAttachment class]]) {
                cell.infoLabel.text = @"[贴图]";
            }
            else if ([object.attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
                cell.infoLabel.text = @"[白板]";
            }else{
                cell.infoLabel.text= @"[未知消息]";
            }
            
        }else if(rsession.lastMessage.messageType == NIMMessageTypeNotification){
            cell.infoLabel.text = [self notificationMessageContent:rsession.lastMessage];
        }else if(rsession.lastMessage.messageType == NIMMessageTypeTip){
            cell.infoLabel.text = @"提醒消息";
        }else{
            cell.infoLabel.text = rsession.lastMessage.text;
        }
        cell.timeLabel.text = [TKChatListViewController showTime:rsession.lastMessage.timestamp showDetail:YES];
        return cell;
    }
}


- (NSString *)notificationMessageContent:(NIMMessage *)lastMessage{
    NIMNotificationObject *object = lastMessage.messageObject;
    if (object.notificationType == NIMNotificationTypeNetCall) {
        NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
        if (content.callType == NIMNetCallTypeAudio) {
            return @"[网络通话]";
        }
        return @"[视频聊天]";
    }
    if (object.notificationType == NIMNotificationTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:lastMessage.session.sessionId];
        if (team.type == NIMTeamTypeNormal) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"qunxinxi" object:nil userInfo:nil];
            return @"[讨论组信息更新]";
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"qunxinxi" object:nil userInfo:nil];
            return @"[群信息更新]";
        }
    }
    
    
    return @"[未知消息]";
}
#pragma mark --------------------------代理点击-------------
-(void)jumpToNext:(NSInteger)number{
    if(number==1){//邀请好友
        
    }else if(number==2){//系统通知
        TKSystemNotiViewController * sys = [[TKSystemNotiViewController alloc]init];
        [self.navigationController pushViewController:sys animated:YES];
        _isNoti = NO;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }else if(number==3){//会议
        
    }else if(number==4){//直播
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0||indexPath.section==1){
        if(indexPath.section==0&&indexPath.row==1){
            return 70;
        }else{
            return 70;
        }
    }else{
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setBackNav];
    if(indexPath.row==0&&indexPath.section==0){
        //----------邀请好友-------------
//        selectFriViewController * fri = [[selectFriViewController alloc]init];
//        [self.navigationController pushViewController:fri animated:YES];
    }else if(indexPath.row==1&&indexPath.section==0){
        //----------医仙小助手-------------
//        AssistantViewController *assVC = [[AssistantViewController alloc] init];
//        [self.navigationController pushViewController:assVC animated:YES];
        
    }else if(indexPath.row==0&&indexPath.section==1){
//        //----------电话会议-------------
//        if (auditStatusNum == 5) {
//            inviteTeleconferenceViewController * telecon = [[inviteTeleconferenceViewController alloc]init];
//            [self.navigationController pushViewController:telecon animated:YES];
//        }else if(auditStatusNum == 1){
//            [self.view makeToast:@"您还未通过认证,认证通过后即可使用此功能" duration:1 position:CSToastPositionCenter];
//        }else if(auditStatusNum==0){
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"请前往个人信息界面填写相关信息进行" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
//            alert.tag = 222;
//            [alert show];
//
//        }else if(auditStatusNum == -1){
//            [self.view makeToast:@"您还未通过认证,认证通过后即可使用此功能" duration:1 position:CSToastPositionCenter];
//        }
    }else if(indexPath.row==1&&indexPath.section==1){
        //----------视频会议-------------
//        if (auditStatusNum == 5) {
//            NTESChatroomListViewController * nets = [[NTESChatroomListViewController alloc]init];
//            [self.navigationController pushViewController:nets animated:YES];
//        }else if(auditStatusNum == 1){
//            [self.view makeToast:@"您还未通过认证,认证通过后即可使用此功能" duration:1 position:CSToastPositionCenter];
//        }else if(auditStatusNum==0){
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"请前往个人信息界面填写相关信息进行" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
//            alert.tag = 222;
//            [alert show];
//
//        }else if(auditStatusNum == -1){
//
//            [self.view makeToast:@"您还未通过认证,认证通过后即可使用此功能" duration:1 position:CSToastPositionCenter];
//        }
    }else{
        TKChatInfoViewController * chatInfo = [[TKChatInfoViewController alloc] init];
        NIMRecentSession * rsession = [[NIMRecentSession alloc]init];
        rsession = _arr[indexPath.row];
        chatInfo.session = rsession.session;
        chatInfo.userID = rsession.session.sessionId;
        chatInfo.type = rsession.session.sessionType;
        if(chatInfo.type==0){
            NSString * str =[[[NIMSDK sharedSDK]userManager]userInfo:rsession.session.sessionId].alias;
            // cell.headImage.image = [UIImage imageNamed:@"默认头像"];
            if(str.length>0){
                chatInfo.nameStr = str;
            }else{
                if([rsession.session.sessionId isEqualToString:[TKUserSetting sharedManager].username]){
                    chatInfo.nameStr = @"自己";
                }else{
                    chatInfo.nameStr = rsession.session.sessionId;
                }
                
                
            }
            
            
        }else{
            NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:rsession.session.sessionId];
            NSString * title = [NSString stringWithFormat:@"%@(%zd人)",[team teamName],[team memberNumber]];
            chatInfo.nameStr =title;
        }
        [self.navigationController pushViewController:chatInfo animated:YES];
    }
}



#pragma mark - 收到紧急呼叫
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    //    if (!notification.sendToOnlineUsersOnly) {
    //        return;
    //    }
    
    //   NSLog(@"%@",notification.apnsPayload);
    
    NSData *data = [[notification content] dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = notification.apnsPayload;
        NSString * nuu = dict[@"urgency"];
        NSString * name = [NSString stringWithFormat:@"%@发来一个紧急呼叫",dict[@"name"]];
        
        //NSLog(@"%d",nuu);
        if ([nuu isEqualToString:@"1"])
        {
            AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:name delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            alert.tag = 123;
            [alert show];
            
        }
    }
    
    
}
void systemAudioCallback()
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==123) {
        
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
        
    }else if(alertView.tag == 222){
        
        if(buttonIndex == 1){
            
            TKPersonDataViewController * person = [[TKPersonDataViewController alloc]init];
            [self.navigationController pushViewController:person animated:YES];
        }
        
    }
    
}

#pragma mark - 时间
+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail
{
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSInteger hour = msgDateComponents.hour;
    NSTimeInterval gapTime = -msgDate.timeIntervalSinceNow;
    double onedayTimeIntervalValue = 24*60*60;  //一天的秒数
    result = [TKChatListViewController getPeriodOfTime:hour withMinute:msgDateComponents.minute];
    if (hour > 12)
    {
        hour = hour - 12;
    }
    if (gapTime < onedayTimeIntervalValue * 3) {
        int gapDay = gapTime/(60*60*24) ;
        if(gapDay == 0) //在24小时内,存在跨天的现象. 判断两个时间是否在同一天内
        {
            BOOL isSameDay = msgDateComponents.day == nowDateComponents.day;
            result = isSameDay ? [[NSString alloc] initWithFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : (showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"昨天");
        }
        else if(gapDay == 1)//昨天
        {
            result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"昨天";
        }
        else if(gapDay == 2) //前天
        {
            result = showDetail? [[NSString alloc] initWithFormat:@"前天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"前天";
        }
    }
    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * onedayTimeIntervalValue)//一周内
    {
        NSString *weekDay = [TKChatListViewController weekdayStr:msgDateComponents.weekday];
        result = showDetail? [weekDay stringByAppendingFormat:@"%@",result] : weekDay;
    }
    else//显示日期
    {
        NSString *day = [NSString stringWithFormat:@"%zd-%zd-%zd", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
        result = showDetail? [day stringByAppendingFormat:@" %@",result]:day;
    }
    return result;
}

#pragma mark - Private

+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute
{
    NSInteger totalMin = time *60 + minute;
    NSString *showPeriodOfTime = @"";
    if (totalMin > 0 && totalMin <= 5 * 60)
    {
        showPeriodOfTime = @"凌晨";
    }
    else if (totalMin > 5 * 60 && totalMin < 12 * 60)
    {
        showPeriodOfTime = @"上午";
    }
    else if (totalMin >= 12 * 60 && totalMin <= 18 * 60)
    {
        showPeriodOfTime = @"下午";
    }
    else if ((totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)
    {
        showPeriodOfTime = @"晚上";
    }
    return showPeriodOfTime;
}

+(NSString*)weekdayStr:(NSInteger)dayOfWeek
{
    static NSDictionary *daysOfWeekDict = nil;
    daysOfWeekDict = @{@(1):@"星期日",
                       @(2):@"星期一",
                       @(3):@"星期二",
                       @(4):@"星期三",
                       @(5):@"星期四",
                       @(6):@"星期五",
                       @(7):@"星期六",};
    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
}

-(void)onRecvMessages:(NSArray *)messages{
    
    if([[TKUserSetting sharedManager].voice isEqualToString:@"2"]){
        TKMessageAlert  *playSound =[[TKMessageAlert alloc]initSystemShake];
        [playSound playSound];
    }
    
    if([[TKUserSetting sharedManager].shake isEqualToString:@"1"]){
        TKMessageAlert * playsound = [[TKMessageAlert alloc]initSystemShake];
        [playsound play];
        
    }
}

-(void)setBackNav{
    CGRect rect = self.navigationController.navigationBar.frame;
    rect.origin.y = 20;
    self.navigationController.navigationBar.frame = rect;
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
