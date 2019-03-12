//
//  TKChatInfoViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKChatInfoViewController.h"
#import "XYRecordButton.h"
#import "YLYTextView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UITableView+PullRefresh.h"
#import "NIMKit.h"
#import "NIMInputAudioRecordIndicatorView.h"
#import "IQKeyboardManager.h"
#import "TKUserSetting.h"
#import "TKPersonInfoViewController.h"
#import "TKGroupInfoViewController.h"
#import "TKChatMessageCell.h"
#import "TKUrlEditViewController.h"
#import "TZImagePickerController.h"

#import "NTESWhiteboardAttachment.h"
#import "NTESGalleryViewController.h"
#import "NTESWhiteboardAttachment.h"
#import "NIMInputAudioRecordIndicatorView.h"
#import "NIMLoadProgressView.h"
#import "NTESVideoViewController.h"
#import "NTESFilePreViewController.h"
#import "NTESAudioChatViewController.h"
#import "NTESVideoChatViewController.h"

#define K_SliderV_H 28.0

@interface TKChatInfoViewController ()<NIMChatManagerDelegate,NIMNetCallManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NIMMediaManagerDelegate,XYRecordButtonMovesDeleagte,CAAnimationDelegate,TZImagePickerControllerDelegate>
{
    
    UIView *tabbarView;
    UITextField* _chatField;
    NSMutableArray* _dataArray;
    NSMutableDictionary * dictionary;
    NSInteger audioTap;//记录点的那一个音频
    
    float tabbarViewheight;
    
    float keyboardHeight;
    NSString *audioPath;
}
@property (strong , nonatomic) UITableView *tableView;

@property (nonatomic, weak) id<NIMInputActionDelegate> actionDelegate;
@property (nonatomic, strong) NIMInputAudioRecordIndicatorView *audioRecordIndicator;

@property(strong,nonatomic) NSMutableArray *picArray;
@property (nonatomic, strong)UILabel * chatTimelabel;
@property (nonatomic, strong)UIButton * xianbutton;
@property (nonatomic, strong)UIButton * sendButton;
@property (nonatomic, strong) YLYTextView *textView;

@property (nonatomic,strong) UIImage * picima;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,assign) BOOL isZT;
@property (nonatomic,strong) MPMoviePlayerViewController * mpVC;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger numb;//紧急呼叫一次;
@property (nonatomic,strong) UIButton * anButton;//按住说话
@property (nonatomic,assign) NIMAudioRecordPhase recordPhase;
@property (assign, nonatomic, getter=isRecording) BOOL recording;

@property (nonatomic,strong)UIControl *recordbuttonBG;

@property (nonatomic,strong)UIButton * inputButton;

@property (nonatomic,strong)XYRecordButton * recordbutton;

@property (nonatomic,strong)UIButton * sendMessagebutton;

@property (nonatomic,strong)UIButton * keyButton;
@property (nonatomic,strong)UIButton * cameraButton;
@property (nonatomic,strong)UIButton * phoneButton;

@property (nonatomic,strong)UIButton * sockeButton;
@property (nonatomic,strong)UIButton * closeButton;
@property (nonatomic,strong)UIButton * audioPlayButton;
@property (nonatomic,strong)UIButton * audioSendButton;
@property (nonatomic,strong)UIControl * sliderView;


@property (nonatomic,assign)BOOL isFree;//判断是否是闲聊状态,默认闲聊

@end

@implementation TKChatInfoViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        [[[NIMSDK sharedSDK] chatManager] addDelegate:self];
        
    }
    
    return self;
    
}

- (void)dealloc{
    
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [[NIMSDK sharedSDK].mediaManager addDelegate:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    if( [[NIMSDK sharedSDK].mediaManager isPlaying]){
        [[NIMSDK sharedSDK].mediaManager stopPlay];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"freshChat" object:nil userInfo:nil];
    //AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}
- (void)setup{
    //设置输入框的高度
    tabbarViewheight = 50;
    
    _numb = 1;
    _pageNum=1;
    _isZT = YES;
    _time = 0;
    _isFree = YES;
    _dataArray = [[NSMutableArray alloc] init];
    dictionary = [NSMutableDictionary dictionary];
    [[[NIMAVChatSDK sharedSDK] netCallManager] addDelegate:self];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [[[NIMSDK sharedSDK]conversationManager] markAllMessagesReadInSession:self.session];
    // NSArray * arr = [[[NIMSDK sharedSDK]conversationManager] allRecentSessions];
    _picArray = [NSMutableArray array];
 
    
    //自定制导航栏
    [self history];
    [self createNav];
    //聊天内容
    [self createTable];
    //自定制tabbar
    [self createTabbar];
    
    // AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    // Do any additional setup after loading the view.
    [self showNewAudioChat];
}
-(void)showNewAudioChat{
    BOOL isShow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ISSHOWNewAudioChat"] boolValue];
    if (isShow == NO) {
        
        _inputButton.hidden = YES;
        _textView.hidden = YES;
        _phoneButton.hidden = YES;
        _cameraButton.hidden = YES;
        _keyButton.hidden = YES;
        
        tabbarView.backgroundColor = [UIColor clearColor];
        tabbarView.frame = CGRectMake(0, screen_height-120, screen_width, 120);
        [tabbarView setRoundViewByAngle:0];
        
        _recordbutton.frame = CGRectMake(screen_width - tabbarViewheight - 5, 120 - tabbarViewheight - 5, tabbarViewheight, tabbarViewheight);
        _recordbuttonBG.frame = _recordbutton.frame;
        self.sockeButton.frame = _recordbutton.frame;
        self.closeButton.frame = _recordbutton.frame;
        
        
        [_recordbuttonBG setRoundView];
        
        _sliderView.frame = CGRectMake(10, tabbarView.height - K_SliderV_H - 5, screen_width - 120 - K_SliderV_H, K_SliderV_H);
        
        
        
        [_sliderView setRoundView];
        self.recordbuttonBG.frame = CGRectMake(screen_width-120, 0, 120*2, 120*2);
        [self.recordbuttonBG setRoundView];
        self.sliderView.hidden = NO;
        
        float s = 40.0;
        self.sockeButton.frame = CGRectMake(screen_width - 10 - s, 10, s, s);
        
        self.closeButton.frame = CGRectMake(screen_width - 120 + 10, 120 - 10 - s, s, s);
        
        
        UIControl *show = [[UIControl alloc] initWithFrame:self.navigationController.view.bounds];
        show.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self.navigationController.view addSubview:show];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_sockeButton.x+10, tabbarView.y + _sockeButton.y + 30, 30, 30)];
        imageView.image = [UIImage imageNamed:@"show_up_icon"];
        [show addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.y - 20, imageView.x, 20)];
        label.text = @"向上滑动，锁定录制";
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor whiteColor];
        [show addSubview:label];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_closeButton.x + 30, tabbarView.y + _closeButton.y + 10, 30, 30)];
        imageView2.image = [UIImage imageNamed:@"show_left_icon"];
        [show addSubview:imageView2];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView2.y - 20, imageView2.x, 20)];
        label2.text = @"向左滑动，取消录制";
        label2.textAlignment = NSTextAlignmentRight;
        label2.textColor = [UIColor whiteColor];
        [show addSubview:label2];
        [show addTarget:self action:@selector(dismissShowNewAudioChat:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
    }
}
-(void)dismissShowNewAudioChat:(UIControl*)sender{
    [self dismissAudioButton];
    [sender removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"ISSHOWNewAudioChat"];
}
#pragma mark -历史消息
-(void)history{
    
    NSLog(@"%@",self.userID);
    NSLog(@"%ld",self.type);
    NSLog(@"%@",self.nameStr);
    
    NSArray *messagess = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:_session
                                                                             message:nil
                                                                               limit:5*_pageNum];
    NSLog(@"%@",messagess);
    
    
    for (NSInteger i=0;i<messagess.count;i++) {
        NSLog(@"%ld",i);
        NIMMessage * message = messagess[i];
        if(i+1==messagess.count){
            NSLog(@"咋回事");
        }else{
            NIMMessage * messa = messagess[i+1];
            NSLog(@"%lf",message.timestamp-messa.timestamp);
            if(messa.timestamp-message.timestamp>60){
                TKChatItem *chatItem1=[[TKChatItem alloc] init];
                chatItem1.isByself = self;
                chatItem1.content = [TKChatInfoViewController showTime:message.timestamp showDetail:YES];
                [_dataArray addObject:chatItem1];
            }
        }
        
        TKChatItem * chat = [[TKChatItem alloc]init];
        NSLog(@"%@",message);
        if ([message.from isEqualToString:[TKUserSetting sharedManager].username]) {
            chat.isSelf=YES;
            chat.content = message.text;
            
            if(message.deliveryState==NIMMessageDeliveryStateFailed){
                
                return;
            }
            
            if(message.messageType==1){
                NIMImageObject * imageob = (NIMImageObject *)message.messageObject;
                NSString * path = imageob.thumbPath;
                UIImage * image =  [UIImage imageWithContentsOfFile:path];
                if(image==nil){
                    path = imageob.thumbUrl;
                    image =  [UIImage imageWithContentsOfFile:path];
                }
                chat.image = image;
                chat.message = message;
                [_dataArray addObject:chat];
            }else if(message.messageType==3){
                //NIMImageObject * imageob = (NIMImageObject *)message.messageObject;
                NIMVideoObject * videoObject = (NIMVideoObject*)message.messageObject;
                UIImage * image              = [UIImage imageWithContentsOfFile:videoObject.coverPath];
                if(image==nil){
                    //path = imageob.thumbUrl;
                    image =  [UIImage imageWithContentsOfFile:videoObject.coverUrl];
                }
                chat.image         = image;
                chat.isVideo=YES;
                chat.videoUrl = videoObject.url;
                chat.message = message;
                NSLog(@"%@",message);
                if(message.deliveryState==NIMMessageDeliveryStateDelivering){
                    [_dataArray addObject:chat];
                }else{
                    //  NSLog(@"%@",videoObject.path);
                    [_dataArray addObject:chat];
                }
            }else if(message.messageType==0){
                // chat.content = [self notificationMessageContent:message];
                chat.message = message;
                [_dataArray addObject:chat];
            }else if(message.messageType==6){
                chat.message = message;
                chat.image = [UIImage imageNamed:@"文件1"];
                // chat.content = @"[发来文件]";
                [_dataArray addObject:chat];
            }else if(message.messageType==2){
                NIMAudioObject *audioObject = (NIMAudioObject*)message.messageObject;
                chat.message = message;
                chat.image = [UIImage imageNamed:@"语音123"];
                chat.content = [NSString stringWithFormat:@"%ld″",audioObject.duration/1000];
                // chat.content = @"[发来文件]";
                [_dataArray addObject:chat];
                
            }else if (message.messageType==NIMMessageTypeNotification){
                NIMNotificationObject *object = message.messageObject;
                if (object.notificationType == NIMNotificationTypeTeam) {
                    NSLog(@"%@",object.message);
                    chat.content = [TKChatInfoViewController teamNotificationFormatedMessage:message];
                    chat.isByself = YES;
                    [_dataArray addObject:chat];
                    if (object.notificationType == NIMNotificationTypeNetCall) {
                        
                        chat.content = [TKChatInfoViewController netcallNotificationFormatedMessage:message];
                        chat.isByself = self;
                        [_dataArray addObject:chat];
                        
                    }
                    
                }
                
                // chatItem.content = @"滚出群了";
            }else if(message.messageType==NIMMessageTypeCustom){
                NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
                
                if ([object.attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
                    //cell.infoLabel.text = @"[白板]";
                }else{
                    //  cell.infoLabel.text= @"[未知消息]";
                    NTESWhiteboardAttachment *attachment = (NTESWhiteboardAttachment *)object.attachment;
                    if(attachment.flag == 0){
                        chat.content = @"我发起了白板演示";
                    }else{
                        
                        chat.content = @"白板演示已结束";
                    }
                    
                }
                //NSLog(@"%@",attachment);
                [_dataArray addObject:chat];
            }else{
                ////  chat.content = @"[未知消息]";
                // [_dataArray addObject:chat];
            }
        }else{
            
            chat.isSelf=NO;
            chat.content = message.text;
            chat.sendName = message.senderName;
            if(message.messageType==1){
                NIMImageObject * imageob = (NIMImageObject *)message.messageObject;
                NSString * path = imageob.thumbPath;
                UIImage * image =  [UIImage imageWithContentsOfFile:path];
                if(image==nil){
                    path = imageob.thumbUrl;
                    image =  [UIImage imageWithContentsOfFile:path];
                }
                chat.image = image;
                chat.message = message;
                [_dataArray addObject:chat];
            }else if(message.messageType==3){
                //NIMImageObject * imageob = (NIMImageObject *)message.messageObject;
                NIMVideoObject * videoObject = (NIMVideoObject*)message.messageObject;
                UIImage * image              = [UIImage imageWithContentsOfFile:videoObject.coverPath];
                if(image==nil){
                    //path = imageob.thumbUrl;
                    image =  [UIImage imageWithContentsOfFile:videoObject.coverUrl];
                }
                chat.image         = image;
                chat.isVideo = YES;
                chat.videoUrl = videoObject.url;
                chat.message = message;
                [_dataArray addObject:chat];
                //  NSLog(@"%@",videoObject.path);
            }else if(message.messageType==0){
                NSLog(@"%@",message);
                chat.message = message;
                // chat.content = [self notificationMessageContent:message];
                [_dataArray addObject:chat];
            }else if(message.messageType==6){
                chat.message = message;
                chat.image = [UIImage imageNamed:@"文件1"];
                // chat.content = @"[发来文件]";
                [_dataArray addObject:chat];
            }else if(message.messageType==2){
                chat.message = message;
                NIMAudioObject *audioObject = (NIMAudioObject*)message.messageObject;
                chat.image = [UIImage imageNamed:@"icon_receiver_voice_playing"];
                chat.content = [NSString stringWithFormat:@"%ld″",audioObject.duration/1000];
                // chat.content = @"[发来文件]";
                [_dataArray addObject:chat];
                
            }else if (message.messageType==NIMMessageTypeNotification){
                NIMNotificationObject *object = message.messageObject;
                if (object.notificationType == NIMNotificationTypeTeam) {
                    NSLog(@"%@",object.message);
                    chat.content = [TKChatInfoViewController teamNotificationFormatedMessage:message];
                    chat.isByself = self;
                    [_dataArray addObject:chat];
                }
                if (object.notificationType == NIMNotificationTypeNetCall) {
                    
                    chat.content = [TKChatInfoViewController netcallNotificationFormatedMessage:message];
                    chat.isByself = self;
                    [_dataArray addObject:chat];
                    
                }
                // chatItem.content = @"滚出群了";
            }else if(message.messageType==NIMMessageTypeCustom){
                NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
                if ([object.attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
                    //cell.infoLabel.text = @"[白板]";
                }else{
                    //  cell.infoLabel.text= @"[未知消息]";
                    NTESWhiteboardAttachment *attachment = (NTESWhiteboardAttachment *)object.attachment;
                    if(attachment.flag == 0){
                        chat.content = @"我发起了白板演示";
                    }else{
                        
                        chat.content = @"白板演示已结束";
                    }
                    
                }
                [_dataArray addObject:chat];
            }else{
                
                
                
            }
            
        }
        
        //NSLog(@"%ld",_dataArray.count);
    }
    
    [self.tableView reloadData];
    
    
}

- (void)refresh:(NIMMessage *)message with:(NSInteger)number{
    //[self refresh:message];
    // NIMVideoObject * videoObject = (NIMVideoObject*)message.messageObject;
    // UIImage * image              = [UIImage imageWithContentsOfFile:videoObject.coverPath];
    //self.imageView.image         = image;
    if(dictionary[message.messageId]){
        NIMLoadProgressView * progressView = (NIMLoadProgressView *)[self.view viewWithTag:number];
        progressView.hidden  = (message.deliveryState != NIMMessageDeliveryStateDelivering);
        if (!progressView.hidden) {
            [progressView setProgress:[[[NIMSDK sharedSDK] chatManager] messageTransportProgress:message]];
            //[self refresh:message];
        }else{
            
            
        }
        
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


////视频被叫回调
//-(void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallType)type message:(NSString *)extendMessage{
//
//    NTESVideoChatViewController* vc = [[NTESVideoChatViewController alloc] initWithCaller:caller callId:callID];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.25;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromTop;
//    transition.delegate = self;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController pushViewController:vc animated:NO];
//
//
//}
#pragma mark -- 聊天详情导航栏
- (void)createNav{
    
    //好友
    UILabel * namelabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, screen_width-35-80, 20)];
    
    if(self.type==0){
        namelabel.text = _nameStr;
    }else if(self.type==1){
        namelabel.text = self.nameStr;
    }
    namelabel.font = [UIFont boldSystemFontOfSize:17];
    namelabel.textAlignment = NSTextAlignmentCenter;
    namelabel.textColor = [UIColor blackColor];
    self.navigationItem.titleView = namelabel;
    if(self.type==0){
        namelabel.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer * tapName = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [namelabel addGestureRecognizer:tapName];
    
    if(self.type ==1){
        //群成员
        UIButton * chengyuanbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        chengyuanbutton.frame = CGRectMake(screen_width-45, 30, 28, 28);
        [chengyuanbutton setImage:[UIImage imageNamed:@"team_info_icon"] forState:UIControlStateNormal];
        [chengyuanbutton addTarget:self action:@selector(group_chengyuan) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightOne = [[UIBarButtonItem alloc]initWithCustomView:chengyuanbutton];
        self.navigationItem.rightBarButtonItem = rightOne;
    }else{
        //视频
        UIButton * videobutton = [UIButton buttonWithType:UIButtonTypeCustom];
        videobutton.frame = CGRectMake(screen_width-50, 30,28, 28);
        [videobutton setBackgroundImage:[UIImage imageNamed:@"nav_btn_sp_icon"] forState:UIControlStateNormal];
        //[videobutton setBackgroundColor:[UIColor greenColor]];
        [videobutton addTarget:self action:@selector(videoButon) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightOne = [[UIBarButtonItem alloc]initWithCustomView:videobutton];
        
        //语音
        UIButton * yuyinbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        yuyinbutton.frame = CGRectMake(screen_width-90, 28,28, 28);
        [yuyinbutton setBackgroundImage:[UIImage imageNamed:@"nav_btn_iphone_icon"] forState:UIControlStateNormal];
        //[videobutton setBackgroundColor:[UIColor greenColor]];
        [yuyinbutton addTarget:self action:@selector(voidButon) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightTwo = [[UIBarButtonItem alloc]initWithCustomView:yuyinbutton];
        self.navigationItem.rightBarButtonItems = @[rightOne,rightTwo];
    }
    
}

-(void)tapAction{
    
    TKPersonInfoViewController * person = [[TKPersonInfoViewController alloc]init];
    person.userID = self.userID;
    [self.navigationController pushViewController:person animated:YES];
    
}

//语音
-(void)voidButon{
    
    NTESAudioChatViewController *vc = [[NTESAudioChatViewController alloc] initWithCallee:self.userID];
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
//TODO:-----群成员
- (void)group_chengyuan{
    
    TKGroupInfoViewController * group = [[TKGroupInfoViewController alloc] init];
    group.groupID = _userID;
    group.qunming = self.nameStr;
    group.isBumen = self.isBumen;
    [self.navigationController pushViewController:group animated:YES];
    
}

//上拉箭头
- (void)yuyinButon{
    
    //    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //    imagePicker.delegate = self;
    //    imagePicker.allowsEditing = YES;
    //    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
    
//    whiteVideoViewController * white = [[whiteVideoViewController alloc] init];
//    white.userID = self.userID;
//    white.delegate = self;
//    white.type = self.type;
//    //[self.navigationController pushViewController:white animated:YES];
//
//    [white showInViewController:self];
}
#pragma mark -发送文件代理
-(void)sendVideo:(NSArray *)arr with:(NSInteger)number{
    
    if(number==1){
        for(NSString * url in arr){
            [self sendVideoMessage:url];
            
        }
    }else if(number==2){
        for (TKDocumentModel * model in arr) {
            NIMMessage *message = [[NIMMessage alloc] init];
            message.text  = model.fname;
            NSDictionary * dictc = @{@"file":@"1",@"dowloadPath":model.filePath};
            message.remoteExt = dictc;
            //构造会话
            NIMSession *session = [NIMSession session:self.userID type:self.type];
            //发送消息
            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
        }
    }else if(number==3){
        
        for(UIImage * image in arr){
            [self sendImageMessage:image];
            
        }
    }
    
}

//TODO:视频聊天
-(void)videoButon{
    
    NTESVideoChatViewController *vc = [[NTESVideoChatViewController alloc] initWithCallee:self.userID];
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

//- (BOOL)checkCondition
//{
//    BOOL result = YES;
//
//    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
//        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
//        result = NO;
//    }
//    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
//    if ([currentAccount isEqualToString:self.session.sessionId]) {
//        [self.view makeToast:@"不能和自己通话哦" duration:2.0 position:CSToastPositionCenter];
//        result = NO;
//    }
//    return result;
//}

- (void)backButon{
    [_timer invalidate];
    _timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)createTable{
    
    self.view.backgroundColor = backcolor;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, screen_width, screen_height-tabbarViewheight-62)];
    self.tableView.backgroundColor = backcolor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //键盘通知
    //监听UIKeyboardWillShowNotification
    //调用self keyboardWillShow:
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //1.在开启下拉或者上拉前调用
    [self.tableView setup];
    
    //2.开启下拉刷新
    [self.tableView setPullDownEnable:YES];
    
    //3.开启上拉获取更多
    // [self.tableView setLoadMoreEnable:YES];
    
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
    //_isFresh = YES;
    _pageNum ++;
    [_dataArray removeAllObjects];
    [self history];
}

//键盘出现
-(void)keyboardWillShow:(NSNotification*)noti
{
    
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    //键盘的高度
    CGSize size=[[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    keyboardHeight = size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame=CGRectMake(0, 65, screen_width, screen_height-tabbarViewheight-62-size.height);
        //[self.tableView setContentOffset:CGPointMake(0, 200) animated:YES];
        if(_dataArray.count>1){
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        //tabbarView.frame=CGRectMake(0, screen_height-tabbarViewheight-size.height, screen_width, tabbarViewheight);
        tabbarView.y = screen_height-tabbarViewheight-size.height;
        _chatTimelabel.frame =CGRectMake(screen_width-50, screen_height-42, 36, 36);
    }];
}
//键盘消失
-(void)keyboardWillHide:(NSNotification*)noti
{
    keyboardHeight= 0;
    self.tableView.frame=CGRectMake(0, 65, screen_width, screen_height-tabbarViewheight-62);
    //tabbarView.frame=CGRectMake(0, screen_height-tabbarViewheight, screen_width, tabbarViewheight);
    tabbarView.y = screen_height-tabbarViewheight-5;
    _chatTimelabel.frame =CGRectMake(screen_width-50, screen_height-42, 36, 36);
}


#pragma mark -- 输入框
- (void)createTabbar{
    
    _audioRecordIndicator = [[NIMInputAudioRecordIndicatorView alloc] init];
    //[self.view addSubview:_audioRecordIndicator];
    //_audioRecordIndicator.recordTime = 60.f;
    
    
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(5,screen_height-tabbarViewheight-5, screen_width-10, tabbarViewheight)];
    tabbarView.backgroundColor = [UIColor whiteColor];
    [tabbarView setRoundView];
    
    [self.view addSubview:tabbarView];
    //左一
    //    UIButton * onebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    onebutton.frame = CGRectMake(7.5, 7.5, 35, 35);
    //    //[onebutton setBackgroundColor:[UIColor greenColor]];
    //    [onebutton setBackgroundImage:[UIImage imageNamed:@"input_icon"] forState:UIControlStateNormal];
    //    [onebutton addTarget:self action:@selector(yuyinButon) forControlEvents:UIControlEventTouchUpInside];
    //    [tabbarView addSubview:onebutton];
    //    _inputButton = onebutton;
    
    XYRecordButton * audioBT = [XYRecordButton buttonWithType:UIButtonTypeCustom];
    audioBT.frame = CGRectMake(tabbarView.width-tabbarViewheight, 0, tabbarViewheight, tabbarViewheight);
    audioBT.backgroundColor = [UIColor colorWithRed:215/255.0 green:51/255.0 blue:10/255.0 alpha:1];
    [audioBT setImage:[UIImage imageNamed:@"yy_icon"] forState:UIControlStateNormal];
    [audioBT setImage:[UIImage imageNamed:@"ly_icon"] forState:UIControlStateSelected];
    [audioBT setRoundView];
    audioBT.clipsToBounds = NO;
    
    
    //[audioBT addTarget:self action:@selector(audioButtonCheck:) forControlEvents:UIControlEventTouchUpInside];
    [audioBT setShadowRadius:5.0 opacity:10.0 offset:CGSizeMake(0, 0) color:[UIColor grayColor]];
    
    [audioBT addTarget:self action:@selector(onTouchRecordBtnDo:) forControlEvents:UIControlEventTouchDown];
    // [_anButton addTarget:self action:@selector(onTouchRecordBtnDragInsi:) forControlEvents:UIControlEventTouchDragInside];
    [audioBT addTarget:self action:@selector(onTouchRecordBtnDragOutsi:) forControlEvents:UIControlEventTouchDragOutside];
    [audioBT addTarget:self action:@selector(onTouchRecordBtnUpInsi:) forControlEvents:UIControlEventTouchUpInside];
    [audioBT addTarget:self action:@selector(onTouchRecordBtnUpOutsi:) forControlEvents:UIControlEventTouchUpOutside];
    
    
    _recordbuttonBG = [[UIControl alloc] initWithFrame:audioBT.frame];
    _recordbuttonBG.backgroundColor = [UIColor lightGrayColor];
    [_recordbuttonBG setRoundView];
    [tabbarView addSubview:_recordbuttonBG];
    
    
    
    
    _sockeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sockeButton.frame = _recordbutton.frame;
    [_sockeButton setBackgroundImage:[UIImage imageNamed:@"RecodeAudioLock"] forState:UIControlStateNormal];
    [_sockeButton setBackgroundImage:[UIImage imageNamed:@"RecodeAudioLockClosed"] forState:UIControlStateSelected];
    [_sockeButton setRoundView];
    [tabbarView addSubview:_sockeButton];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = _recordbutton.frame;
    [_closeButton setImage:[UIImage imageNamed:@"AudioCancelButtonTouchOff"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"AudioCancelButtonTouchOn"] forState:UIControlStateSelected];
    [_closeButton setRoundView];
    [_closeButton addTarget:self action:@selector(audioCloseCheck:) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:_closeButton];
    
    [tabbarView addSubview:audioBT];
    _recordbutton = audioBT;
    
    _audioSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _audioSendButton.frame = _recordbutton.frame;
    [_audioSendButton setImage:[UIImage imageNamed:@"AudioSendRecodeIcon"] forState:UIControlStateNormal];
    [_audioSendButton addTarget:self action:@selector(audioSendButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    _audioSendButton.backgroundColor = blcolor;
    [_audioSendButton setRoundView];
    _audioSendButton.hidden = YES;
    [tabbarView addSubview:_audioSendButton];
    
    float pp = 5.0;
    
    UIButton * morebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    morebutton.frame = CGRectMake(audioBT.x - 35 - pp, 7.5, 35, 35);
    //[onebutton setBackgroundColor:[UIColor greenColor]];
    morebutton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [morebutton setBackgroundImage:[UIImage imageNamed:@"sed_icon"] forState:UIControlStateNormal];
    [morebutton addTarget:self action:@selector(yuyinButon) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:morebutton];
    _keyButton = morebutton;
    _keyButton.hidden = YES;
    
    UIButton * videobutton = [UIButton buttonWithType:UIButtonTypeCustom];
    videobutton.frame = CGRectMake(morebutton.x-10, 7.5, 35, 35);
    //[onebutton setBackgroundColor:[UIColor greenColor]];
    //[videobutton setBackgroundImage:[UIImage imageNamed:@"bqb_icon"] forState:UIControlStateNormal];
    [videobutton setBackgroundImage:[UIImage imageNamed:@"tp_icon"] forState:UIControlStateNormal];
    videobutton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //[videobutton addTarget:self action:@selector(choosePhotoSelect:) forControlEvents:UIControlEventTouchUpInside];
    [videobutton addTarget:self action:@selector(yuyinButon) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:videobutton];
    _phoneButton = videobutton;
    

    //输入框
    _textView = [[YLYTextView alloc]initWithFrame:CGRectMake(7.5, 7.5, _phoneButton.x-pp-10, 32)];
    _textView.placeholder = @"输入消息";
    _textView.delegate = self;
    _textView.hidden = NO;
    
    _textView.returnKeyType = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:14.0];
    [tabbarView addSubview:_textView];
    
    
    _sliderView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, screen_width - 120 - K_SliderV_H, K_SliderV_H)];
    _sliderView.backgroundColor = _recordbuttonBG.backgroundColor;
    [_sliderView setRoundView];
    [tabbarView addSubview:_sliderView];
    [_sliderView setHidden:YES];
    
    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(_sliderView.width-60, 0, 60, K_SliderV_H)];
    timelabel.text = @"00:00";
    timelabel.textColor = [UIColor whiteColor];
    timelabel.font = [UIFont systemFontOfSize:12.00];
    timelabel.textAlignment = NSTextAlignmentCenter;
    timelabel.tag = 1101;
    [_sliderView addSubview:timelabel];
    
    
    _audioPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _audioPlayButton.frame = CGRectMake(1, 1, K_SliderV_H-2 ,K_SliderV_H-2);
    [_audioPlayButton setImage:[UIImage imageNamed:@"b_paly_icon"] forState:UIControlStateNormal];
    [_audioPlayButton setImage:[UIImage imageNamed:@"b_pause_icon"] forState:UIControlStateSelected];
    [_audioPlayButton addTarget:self action:@selector(audioPlayButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_audioPlayButton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [_audioPlayButton setBackgroundColor:[UIColor whiteColor]];
    [_audioPlayButton setRoundView];
    [_sliderView addSubview:_audioPlayButton];
    
    UIProgressView *pview = [[UIProgressView alloc] initWithFrame:CGRectMake(30, (K_SliderV_H-2)/2.0, timelabel.x - 10 - 25 ,2)];
    pview.tintColor = [UIColor whiteColor];
    pview.progress = 0.0;
    pview.tag = 1102;
    [_sliderView addSubview:pview];
    
    
    [tabbarView addSubview:_xianbutton];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(screen_width-50, 4, 36, 36);
    _sendButton.hidden = YES;
    [_sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.hidden = YES;
    [tabbarView addSubview:_sendButton];
    
    
    _sendMessagebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendMessagebutton setImage:[UIImage imageNamed:@"ly_icon_slices"] forState:UIControlStateNormal];
    [_sendMessagebutton setBackgroundColor:[UIColor redColor]];
    _sendMessagebutton.frame = _recordbuttonBG.frame;
    [_sendMessagebutton addTarget:self action:@selector(sendMessageButtonChick:) forControlEvents:UIControlEventTouchUpInside];
    [_sendMessagebutton setRoundView];
    [_sendMessagebutton setBorderWidth:2.0 borderColor:[UIColor whiteColor]];
    [tabbarView addSubview:_sendMessagebutton];
    _sendMessagebutton.hidden = YES;
}

-(void)sendMessageButtonChick:(UIButton*)sender{
    //文字为空不能发送消息
    if (_textView.text.length==0) {
        return;
    }
    [self sendTextMessage:_textView.text];
    _textView.height = 35;
    tabbarView.height = tabbarViewheight;
    tabbarView.y = screen_height - tabbarViewheight - 5 - keyboardHeight;
    _sendMessagebutton.hidden = YES;
    _recordbutton.hidden = NO;
}

-(void)chooseCameraSelect:(UIButton*)sender{
    
}
-(void)choosePhotoSelect:(UIButton*)sender{
//    LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//    //根据需求设置
//    imagePicker.allowTakePicture = NO; //不显示拍照按钮
//    imagePicker.doneBtnTitleStr = @"发送"; //最终确定按钮名称
//    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark -- 按住说话(new)
-(void)audioButtonCheck:(UIButton*)sender{
    
    [_textView resignFirstResponder];
    
    if (sender.selected != YES) {
        
        _inputButton.hidden = YES;
        _textView.hidden = YES;
        _phoneButton.hidden = YES;
        _cameraButton.hidden = YES;
        _keyButton.hidden = YES;
        
        tabbarView.backgroundColor = [UIColor clearColor];
        tabbarView.frame = CGRectMake(0, screen_height-120, screen_width, 120);
        [tabbarView setRoundViewByAngle:0];
        _recordbutton.frame = CGRectMake(screen_width - tabbarViewheight - 5, 120 - tabbarViewheight - 5, tabbarViewheight, tabbarViewheight);
        _recordbuttonBG.frame = _recordbutton.frame;
        self.sockeButton.frame = _recordbutton.frame;
        self.closeButton.frame = _recordbutton.frame;
        //_recordbuttonBG.frame = CGRectMake(screen_width, 120, 0, 0);
        //self.recordbuttonBG.frame = CGRectMake(screen_width-120, 0, 120*2, 120*2);
        [_recordbuttonBG setRoundView];
        
        _sliderView.frame = CGRectMake(10, tabbarView.height - 20 - 5, screen_width - 120 - 20, 20);
        
        
        
        [_sliderView setRoundView];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.recordbutton.selected = YES;
            self.recordbuttonBG.frame = CGRectMake(screen_width-120, 0, 120*2, 120*2);
            [self.recordbuttonBG setRoundView];
            self.sliderView.hidden = NO;
            
            float s = 40.0;
            self.sockeButton.frame = CGRectMake(screen_width - 10 - s, 10, s, s);
            
            self.closeButton.frame = CGRectMake(screen_width - 120 + 10, 120 - 10 - s, s, s);
            
        } completion:^(BOOL finished) {
            //[self.recordbuttonBG setRoundView];
            self.time = 0;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(audioProgressUpdate:) userInfo:nil repeats:YES];
            //将定时器假如主循环中
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            //开启定时器
            [self.timer setFireDate:[NSDate distantPast]];
            
            [self onTouchRecordBtnDo:nil];
        }];
        
    }else{
        [self dismissAudioButton];
        [self onTouchRecordBtnUpInsi:nil];
        
        //_sliderView.frame = CGRectMake(10, screen_height - 5, _recordbuttonBG.x - 20, 20);
    }
}

-(void)dismissAudioButton{
    
    self.recordbutton.delegate = nil;
    
    UILabel *label = (UILabel*)[_sliderView viewWithTag:1101];
    UIProgressView *pv = (UIProgressView*)[_sliderView viewWithTag:1102];
    label.text = @"0:00";
    pv.progress = 0.0;
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    //取消定时器
    [_timer invalidate];
    _timer = nil;
    
    
    
    _recordbutton.selected = NO;
    tabbarView.backgroundColor = [UIColor whiteColor];
    tabbarView.frame = CGRectMake(5, screen_height-tabbarViewheight-5, screen_width-10, tabbarViewheight);
    [tabbarView setRoundView];
    _recordbutton.frame = CGRectMake(tabbarView.width - tabbarViewheight, 0, tabbarViewheight, tabbarViewheight);
    _recordbuttonBG.frame = _recordbutton.frame;
    [_recordbuttonBG setRoundView];
    
    _inputButton.hidden = NO;
    _textView.hidden = NO;
    _phoneButton.hidden = NO;
    _cameraButton.hidden = NO;
    //    _keyButton.hidden = NO;
    
    _sliderView.hidden = YES;
    
    self.sockeButton.frame = _recordbutton.frame;
    self.closeButton.frame = _recordbutton.frame;
    
    _audioSendButton.hidden = YES;
    _sockeButton.selected = NO;
    _closeButton.selected = NO;
    
}

-(void)audioPlayButtonSelect:(UIButton*)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        [[NIMSDK sharedSDK].mediaManager play:audioPath];
    }else{
        sender.selected = NO;
        [[NIMSDK sharedSDK].mediaManager stopPlay];
    }
}
-(void)audioSendButtonSelect:(UIButton*)sender{
    [self dismissAudioButton];
    
    _audioSendButton.hidden = YES;
    _sockeButton.selected = NO;
    _closeButton.selected = NO;
    
    if([self recordFileCanBeSend:audioPath]){
        NSLog(@"%@",audioPath);
        //构造消息
        NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:audioPath];
        NIMMessage *message        = [[NIMMessage alloc] init];
        message.messageObject      = audioObject;
        //构造会话
        NIMSession *session = [NIMSession session:self.userID type:self.type];
        
        //发送消息
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    }
}
-(void)audioCloseCheck:(UIButton*)sender{
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    //取消定时器
    [_timer invalidate];
    _timer = nil;
    
    [self setRecording:NO];
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
    [self dismissAudioButton];
}
-(void)audioProgressUpdate:(NSTimer*)sender{
    UILabel *label = (UILabel*)[_sliderView viewWithTag:1101];
    UIProgressView *pv = (UIProgressView*)[_sliderView viewWithTag:1102];
    if (300 > _time) {
        label.text = [NSString stringWithFormat:@"%.2ld:%.2ld",_time/60,_time%60];
        _time ++;
        float p = _time/300.0;
        pv.progress = p;
        
    } else {
        _time=300;
        label.text = @"5:00";
        pv.progress = 1.0;
        //关闭定时器
        [_timer setFireDate:[NSDate distantFuture]];
        //取消定时器
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark -- 按住说话
-(void)onTouchRecordBtnDo:(UIButton*)sender {
    //self.recording = YES;
    //[self audioButtonCheck:sender];
    XYLog(@"---------begin 01 --------");
    //    [self setRecording:YES];
    //    _audioRecordIndicator.phase = AudioRecordPhaseRecording;
    //    [[NIMSDK sharedSDK].mediaManager recordForDuration:60.f*5];
    //
    
    
    [_textView resignFirstResponder];
    
    if (sender.selected != YES) {
        self.time = 0;
        _inputButton.hidden = YES;
        _textView.hidden = YES;
        _phoneButton.hidden = YES;
        _cameraButton.hidden = YES;
        _keyButton.hidden = YES;
        
        tabbarView.backgroundColor = [UIColor clearColor];
        tabbarView.frame = CGRectMake(0, screen_height-120, screen_width, 120);
        [tabbarView setRoundViewByAngle:0];
        _recordbutton.frame = CGRectMake(screen_width - tabbarViewheight - 5, 120 - tabbarViewheight - 5, tabbarViewheight, tabbarViewheight);
        _recordbuttonBG.frame = _recordbutton.frame;
        self.sockeButton.frame = _recordbutton.frame;
        self.closeButton.frame = _recordbutton.frame;
        //_recordbuttonBG.frame = CGRectMake(screen_width, 120, 0, 0);
        //self.recordbuttonBG.frame = CGRectMake(screen_width-120, 0, 120*2, 120*2);
        [_recordbuttonBG setRoundView];
        
        _sliderView.frame = CGRectMake(10, tabbarView.height - K_SliderV_H - 5, screen_width - 120 - K_SliderV_H, K_SliderV_H);
        
        
        
        [_sliderView setRoundView];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            //self.recordbutton.selected = YES;
            self.recordbuttonBG.frame = CGRectMake(screen_width-120, 0, 120*2, 120*2);
            [self.recordbuttonBG setRoundView];
            self.sliderView.hidden = NO;
            
            float s = 40.0;
            self.sockeButton.frame = CGRectMake(screen_width - 10 - s, 10, s, s);
            
            self.closeButton.frame = CGRectMake(screen_width - 120 + 10, 120 - 10 - s, s, s);
            
        } completion:^(BOOL finished) {
            //[self.recordbuttonBG setRoundView];
            self.time = 0;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(audioProgressUpdate:) userInfo:nil repeats:YES];
            //将定时器假如主循环中
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            //开启定时器
            [self.timer setFireDate:[NSDate distantPast]];
            
            //[self setRecording:YES];
            self.audioRecordIndicator.phase = AudioRecordPhaseRecording;
            [[NIMSDK sharedSDK].mediaManager recordForDuration:60.f*5];
            self.recordbutton.delegate = self;
        }];
        
    }
}
- (void)onTouchRecordBtnUpInsi:(id)sender {
    // finish Recording
    // self.recording = NO;
    
    XYLog(@"---------begin 02 -------- %zd",_time);
    if(_recordbutton.selected == YES){
        _audioSendButton.frame = _recordbutton.frame;
        _audioSendButton.hidden = NO;
        //关闭定时器
        [_timer setFireDate:[NSDate distantFuture]];
        //取消定时器
        [_timer invalidate];
        _timer = nil;
        //        [self setRecording:NO];
        [[NIMSDK sharedSDK].mediaManager stopRecord];
        return;
    }
    if (_sockeButton.selected == YES) {
        _recordbutton.selected = YES;
        return;
    }
    if (_closeButton.selected == YES) {
        _closeButton.selected = NO;
        [[NIMSDK sharedSDK].mediaManager cancelRecord];
        [self dismissAudioButton];
        return;
    }
    
    //[self setRecording:NO];
    if (_time==0) {
        
        XYLog(@"时间过短 取消录音");
        [[NIMSDK sharedSDK].mediaManager cancelRecord];
        [self dismissAudioButton];
        return;
    }
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [self dismissAudioButton];
}
- (void)onTouchRecordBtnUpOutsi:(id)sender {
    //TODO cancel Recording
    // self.recording = NO;
    
    XYLog(@"---------begin 03 --------");
    if (_closeButton.selected == YES) {
        _closeButton.selected = NO;
        [[NIMSDK sharedSDK].mediaManager cancelRecord];
        [self dismissAudioButton];
        return;
    }else{
        _sockeButton.selected = YES;
        _recordbutton.selected = YES;
        return;
    }
}

- (void)onTouchRecordBtnDragInsi:(id)sender {
    //TODO @"手指上滑，取消发送"
    // self.recording = NO;
    
    XYLog(@"---------begin 04 --------");
    //    [self setRecording:NO];
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}
- (void)onTouchRecordBtnDragOutsi:(id)sender {
    //TODO @"松开手指，取消发送"
    //self.recording = NO;
    
    XYLog(@"---------begin 05 --------");
    //    [self setRecording:NO];
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}
#pragma mark XYRdelegate
-(void)recordButton:(UIButton *)sender touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point=[touch locationInView:sender.superview];
    XYLog(@"---<><><>>>>>>>> %.@",NSStringFromCGPoint(point));
    
    CGRect r1 = [self.sockeButton.superview convertRect:self.sockeButton.frame fromView:self.sockeButton.superview];
    CGRect r2 = [self.closeButton.superview convertRect:self.closeButton.frame fromView:self.sockeButton.superview];
    XYLog(@"->>%@",NSStringFromCGRect(r1));
    XYLog(@"->>%@",NSStringFromCGRect(r2));
    BOOL ishave1 = CGRectContainsPoint(r1, point);
    if (ishave1 == YES && self.sockeButton.selected == NO) {
        self.sockeButton.selected = YES;
        self.closeButton.selected = NO;
    }
    BOOL ishave2 = CGRectContainsPoint(r2, point);
    if (ishave2 == YES && self.closeButton.selected == NO) {
        self.closeButton.selected = YES;
        self.sockeButton.selected = NO;
    }
}
- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error{
    audioPath = filePath;
    
    if(![[NIMSDK sharedSDK].mediaManager isRecording]){
        [self setRecording:NO];
        //[[NIMSDK sharedSDK].mediaManager stopRecord];
    }
    if (_audioSendButton.hidden == NO) {
        return;
    }
    if([self recordFileCanBeSend:filePath]){
        NSLog(@"%@",filePath);
        //构造消息
        NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
        NIMMessage *message        = [[NIMMessage alloc] init];
        message.messageObject      = audioObject;
        //构造会话
        NIMSession *session = [NIMSession session:self.userID type:self.type];
        
        //发送消息
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    }
    
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    if(filepath==nil){
        return NO;
    }
    NSURL    *movieURL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:movieURL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}


- (void)recordAudioDidCancelled{
    NSLog(@"取消录音");
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_textView resignFirstResponder];
    
}
- (void)setRecording:(BOOL)recording {
    if(recording) {
        self.audioRecordIndicator.center = self.view.superview.center;
        self.audioRecordIndicator.recordTime = 0;
        [self.view.superview addSubview:self.audioRecordIndicator];
        // self.recordPhase = AudioRecordPhaseRecording;
    } else {
        [self.audioRecordIndicator removeFromSuperview];
        // self.recordPhase = AudioRecordPhaseEnd;
    }
    _recording = recording;
}
-(void)sendTextMessage:(NSString*)text{
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text = text;
    //构造会话
    NIMSession  *session = [NIMSession session:_userID type:self.type];
    XYLog(@"%@,------------> %ld",_userID,self.type);
    
    //发送消息
    NSError *error;
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
    if (error==nil) {
        XYLog(@"发送成功");
    }else{
        XYLog(@"发送失败");
        XYLog(@"%@",error.description);
    }

}
-(void)sendImageMessage:(UIImage*)image{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSLog(@"%@",image);
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
    imageObject.displayName = [NSString stringWithFormat:@"图片发送于%@",dateString];
    NIMImageOption *option = [[NIMImageOption alloc] init];
    option.compressQuality = 0.9;
    NIMMessage *message          = [[NIMMessage alloc] init];
    message.messageObject        = imageObject;
    
    //构造会话
    NIMSession *session = [NIMSession session:_userID type:self.type];
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    
    TKChatItem *chatItem=[[TKChatItem alloc]init];
    chatItem.isSelf=YES;
    chatItem.image=image;
    chatItem.message = message;
    _textView.text=@"";
    [_dataArray addObject:chatItem];
    //indexPath 找到最后一行
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
    //添加新的一行
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//动画参数
    //滑动到底部
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)sendVideoMessage:(NSString*)url{
    if ([url isKindOfClass:[NSURL class]]) {
        NSURL *aurl = (NSURL*)url;
        NSString *s = aurl.absoluteString;
        url = [s stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    }
    NIMVideoObject *videoObject = [[NIMVideoObject alloc] initWithSourcePath:url];
    NIMMessage *message         = [[NIMMessage alloc] init];
    message.messageObject       = videoObject;
    NIMSession *session;
    if(self.type == 0){
        session= [NIMSession session:_userID type:NIMSessionTypeP2P];
    }else{
        
        session = [NIMSession session:_userID type:NIMSessionTypeTeam];
        
    }
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}
#pragma makr TZImagePickerControllerDelegate
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    if (photos && photos.count>0) {
        for (UIImage *img in photos) {
            [self sendImageMessage:img];
        }
    }
}

#pragma mark textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        //文字为空不能发送消息
        if (_textView.text.length==0) {
            return NO;
        }
        [self sendTextMessage:textView.text];
        textView.height = 35;
        tabbarView.height = tabbarViewheight;
        tabbarView.y = screen_height - tabbarViewheight - 5 - keyboardHeight;
        _sendMessagebutton.hidden = YES;
        _recordbutton.hidden = NO;
        return NO;
    }else if (text.length == 0){
        //判断删除的文字是否符合表情文字规则
        NSString *deleteText = [textView.text substringWithRange:range];
        if ([deleteText isEqualToString:@"]"]) {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            NSString *subText;
            while (YES) {
                if (location == 0) {
                    return YES;
                }
                location -- ;
                length ++ ;
                subText = [textView.text substringWithRange:NSMakeRange(location, length)];
                if (([subText hasPrefix:@"["] && [subText hasSuffix:@"]"])) {
                    break;
                }
            }
            textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
            [textView setSelectedRange:NSMakeRange(location, 0)];
            [self textViewDidChange:self.textView];
            return NO;
        }
    }else{
        
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    
    CGRect textViewFrame = self.textView.frame;
    
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    
    CGFloat offset = 10;
    textView.scrollEnabled = (textSize.height + 0.1 > kMaxHeight-offset);
    textViewFrame.size.height = MAX(34, MIN(kMaxHeight, textSize.height));
    textView.height = textViewFrame.size.height;
    
    float h = textViewFrame.size.height+offset;
    if (h>tabbarViewheight) {
        tabbarView.height = h;
        tabbarView.y = screen_height - tabbarView.height - 5 - keyboardHeight;
    }else{
        tabbarView.height = tabbarViewheight;
        tabbarView.y = screen_height - tabbarViewheight - 5 - keyboardHeight;
    }
    
    
    if (textView.scrollEnabled) {
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 2, 1)];
    }
    if (_textView.text.length>0) {
        _sendMessagebutton.hidden = NO;
        _recordbutton.hidden = YES;
    }else{
        _sendMessagebutton.hidden = YES;
        _recordbutton.hidden = NO;
    }
}

#pragma mark textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _chatTimelabel.hidden = YES;
    _xianbutton.hidden = YES;
    _sendButton.hidden = NO;
    if(_isZT==YES){
        [_sendButton setImage:[UIImage imageNamed:@"发送2"] forState:UIControlStateNormal];
    }else{
        
        [_sendButton setImage:[UIImage imageNamed:@"发送3"] forState:UIControlStateNormal];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _sendButton.hidden = YES;
    if(_isFree==NO){
        _chatTimelabel.hidden = NO;
        _xianbutton.hidden = YES;
    }else{
        _chatTimelabel.hidden = YES;
        _xianbutton.hidden = NO;
    }
}

-(void)sendClick{
    
    if (_textView == self.textView) {
        [_textView resignFirstResponder];
    }
    
    if(_textView.text.length==0){
        return ;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text = _textView.text;
    // message.apnsContent = @"发来了一个文件";
    //构造会话
    NIMSession *session = [NIMSession session:_userID type:self.type];
    NSLog(@"%@",_userID);
    //  NSLog(@"%ld",self.type);
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField == self.textView) {
        [textField resignFirstResponder];
    }
    
    if(_textView.text.length==0){
        return  YES;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text = _textView.text;
    //构造会话
    NIMSession *session = [NIMSession session:_userID type:self.type];
    NSLog(@"%@,99999999%ld",_userID,self.type);
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    
    return YES;
    
}
- (void)tapClick{
    _isFree = YES;
    _chatTimelabel.hidden = YES;
    _xianbutton.hidden = NO;
    _isZT = NO;
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
    
    
}

- (void)xianButon{
    _isFree = NO;
    _chatTimelabel.hidden = NO;
    _xianbutton.hidden = YES;
    _isZT = YES;
    [_timer setFireDate:[NSDate distantPast]];
    //}
}

- (void)timeChange{
    
    if (0 < _time) {
        
        _chatTimelabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld",_time/60,_time%60];
        _time --;
        
    } else {
        _time=300;
        [self tapClick];
    }
    
    
    
}
//发送语音
- (void)picButon{
    
    _anButton.hidden = !_anButton.hidden;
    _textView.hidden = !_textView.hidden;
    _recordbutton.selected = !_recordbutton.selected;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TKChatItem*chatItem=[_dataArray objectAtIndex:indexPath.row];
    NSDictionary * diiiic = chatItem.message.remoteExt;
    TKContactModel * model = [[TKContactModel alloc]init];
    [model setValuesForKeysWithDictionary:diiiic];
    CGSize size;
    if(chatItem.isByself==YES){
        //size = [chatItem.content boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]} context:nil].size;
        return 30;
    }else{
        float ww = 250;
        if (screen_width <= 320) {
            ww = 200;
        }
        size = [chatItem.content boundingRectWithSize:CGSizeMake(ww, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]} context:nil].size;
    }
    if(chatItem.image){
        if(chatItem.message.messageType == NIMMessageTypeAudio){
            return 40+20;
        }
        if(chatItem.message.messageType == NIMMessageTypeImage){
            float w = 200;
            float h = w*(chatItem.image.size.height/chatItem.image.size.width)+20;
            return h+5;
        }
        return 85+5;
    }else{
        if(size.height<40){
            size.height = 40;
        }
        if (model.file.integerValue==1||model.document.integerValue==1) {
            return 90+5;
        }else{
            return size.height+20;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TKChatMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    TKChatItem* chatItem = [_dataArray objectAtIndex:indexPath.row];
    if(chatItem.isByself ==YES){
        UITableViewCell * cellid = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cellid.selectionStyle = UITableViewCellSelectionStyleNone;
        cellid.textLabel.numberOfLines=0;
        cellid.textLabel.font = [UIFont systemFontOfSize:12];
        cellid.textLabel.textAlignment = NSTextAlignmentCenter;
        cellid.textLabel.text = chatItem.content;
        cellid.textLabel.textColor = [UIColor grayColor];
        cellid.backgroundColor = [UIColor clearColor];
        return cellid;
        
    }else{
        if (cell == nil) {
            cell = [[TKChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = backcolor;
        [cell.rheadimage tk_setImageWithURL:[TKUserSetting sharedManager].userImg placeholderImage:[UIImage imageNamed:@"chat_d_img"]];
        NSString * headUrl = [[[NIMSDK sharedSDK]userManager]userInfo:self.userID].userInfo.avatarUrl;
        [cell.lheadimage  tk_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"chat_d_img"]];
        float ww = 250;
        if (screen_width <= 320) {
            ww = 200;
        }
        CGSize size = [chatItem.content boundingRectWithSize:CGSizeMake(ww, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]} context:nil].size;
        if (size.height < 40) {
            size.height = 40;
        }
        //如果是自己发得
        //如果是自己发得
        if (chatItem.isSelf) {
            
            cell.leftView.hidden = YES;
            cell.rightView.hidden = NO;
            NSDictionary * diiiic = chatItem.message.remoteExt;
            TKContactModel * model = [[TKContactModel alloc]init];
            [model setValuesForKeysWithDictionary:diiiic];
            if(chatItem.image){
                cell.rightView.frame = CGRectMake(screen_width - 40 - 95, 5, 95, 70);
                UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 80, 60)];
                imagev.image = chatItem.image;
                if(chatItem.isVideo==YES){
                    UIImageView * imagevideo = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 30, 30)];
                    imagevideo.image = [UIImage imageNamed:@"播放按钮"];
                    [imagev addSubview:imagevideo];
                    NIMLoadProgressView *  progressView = [[NIMLoadProgressView alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
                    progressView.maxProgress = 1.0;
                    progressView.tag = indexPath.row+10000;
                    //progressView.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:0.5];
                    [imagev addSubview:progressView];
                    NSString * ssss = [NSString stringWithFormat:@"%ld",indexPath.row+10000];
                    // NSString * sssss = [NSString stringWithFormat:@"%@",chatItem.message.messageId];
                    [dictionary setObject:ssss forKey:chatItem.message.messageId];
                    [self refresh:chatItem.message with:indexPath.row+10000];
                }
                if(chatItem.message.messageType==NIMMessageTypeImage){
                    float w = 200;
                    float h = w*(chatItem.image.size.height/chatItem.image.size.width);
                    cell.rightView.frame = CGRectMake(screen_width - 40 - w, 12, w, h);
                    imagev.width = cell.rightView.width;// - 10;
                    imagev.height = cell.rightView.height;// - 10;
                    //TODO:FIX
                    imagev.frame = cell.rightView.bounds;
                }
                if(chatItem.message.messageType==2){
                    cell.rightView.frame = CGRectMake(screen_width - 40 - 80, 5, 80, 40);
                    imagev = [[UIImageView alloc]initWithFrame:CGRectMake(45, 4, 30, 30)];
                    imagev.image = chatItem.image;
                    NSArray * animateNames = @[@"icon_receiver_voice_playing_001.png",@"icon_receiver_voice_playing_002.png",@"icon_receiver_voice_playing_003.png"];
                    NSMutableArray * animationImages = [[NSMutableArray alloc] initWithCapacity:animateNames.count];
                    for (NSString * animateName in animateNames) {
                        UIImage * animateImage = [UIImage imageNamed:animateName];
                        [animationImages addObject:animateImage];
                    }
                    imagev.animationImages = animationImages;
                    imagev.animationDuration = 1.0;
                    imagev.tag = indexPath.row+600;
                    //    [self addSubview:imagev];
                }else if(chatItem.message.messageType==6){
                    NIMFileObject * imageob = (NIMFileObject *)chatItem.message.messageObject;
                    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 80, 15)];
                    label.textColor = [UIColor grayColor];
                    label.font = [UIFont systemFontOfSize:12];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text =  imageob.displayName;
                    [imagev addSubview:label];
                }
                [cell.rightView addSubview:imagev];
            }else{
                float w = size.width + 25;
                float h = size.height + 13;
                if (size.height <= 40) {
                    h = 40;
                }
                cell.rightView.frame = CGRectMake(screen_width - 40 - w, 5, w, h);
                
            }
            //cell.rightView.image = chatItem.image;
            cell.lheadimage.hidden = YES;
            cell.rightLabel.frame = CGRectMake(10, 5, size.width, size.height);
            if([model.document isEqualToString:@"1"]){
                cell.rightView.frame = CGRectMake(screen_width - 40 - 180, 5, 180, 70);
                UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
                imagev.image = [UIImage imageNamed:@"组 1"];
                [cell.rightView addSubview:imagev];
                // NSLog(@"%@",model.time);
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(67, 5, 115, 20)];
                label.text = chatItem.message.text;
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor whiteColor];
                [cell.rightView addSubview:label];
                
                UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(67, 20, 115, 40)];
                label1.text = model.time;
                label1.numberOfLines = 0;
                label1.font = [UIFont systemFontOfSize:12];
                label1.textColor = [UIColor whiteColor];
                [cell.rightView addSubview:label1];
                //--------------------------------------------自己发的文件-----------------------------------------------
            }else if([model.file isEqualToString:@"1"]){
                cell.rightView.frame = CGRectMake(screen_width - 40 - 180, 5, 180, 70);
                UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
                imagev.image = [UIImage imageNamed:@"组 2"];
                [cell.rightView addSubview:imagev];
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(67, 5, 110, 60)];
                label.text = chatItem.message.text;
                label.numberOfLines = 0;
                label.font = [UIFont boldSystemFontOfSize:13];
                label.textColor = [UIColor whiteColor];
                [cell.rightView addSubview:label];
                
                //            UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(67, 20, 115, 30)];
                //            label1.text = model.dowloadPath;
                //            label1.numberOfLines = 0;
                //            label1.font = [UIFont systemFontOfSize:12];
                //            label1.textColor = [UIColor blackColor];
                //            [cell.rightView addSubview:label1];
                
            }else{
                cell.rightLabel.text = chatItem.content;
            }
            
            
        } else {
            if(self.type==1){
                cell.nameLabel.text =chatItem.sendName;
            }
            //接收到得
            cell.leftView.hidden = NO;
            cell.rightView.hidden = YES;
            cell.rheadimage.hidden=YES;
            NSDictionary * diiiic = chatItem.message.remoteExt;
            TKContactModel * model = [[TKContactModel alloc]init];
            [model setValuesForKeysWithDictionary:diiiic];
            // cell.lheadimage.hidden = NO;
            if(chatItem.image){
                cell.leftView.frame = CGRectMake(40, 12, 90, 70);
                UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 80, 60)];
                imagev.image = chatItem.image;
                if(chatItem.isVideo==YES){
                    UIImageView * imagevideo = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 30, 30)];
                    imagevideo.image = [UIImage imageNamed:@"播放按钮"];
                    [imagev addSubview:imagevideo];
                }
                if(chatItem.message.messageType==NIMMessageTypeImage){
                    float w = 200;
                    float h = w*(chatItem.image.size.height/chatItem.image.size.width);
                    cell.leftView.frame = CGRectMake(40, 12, w, h);
                    imagev.width = cell.leftView.width - 10;
                    imagev.height = cell.leftView.height - 10;
                    imagev.frame = cell.leftView.bounds;
                }
                if(chatItem.message.messageType==2){
                    cell.leftView.frame = CGRectMake(40, 12, 80, 40);
                    imagev = [[UIImageView alloc]initWithFrame:CGRectMake(45, 4, 30, 30)];
                    imagev.image = chatItem.image;
                    NSArray * animateNames = @[@"icon_receiver_voice_playing_001.png",@"icon_receiver_voice_playing_002.png",@"icon_receiver_voice_playing_003.png"];
                    NSMutableArray * animationImages = [[NSMutableArray alloc] initWithCapacity:animateNames.count];
                    for (NSString * animateName in animateNames) {
                        UIImage * animateImage = [UIImage imageNamed:animateName];
                        [animationImages addObject:animateImage];
                    }
                    imagev.animationImages = animationImages;
                    imagev.animationDuration = 1.0;
                    imagev.tag = indexPath.row+600;
                    
                }else if(chatItem.message.messageType==6){
                    NIMFileObject * imageob = (NIMFileObject *)chatItem.message.messageObject;
                    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 80, 15)];
                    label.textColor = [UIColor grayColor];
                    label.font = [UIFont systemFontOfSize:12];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text =  imageob.displayName;
                    [imagev addSubview:label];
                }
                
                [cell.leftView addSubview:imagev];
            }else{
                float w = size.width + 25;
                float h = size.height + 13;
                if (size.height <= 40) {
                    h = 40;
                }
                cell.leftView.frame=CGRectMake(40, 12, w, h);
                
            }
            
            cell.leftLabel.frame=CGRectMake(15, 5, size.width, size.height);
            
            if([model.document isEqualToString:@"1"]){
                cell.leftView.frame = CGRectMake(40, 10, 180, 70);
                UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 60, 60)];
                imagev.image = [UIImage imageNamed:@"url链接"];;
                [cell.leftView addSubview:imagev];
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 115, 20)];
                label.text = chatItem.message.text;
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor blackColor];
                [cell.leftView addSubview:label];
                
                UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, 115, 40)];
                label1.text = model.time;
                label1.numberOfLines = 0;
                label1.font = [UIFont systemFontOfSize:12];
                label1.textColor = [UIColor blackColor];
                [cell.leftView addSubview:label1];
                
            }else if([model.file isEqualToString:@"1"]){
                cell.leftView.frame = CGRectMake(40, 10, 180, 70);
                UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 60, 60)];
                imagev.image = [UIImage imageNamed:@"大文件"];
                [cell.leftView addSubview:imagev];
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 110, 60)];
                label.text = chatItem.message.text;
                label.numberOfLines = 0;
                label.font = [UIFont boldSystemFontOfSize:13];
                label.textColor = [UIColor blackColor];
                [cell.leftView addSubview:label];
                
            }else{
                cell.leftLabel.text = chatItem.content;
            }
            
        }
        [cell updateLayout];
        return cell;
        
    }
}

#pragma mark --------------------------------------------模拟云信语音动画播放---------------






#pragma mark - NIMMediaManagerDelgate

- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
    
    if (_audioSendButton.hidden == NO) {
        
        return;
    }
    if(audioTap){
        
    }
}

- (void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    [self stopPlayingUI];
}

#pragma mark - private methods
- (void)stopPlayingUI
{
    if (_audioSendButton.hidden == NO) {
        return;
    }
    UIImageView * imageview = (UIImageView *)[self.view viewWithTag:audioTap];
    
    [imageview stopAnimating];
}




- (UIImage *)nim_imageInKit:(NSString *)imageName{
    //FIX:---
    NSString *name = [[[NIMKit sharedKit] resourceBundleName] stringByAppendingPathComponent:imageName];
    return [UIImage imageNamed:name];
}



#pragma mark - 点击聊天跳转

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TKChatItem*chatItem=[_dataArray objectAtIndex:indexPath.row];
    // ChatCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if(chatItem.message.messageType == 6){
        // NIMFileObject *object = chatItem.message.messageObject;
        NTESFilePreViewController *vc = [[NTESFilePreViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(chatItem.message.messageType==2){
        if ([chatItem.message attachmentDownloadState] == NIMMessageAttachmentDownloadStateDownloaded) {
            if (![[NIMSDK sharedSDK].mediaManager isPlaying]) {
                [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
                NIMAudioObject *audioObject = (NIMAudioObject*)chatItem.message.messageObject;
                BOOL needProximityMonitor = YES;
                [[NIMSDK sharedSDK].mediaManager setNeedProximityMonitor:needProximityMonitor];
                [[NIMSDK sharedSDK].mediaManager play:audioObject.path];
                //  cell.backgroundColor = [UIColor lightGrayColor];
                audioTap = 600+indexPath.row;
                UIImageView * imageview = (UIImageView *)[self.view viewWithTag:audioTap];
                [imageview startAnimating];
            } else {
                [[NIMSDK sharedSDK].mediaManager stopPlay];
                //cell.backgroundColor = backcolor;
                // [self stopPlayingUI];
            }
        }
        
    }else if(chatItem.message.messageType==0){
        NSDictionary * diiiic = chatItem.message.remoteExt;
        TKContactModel * model = [[TKContactModel alloc]init];
        [model setValuesForKeysWithDictionary:diiiic];
        
        //        if(chatItem.content.length>4){
        //            NSString * str = [chatItem.content substringToIndex:2];
        //        if([str isEqualToString:@"ht"]){
        //         // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:chatItem.content]];
        //            urleditViewController * urle = [[urleditViewController alloc]init];
        //            urle.nameTitle = @"文档";
        //            urle.url = chatItem.content;
        //            urle.isYes = YES;
        //            [self.navigationController pushViewController:urle animated:YES];
        //        }
        
        // }
        if([model.document isEqualToString:@"1"]){
            
            TKUrlEditViewController * urle = [[TKUrlEditViewController alloc]init];
            urle.nameTitle = @"文档";
            urle.url = model.title;
            urle.isYes = YES;
            [self.navigationController pushViewController:urle animated:YES];
            
        }
        if (model.file.integerValue==1) {
            
            NIMFileObject *object = chatItem.message.messageObject;
            NTESFilePreViewController *vc = [[NTESFilePreViewController alloc] initWithFileObject:object];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        
    }else{
        if(chatItem.image){
            if(chatItem.isVideo==YES){
                
                //            _mpVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:chatItem.videoUrl]];
                //
                //            //跳转播放页面
                //            [self presentMoviePlayerViewControllerAnimated:_mpVC];
                //
                //            //跳转界面后立刻播放
                //            [_mpVC.moviePlayer play];
                [self showVideo:chatItem.message];
                
            }else{
                
                NIMImageObject *object = (NIMImageObject *)chatItem.message.messageObject;
                NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
                item.thumbPath      = [object thumbPath];
                item.imageURL       = [object url];
                item.name           = [object displayName];
                NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item session:_session];
                [self.navigationController pushViewController:vc animated:YES];
                if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
                    //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
                    //  __weak typeof(self) wself = self;
                    [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
                        if (!error) {
                            //   [wself uiUpdateMessage:message];
                        }
                    }];
                }
                
                
                //            NIMImageObject * imageob = (NIMImageObject *)chatItem.message.messageObject;
                //            NSString * path = imageob.url;
                //            NSLog(@"%@",path);
                //            imageob.option.compressQuality = 1.0;
                //            UIImage * result;
                //            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
                //            result = [UIImage imageWithData:data];
                //            // UIImage * image =  [UIImage ];
                //            _picima = result;
                //            NSLog(@"%@",result);
                //            if (_picima) {
                //            self.browserController = [[ZZBrowserPickerViewController alloc]init];
                //            self.browserController.delegate = self;
                //           [self.browserController reloadData];
                //           [self.browserController showIn:self animation:ShowAnimationOfPresent];
                //            }else{
                //
                //                [self.view makeToast:@"图片下载失败" duration:1 position:CSToastPositionCenter];
                //
                //            }
            }
        }else{
            
        }
        
    }
    
}

- (void)showVideo:(NIMMessage *)message
{
    NIMVideoObject *object = message.messageObject;
    NTESVideoViewItem *item = [[NTESVideoViewItem alloc] init];
    item.path = [object path];
    item.url  = [object url];
    //item.itemId  = [object o];
    NTESVideoViewController *playerViewController = [[NTESVideoViewController alloc] initWithVideoViewItem:item];
    [self.navigationController pushViewController:playerViewController animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.coverPath]){
        //如果封面图下跪了，点进视频的时候再去下一把封面图
        //__weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.coverUrl filepath:object.coverPath progress:nil completion:^(NSError *error) {
            if (!error) {
                //  [wself uiUpdateMessage:message];
            }
        }];
    }
}


#pragma mark - 发送消息成功回调
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    NSLog(@"%@",message);
    
    NSLog(@"发送状态%@",error);
    if(error!=nil){
        TKChatItem *chatItem=[[TKChatItem alloc]init];
        chatItem.isByself=YES;
        NSString * str = nil;
        if(message.messageType== NIMMessageTypeImage){
            str = @"[图片]";
        }else if(message.messageType == NIMMessageTypeVideo){
            str = @"[视频]";
        }else if(message.messageType == NIMMessageTypeFile){
            str = @"[文件]";
        }else if(message.messageType == 2){
            str = @"[声音]";
        }else{
            str = @"消息";
        }
        chatItem.content = [NSString stringWithFormat:@"%@发送失败",str];
        [_dataArray addObject:chatItem];
        //indexPath 找到最后一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
        //添加新的一行
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//动画参数
        //滑动到底部
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else if(message.messageType==3){
        TKChatItem *chatItem=[[TKChatItem alloc]init];
        chatItem.isSelf=YES;
        NIMVideoObject * videoObject = (NIMVideoObject*)message.messageObject;
        UIImage * image              = [UIImage imageWithContentsOfFile:videoObject.coverPath];
        chatItem.image         = image;
        chatItem.isVideo = YES;
        chatItem.videoUrl = videoObject.url;
        chatItem.message = message;
        NSString * sssss = [NSString stringWithFormat:@"%@",message.messageId];
        if(dictionary[sssss]){
            NIMLoadProgressView * progressView = (NIMLoadProgressView *)[self.view viewWithTag:[dictionary[sssss] integerValue]];
            progressView.hidden = YES;
            [_dataArray replaceObjectAtIndex:[dictionary[message.messageId] integerValue]-10000 withObject:chatItem];
        }

        
    }else if(message.messageType==6){
        TKChatItem *chatItem=[[TKChatItem alloc]init];
        chatItem.message = message;
        chatItem.isSelf=YES;
        chatItem.image = [UIImage imageNamed:@"文件1"];
        
        [_dataArray addObject:chatItem];
        
        //indexPath 找到最后一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
        //添加新的一行
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//动画参数
        //滑动到底部
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }else if(message.messageType==2){
        NIMAudioObject *audioObject = (NIMAudioObject*)message.messageObject;
        TKChatItem *chatItem=[[TKChatItem alloc]init];
        chatItem.message = message;
        chatItem.isSelf=YES;
        chatItem.image = [UIImage imageNamed:@"语音123"];
        chatItem.content = [NSString stringWithFormat:@"%ld″",audioObject.duration/1000];
        [_dataArray addObject:chatItem];
        
        //indexPath 找到最后一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
        //添加新的一行
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//动画参数
        //滑动到底部
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        NSLog(@"%@",message);
        
    }else if(message.messageType==NIMMessageTypeCustom){
        
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        TKChatItem *chatItem=[[TKChatItem alloc]init];
        chatItem.isSelf=YES;
        if ([object.attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
            //cell.infoLabel.text = @"[白板]";
        }else{
            //  cell.infoLabel.text= @"[未知消息]";
            NTESWhiteboardAttachment *attachment = (NTESWhiteboardAttachment *)object.attachment;
            if(attachment.flag == 0){
                chatItem.content = @"我发起了白板演示";
            }else{
                
                chatItem.content = @"白板演示已结束";
            }
            
        }
        [_dataArray addObject:chatItem];
        //indexPath
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
        //添加新的一行
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//动画参数
        //滑动到底部
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else{
        if(message.text.length!=0){
            TKChatItem *chatItem=[[TKChatItem alloc]init];
            chatItem.isSelf=YES;
            chatItem.content=_textView.text;
            _textView.text=@"";
            chatItem.message = message;
            [_dataArray addObject:chatItem];
            
            //indexPath 找到最后一行
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
            //添加新的一行
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//动画参数
            //滑动到底部
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

#pragma mark - 收到消息成功回调
- (void)onRecvMessages:(NSArray *)messages{
    
    for(NIMMessage * message in messages){
        NSLog(@"%@",message.from);
        
        if((message.session.sessionType==0&&[message.from isEqualToString:self.userID])||(message.session.sessionType==1&&[message.session.sessionId isEqualToString:self.userID])){
            
            NSLog(@"%@",message.from);
            TKChatItem *chatItem=[[TKChatItem alloc]init];
            chatItem.isSelf=NO;
            chatItem.content=message.text;
            
            if(message.messageType==6){
                chatItem.message = message;
                chatItem.image = [UIImage imageNamed:@"文件1"];
                [_dataArray addObject:chatItem];
                //indexPath
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
                //添加新的一行
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//动画参数
                //滑动到底部
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }else if(message.messageType==0){
                
                chatItem.message = message;
                [_dataArray addObject:chatItem];
                //indexPath
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
                //添加新的一行
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//动画参数
                //滑动到底部
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }else if(message.messageType==2){
                NIMAudioObject *audioObject = (NIMAudioObject*)message.messageObject;
                chatItem.message = message;
                chatItem.image = [UIImage imageNamed:@"icon_receiver_voice_playing"];
                chatItem.content = [NSString stringWithFormat:@"%ld″",audioObject.duration/1000];
                [_dataArray addObject:chatItem];
                //indexPath
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
                //添加新的一行
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//动画参数
                //滑动到底部
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }else if (message.messageType==NIMMessageTypeNotification){
                NIMNotificationObject *object = message.messageObject;
                if (object.notificationType == NIMNotificationTypeTeam) {
                    NSLog(@"%@",object.message);
                    chatItem.content = [TKChatInfoViewController teamNotificationFormatedMessage:message];
                    chatItem.isByself = YES;
                }
                
                if (object.notificationType == NIMNotificationTypeNetCall) {
                    
                    chatItem.content = [TKChatInfoViewController netcallNotificationFormatedMessage:message];
                    chatItem.isByself = self;
                    //  [_dataArray addObject:chatItem];
                    
                }
                [_dataArray addObject:chatItem];
                //indexPath
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
                //添加新的一行
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//动画参数
                //滑动到底部
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                // chatItem.content = @"滚出群了";
            }else if(message.messageType==NIMMessageTypeCustom){
                NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
                id attachment = object.attachment;
                NSLog(@"%@",attachment);
                
                if ([object.attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
                    //cell.infoLabel.text = @"[白板]";
                }else{
                    //  cell.infoLabel.text= @"[未知消息]";
                    NTESWhiteboardAttachment *attachment = (NTESWhiteboardAttachment *)object.attachment;
                    if(attachment.flag == 0){
                        chatItem.content = @"我发起了白板演示";
                    }else{
                        
                        chatItem.content = @"白板演示已结束";
                    }
                    
                }
                
                [_dataArray addObject:chatItem];
                //indexPath
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
                //添加新的一行
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//动画参数
                //滑动到底部
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
            
        }
        
    }
    NSLog(@"接受状态%@",messages);
    //AudioServicesPlaySystemSound(1106);
    
}
#pragma mark - Private
+ (NSString *)TteamNotificationSourceName:(NIMMessage *)message{
    NSString *source;
    NIMNotificationObject *object = message.messageObject;
    NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if ([content.sourceID isEqualToString:currentAccount]) {
        source = @"你";
    }else{
        source = [TKChatInfoViewController showNick:content.sourceID inSession:message.session];
    }
    return source;
}

+ (NSArray *)TteamNotificationTargetNames:(NIMMessage *)message{
    NSMutableArray *targets = [[NSMutableArray alloc] init];
    NIMNotificationObject *object = message.messageObject;
    NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    for (NSString *item in content.targetIDs) {
        if ([item isEqualToString:currentAccount]) {
            [targets addObject:@"你"];
        }else{
            NSLog(@"%@",item);
            NSString *targetShowName = [TKChatInfoViewController showNick:item inSession:message.session];
            if(targetShowName==nil){
                
            }else{
                [targets addObject:targetShowName];
            }
        }
    }
    return targets;
}
+ (NSString *)teamNotificationTeamShowName:(NIMMessage *)message{
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId];
    NSString *teamName = team.type == NIMTeamTypeNormal ? @"讨论组" : @"群";
    return teamName;
}
+ (NSString *)showNick:(NSString*)uid inMessage:(NIMMessage*)message
{
    if (!uid.length) {
        return nil;
    }
    //NSString *showname = [[NIMKit sharedKit] infoByUser:uid withMessage:message]showname;
    NSString *showname = [[NIMKit sharedKit] infoByUser:uid option:nil].showName;
    return showname;
}

+ (NSString *)showNick:(NSString*)uid inSession:(NIMSession*)session{
    if (!uid.length) {
        return nil;
    }
    return [[[[[NIMSDK sharedSDK]userManager]userInfo:uid]userInfo]nickName];
}

#pragma mark - 群状态提醒
+ (NSString*)teamNotificationFormatedMessage:(NIMMessage *)message{
    NSString *formatedMessage = @"";
    NIMNotificationObject *object = message.messageObject;
    if (object.notificationType == NIMNotificationTypeTeam)
    {
        NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
        NSString *source = [TKChatInfoViewController TteamNotificationSourceName:message];
        NSArray *targets = [TKChatInfoViewController TteamNotificationTargetNames:message];
        NSString *targetText = [targets count] > 1 ? [targets componentsJoinedByString:@","] : [targets firstObject];
        NSString *teamName = [TKChatInfoViewController teamNotificationTeamShowName:message];
        
        switch (content.operationType) {
            case NIMTeamOperationTypeInvite:{
                NSString *str = [NSString stringWithFormat:@"%@邀请%@",source,targets.firstObject];
                if (targets.count>1) {
                    str = [str stringByAppendingFormat:@"等%zd人",targets.count];
                }
                str = [str stringByAppendingFormat:@"进入了%@",teamName];
                formatedMessage = str;
            }
                break;
            case NIMTeamOperationTypeDismiss:
                formatedMessage = [NSString stringWithFormat:@"%@解散了%@",source,teamName];
                break;
            case NIMTeamOperationTypeKick:{
                NSString *str = [NSString stringWithFormat:@"%@将%@",source,targets.firstObject];
                if (targets.count>1) {
                    str = [str stringByAppendingFormat:@"等%zd人",targets.count];
                }
                str = [str stringByAppendingFormat:@"移出了%@",teamName];
                formatedMessage = str;
            }
                break;
            case NIMTeamOperationTypeUpdate:
            {
                id attachment = [content attachment];
                if ([attachment isKindOfClass:[NIMUpdateTeamInfoAttachment class]]) {
                    NIMUpdateTeamInfoAttachment *teamAttachment = (NIMUpdateTeamInfoAttachment *)attachment;
                    //如果只是单个项目项被修改则显示具体的修改项
                    if ([teamAttachment.values count] == 1) {
                        NIMTeamUpdateTag tag = [[[teamAttachment.values allKeys] firstObject] integerValue];
                        switch (tag) {
                            case NIMTeamUpdateTagName:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@名称",source,teamName];
                                break;
                            case NIMTeamUpdateTagIntro:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@介绍",source,teamName];
                                break;
                            case NIMTeamUpdateTagAnouncement:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@公告",source,teamName];
                                break;
                            case NIMTeamUpdateTagJoinMode:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@验证方式",source,teamName];
                                break;
                            default:
                                break;
                                
                        }
                    }
                }
                if (formatedMessage == nil){
                    formatedMessage = [NSString stringWithFormat:@"%@更新了%@信息",source,teamName];
                }
            }
                break;
            case NIMTeamOperationTypeLeave:
                formatedMessage = [NSString stringWithFormat:@"%@离开了%@",source,teamName];
                break;
            case NIMTeamOperationTypeApplyPass:{
                if ([source isEqualToString:targetText]) {
                    //说明是以不需要验证的方式进入
                    formatedMessage = [NSString stringWithFormat:@"%@进入了%@",source,teamName];
                }else{
                    formatedMessage = [NSString stringWithFormat:@"%@通过了%@的申请",source,targetText];
                }
            }
                break;
            case NIMTeamOperationTypeTransferOwner:
                formatedMessage = [NSString stringWithFormat:@"%@转移了群主身份给%@",source,targetText];
                break;
            case NIMTeamOperationTypeAddManager:
                formatedMessage = [NSString stringWithFormat:@"%@被群主添加为群管理员",targetText];
                break;
            case NIMTeamOperationTypeRemoveManager:
                formatedMessage = [NSString stringWithFormat:@"%@被群主撤销了群管理员身份",targetText];
                break;
            case NIMTeamOperationTypeAcceptInvitation:
                formatedMessage = [NSString stringWithFormat:@"%@接受%@的邀请进群",source,targetText];
                break;
            default:
                break;
        }
        
    }
    if (!formatedMessage.length) {
        formatedMessage = [NSString stringWithFormat:@"未知系统信息"];
    }
    return formatedMessage;
}

#pragma mark -- 将要发送消息(用于发送较大附件的进度提醒)
- (void)willSendMessage:(NIMMessage *)message{
    
    if(message.messageType==3){
        //NIMImageObject * imageob = (NIMImageObject *)message.messageObject;
        NIMVideoObject * videoObject = (NIMVideoObject*)message.messageObject;
        UIImage * image              = [UIImage imageWithContentsOfFile:videoObject.coverPath];
        TKChatItem *chatItem=[[TKChatItem alloc]init];
        chatItem.image         = image;
        chatItem.isVideo = YES;
        chatItem.isSelf= YES;
        chatItem.videoUrl = videoObject.url;
        chatItem.message = message;
        //[_dataArray addObject:chatItem];
        
        [_dataArray addObject:chatItem];
        //indexPath
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
        //添加新的一行
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//动画参数
        //滑动到底部
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
#pragma mark -- 发送附件进度回调
- (void)sendMessage:(NIMMessage *)message
           progress:(CGFloat)progress{
    //[SVProgressHUD showProgress:progress];
    NSLog(@"%lf",progress);
    NSString * sssss = [NSString stringWithFormat:@"%@",message.messageId];
    NIMLoadProgressView * progressView = [[NIMLoadProgressView alloc]init];
    NSLog(@"%@",dictionary[sssss]);
    if(dictionary[sssss]){
        progressView = (NIMLoadProgressView *)[self.view viewWithTag:[dictionary[sssss] integerValue]];
        //打印当前进度
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            progressView.progress = progress;
            
        }];
        
    }
}

- (BOOL)fetchMessageAttachment:(NIMMessage *)message
                         error:(NSError **)error{
    
    return YES;
}

- (void)fetchMessageAttachment:(NIMMessage *)message
                      progress:(CGFloat)progress{
    NSLog(@"哈哈哈");
}
- (void)fetchMessageAttachment:(NIMMessage *)message
          didCompleteWithError:(NSError *)error{
    if (error==nil) {
        if((message.session.sessionType==0&&[message.from isEqualToString:self.userID])||(message.session.sessionType==1&&[message.session.sessionId isEqualToString:self.userID])){
            TKChatItem *chatItem=[[TKChatItem alloc]init];
            chatItem.isSelf=NO;
            chatItem.content=message.text;
            if(message.messageType==1){
                NIMImageObject * imageob = (NIMImageObject *)message.messageObject;
                NSString * path = imageob.thumbPath;
                UIImage * image =  [UIImage imageWithContentsOfFile:path];
                chatItem.image = image;
                chatItem.message = message;
                NSLog(@"%@",chatItem.image);
                [_dataArray addObject:chatItem];
                //indexPath
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
                //添加新的一行
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//动画参数
                //滑动到底部
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
            }
            else if(message.messageType==3){
                
                //NIMImageObject * imageob = (NIMImageObject *)message.messageObject;
                NIMVideoObject * videoObject = (NIMVideoObject*)message.messageObject;
                UIImage * image              = [UIImage imageWithContentsOfFile:videoObject.coverPath];
                chatItem.image         = image;
                chatItem.isVideo = YES;
                chatItem.videoUrl = videoObject.url;
                chatItem.message = message;
                //                 NIMLoadProgressView * progressView = (NIMLoadProgressView *)[self.view viewWithTag:[dictionary[message.messageId] integerValue]];
                //                 progressView.hidden = YES;
                //                 [_dataArray replaceObjectAtIndex:[dictionary[message.messageId] integerValue] withObject:chatItem];
                //
                //[_dataArray addObject:chatItem];
                
                [_dataArray addObject:chatItem];
                //indexPath
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
                //添加新的一行
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//动画参数
                //滑动到底部
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
            }
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
    result = [TKChatInfoViewController getPeriodOfTime:hour withMinute:msgDateComponents.minute];
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
        NSString *weekDay = [TKChatInfoViewController weekdayStr:msgDateComponents.weekday];
        result = showDetail? [weekDay stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : weekDay;
    }
    else//显示日期
    {
        NSString *day = [NSString stringWithFormat:@"%zd-%zd-%zd", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
        result = showDetail? [day stringByAppendingFormat:@" %@ %zd:%02d",result,hour,(int)msgDateComponents.minute]:day;
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
+ (NSString *)netcallNotificationFormatedMessage:(NIMMessage *)message{
    NIMNotificationObject *object = message.messageObject;
    NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
    NSString *text = @"";
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    switch (content.eventType) {
        case NIMNetCallEventTypeMiss:{
            text = @"未接听";
            break;
        }
        case NIMNetCallEventTypeBill:{
            text =  ([object.message.from isEqualToString:currentAccount])? @"通话拨打时长 " : @"通话接听时长 ";
            NSTimeInterval duration = content.duration;
            NSString *durationDesc = [NSString stringWithFormat:@"%02d:%02d",(int)duration/60,(int)duration%60];
            text = [text stringByAppendingString:durationDesc];
            break;
        }
        case NIMNetCallEventTypeReject:{
            text = ([object.message.from isEqualToString:currentAccount])? @"对方正忙" : @"已拒绝";
            break;
        }
        case NIMNetCallEventTypeNoResponse:{
            text = @"未接通，已取消";
            break;
        }
        default:
            break;
    }
    return text;
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
