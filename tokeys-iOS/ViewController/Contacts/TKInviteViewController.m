//
//  TKInviteViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKInviteViewController.h"
#import <MessageUI/MessageUI.h>
#import "IWSearchBar.h"
#import "TKMessageTableViewCell.h"
#import "TKSelectPeople.h"
#import "TKTeamAction.h"
#import "TKLarenModel.h"
#import "TKPhoneModel.h"
#import "UITableView+PullRefresh.h"
#import "TKInvitationTableViewCell.h"

@interface TKInviteViewController ()<UITableViewDataSource,UITableViewDelegate,TKMessageTableViewCellDelegate,NIMChatManagerDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate>{
    UILabel * chooseCountLabel;//提示选择多少个
}

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * Array;
@property (nonatomic,strong) NSMutableArray *choseArray;
@property (nonatomic,strong) UIButton * button;
@property (nonatomic,strong) NSMutableArray * lastArr;
@property (nonatomic,strong) UILabel * label;
@property (nonatomic,strong) IWSearchBar * search;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) BOOL shangla;//判断是否上拉
@property (nonatomic,assign) BOOL fresh;//判断是否刷新
@property (nonatomic,strong) NSMutableArray * searchArr;//存储搜索各页选择数据
@property (nonatomic,copy) NSString * searchKey;//搜索词

@end

@implementation TKInviteViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    _choseArray = [NSMutableArray array];
    _searchArr = [NSMutableArray array];
    _Array = [NSMutableArray array];
    _lastArr = [NSMutableArray array];
    _searchKey = @"";
    //self.title = @"发送给";
    //self.title = self.titleStr;
    [[[NIMSDK sharedSDK]chatManager] addDelegate:self];
    // [[[NIMSDK sharedSDK]teamManager]addDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if(_isVideo==YES&&_isShare==YES){
        
        [self createData];
        
    }else{
        [self creatrData];
    }
    [self createUI];
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(0, 0, 22, 15);
    [releaseButton setImage:[UIImage imageNamed:@"send_to_icon"] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    //self.navigationItem.rightBarButtonItem = releaseButtonItem;
    //返回按钮
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    UILabel * ljjLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 60, 20)];
    ljjLabel.text = @"发送给";
    UIBarButtonItem *left2 = [[UIBarButtonItem alloc] initWithCustomView:ljjLabel];
    
    self.navigationItem.leftBarButtonItems= @[leftBarButton,left2];
    chooseCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 60, 20)];
    chooseCountLabel.textColor = blcolor;
    chooseCountLabel.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"已选0"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 2)];
    chooseCountLabel.attributedText = str;
    UIBarButtonItem *releaseButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:chooseCountLabel];
    self.navigationItem.rightBarButtonItems=@[releaseButtonItem,releaseButtonItem1];
    // Do any additional setup after loading the view.
}
-(void)backAction{
    
    if(_isVideo==YES){
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    //[self.navigationController]
    
}


-(void)releaseInfo{
    
    if(self.isYaoqin==YES){
        
        if(_isLaren == YES){//拉人
            NSMutableArray * menbers = [NSMutableArray array];
            if(_choseArray.count>0){
                for(NSString * str in _choseArray){
                    TKSelectPeople*people =_Array[str.integerValue];
                    [menbers addObject:people.name];
                }
            }
            NSLog(@"%@",menbers);
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:menbers options:0 error:nil];
            NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
          
            
            
            [TKTeamAction team_invite:_groupID owner:[TKUserSetting sharedManager].username members:myString respose:^(BOOL aSuccess, NSString *aMessage) {
                if (aSuccess) {
                    [XYHUDCore showSuccessWithStatus:@"邀请成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else{
            
            //[SVProgressHUD showWithStatus:@"需要收取短信费"];
            NSMutableArray * menbers = [NSMutableArray array];
            //NSString * string ;
            if(_searchArr.count>0){
                for(NSString*people in _searchArr){
                    // selectPeople*people =_Array[str.integerValue];
                    // NSDictionary * dict = @{@"accid":people.name};
                    [menbers addObject:people];
                }
            }
            //[SVProgressHUD dismiss];
            [self showMessageView:menbers title:@"test" body:@"邀请你注册www.pgyer.com/DVqh"];
            
        }
        
    }else{
        if(self.isVideo ==YES){
            
            if(_isShare == YES){
                
                NSMutableArray * seleData = [NSMutableArray array];
                if(_choseArray.count>0){
                    for(NSString * str in _choseArray){
                        //selectPeople*people =_Array[str.integerValue];
                        [seleData addObject:_dataArr[str.integerValue]];
                    }
                }
                
                for (TKSelectPeople * user in seleData) {
                    NIMMessage *message = [[NIMMessage alloc] init];
                    message.text    = self.nameTitle;
                    NSLog(@"%@%@",self.time,self.nameTitle);
                    NSDictionary * dictc = @{@"document":@"1",@"time":self.time,@"title":_urlString};
                    message.remoteExt = dictc;
                    //构造会话
                    NIMSession *session= nil;
                    if (user.isGroup==YES) {
                        session = [NIMSession session:user.name type:NIMSessionTypeTeam];
                    }else{
                        session = [NIMSession session:user.name type:NIMSessionTypeP2P];
                    }
                    //发送消息
                    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                }
                
            }else{
                NSLog(@"%@",self.pathStr);
                NSMutableArray * seleData = [NSMutableArray array];
                if(_choseArray.count>0){
                    for(NSString * str in _choseArray){
                        // selectPeople*people =_Array[str.integerValue];
                        [seleData addObject:_dataArr[str.integerValue]];
                    }
                }
                
                for (TKSelectPeople * user in seleData) {
                    
                    if(user.isWendang==YES){
                        for(UIImage * image in _picDataArr){
                            NSLog(@"%@",image);
                            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
                            
                        }
                    }else{
                        
                        for(UIImage * image in _picDataArr){
                            NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
                            NIMMessage *message          = [[NIMMessage alloc] init];
                            message.messageObject        = imageObject;
                            
                            NIMSession *session;
                            if (user.isGroup==YES) {
                                session = [NIMSession session:user.name type:NIMSessionTypeTeam];
                            }else{
                                session = [NIMSession session:user.name type:NIMSessionTypeP2P];
                            }
                            //发送消息
                            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                        }
                        NIMVideoObject *videoObject = [[NIMVideoObject alloc] initWithSourcePath:self.pathStr];
                        NIMMessage *message         = [[NIMMessage alloc] init];
                        message.messageObject       = videoObject;
                        NIMSession *session;
                        if (user.isGroup==YES) {
                            session = [NIMSession session:user.name type:NIMSessionTypeTeam];
                        }else{
                            session = [NIMSession session:user.name type:NIMSessionTypeP2P];
                        }
                        //发送消息
                        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                        
                    }
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSMutableArray * menbers = [NSMutableArray array];
            // NSDictionary * dic = @[USER_name];
            [menbers addObject:[TKUserSetting sharedManager].username];
            if(_choseArray.count>0){
                for(NSString * str in _choseArray){
                    TKSelectPeople*people =_Array[str.integerValue];
                    // NSDictionary * dict = @{@"accid":people.name};
                    [menbers addObject:people.name];
                }
            }
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:menbers options:0 error:nil];
            NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
           
            [TKTeamAction team_create:self.titleStr owner:[TKUserSetting sharedManager].username members:myString did:@"0" respose:^(BOOL aSuccess, NSString *aMessage) {
                if (aSuccess) {
                    [XYHUDCore showSuccessWithStatus:@"创建成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"jianqun" object:nil userInfo:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
    }
    
}
#pragma mark -短信结果回调
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [XYHUDCore showSuccessWithStatus:@"发送成功"];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [XYHUDCore showErrorWithStatus:@"发送失败"];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [XYHUDCore showErrorWithStatus:@"取消发送"];
            break;
        default:
            break;
    }
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)sendMessage:(NIMMessage *)message
didCompleteWithError:(NSError *)error{
    NSLog(@"发送状态%@",error);
    if(error==nil){
        
        
    }
    //[SVProgressHUD dismiss];
}

- (void)sendMessage:(NIMMessage *)message
           progress:(CGFloat)progress{
    //[SVProgressHUD showProgress:progress];
    NSLog(@"%lf",progress);
    
}
- (void)onTeamAdded:(NIMTeam *)team{
    
    NSLog(@"%@",team.teamId);
    
}


- (void)creatrData{
    NSLog(@"%@",_dataArr);
    if(_isLaren==YES){
        
        for(NSDictionary * dict in _dataArr){
            TKSelectPeople * sele = [[TKSelectPeople alloc]init];
            TKLarenModel * momel = [[TKLarenModel alloc]init];
            [momel setValuesForKeysWithDictionary:dict];
            sele.name = momel.accid;
            sele.infoNme = momel.alias;
            sele.phone = momel.phone;
            [_Array addObject:sele];
        }
        
    }else{
        
        if(_isYaoqin ==YES){
            for(NSDictionary * dict in _dataArr){
                TKSelectPeople * sele = [[TKSelectPeople alloc]init];
                TKPhoneModel * model = [[TKPhoneModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                sele.infoNme = model.name;
                sele.name = model.phone;
                [_Array addObject:sele];
            }
        }else{
            if(_isVideo==YES){
                if(_isShare == YES){
                    
                    for(TKSelectPeople * user in _dataArr){
                        
                        [_Array addObject:user];
                        
                    }
                    
                }else{
                    for(TKSelectPeople * user in _dataArr){
                        
                        [_Array addObject:user];
                        
                    }
                }
            }else{
                
                if(_isreateGroup == YES){
                    for(TKFriendModel * model in _dataArr){
                        TKSelectPeople * sele = [[TKSelectPeople alloc]init];
                        sele.name = model.accid;
                        sele.infoNme = model.nick;
                        sele.phone = model.phone;
                        sele.isSele = NO;
                        [_Array addObject:sele];
                    }
                }else{
                    for(NIMUser * user in _dataArr){
                        TKSelectPeople * sele = [[TKSelectPeople alloc]init];
                        sele.name = user.userId;
                        sele.infoNme = user.alias;
                        sele.isSele = NO;
                        sele.img = user.userInfo.avatarUrl;
                        [_Array addObject:sele];
                    }
                }
            }
        }
    }
    
}

- (void)createUI{
    
    UIView * view =[[UIView alloc]init];
    if(_isYaoqin==YES||_isVideo==YES){
        view.frame = CGRectMake(0, 64, screen_width, 60);
    }else{
        view.frame = CGRectMake(0, 64, screen_width, 0);
    }
    view.backgroundColor = blcolor;
    if(_isLaren==YES){
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 80, 44)];
    }else{
        
        _search = [[IWSearchBar alloc]initWithFrame:CGRectMake(8, 10, screen_width-80, 40)];
        _search.backgroundColor=backcolor;
        _search.placeholder = @"联系人搜索";
        _search.delegate=self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:_search];
        
        [view addSubview:_search];
        
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(screen_width-70, 8, 40, 44)];
    }
    _label.textColor = [UIColor whiteColor];
    _label.text = @"全选";
    [view addSubview:_label];
    _button  = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(screen_width-30, 17, 25, 25);
    _button.layer.cornerRadius = 3;
    [_button addTarget:self action:@selector(allSele:) forControlEvents:UIControlEventTouchUpInside];
    _button.layer.borderWidth = 1;
    _button.layer.borderColor = [[UIColor whiteColor]CGColor];
    [view addSubview:_button];
    [self.view addSubview:view];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, view.frame.size.height+64, screen_width, screen_height-view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    if (@available(iOS 11.0, *)){
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TKMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TKInvitationTableViewCell" bundle:nil] forCellReuseIdentifier:@"yaoqingCell"];
    if(_isYaoqin==YES&&_isLaren==NO){
        /* 初始化控件 */
        //1.在开启下拉或者上拉前调用
        [self.tableView setup];
        
        //2.开启下拉刷新
        [self.tableView setPullDownEnable:YES];
        
        //3.开启上拉获取更多
        [self.tableView setLoadMoreEnable:YES];
        
        //4.设置回调函数
        __weak typeof(self)weakSelf = self;
        [self.tableView setLoadingBlock:^(BOOL pullDown) {
            
            [weakSelf requestData:!pullDown];
        }];
    }
    if(_isVideo==YES&&_isShare==YES){
        /* 初始化控件 */
        //1.在开启下拉或者上拉前调用
        [self.tableView setup];
        
        //2.开启下拉刷新
        [self.tableView setPullDownEnable:YES];
        
        //3.开启上拉获取更多
        [self.tableView setLoadMoreEnable:YES];
        
        //4.设置回调函数
        __weak typeof(self)weakSelf = self;
        [self.tableView setLoadingBlock:^(BOOL pullDown) {
            
            [weakSelf requestData:!pullDown];
        }];
    }
    
    
    
}


- (void)requestData:(BOOL)isLoadMore
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!isLoadMore)
        {
            [self pushDon];
        }else{
            
            [self xialafresh];
            
        }
        //5.结束动画
        [self.tableView reloadData];
    });
}

-(void)pushDon{
    _fresh = YES;
    _shangla = NO;
    _pageNum = 1;
    if(_isVideo==YES&&_isShare==YES){
        [self createData];
    }else{
        [self searchData];
    }
}

-(void)xialafresh{
    _fresh = YES;
    _pageNum++;
    _shangla = YES;
    if(_isVideo==YES&&_isShare==YES){
        //[self createData];
    }else{
        [self searchData];
    }
}

#pragma mark -- 联系人搜索
-(void)textFieldDidChange{
    _fresh = NO;
    _shangla = NO;
    _pageNum = 1;
    _searchKey = _search.text;
    if(_isVideo==YES){
        [self createData];
    }else{
        [self searchData];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)searchData{
    
    //NSLog(@"%@",text);
//    [HttpRequest postWithURL:HTTP_URL(@"/user/noRegisterPhones") params:@{@"accid":[LJUserSetting sharedManager].username,@"pageNumber":[NSString stringWithFormat:@"%ld",_pageNum],@"pageSize":@"10",@"keyword":_searchKey} success:^(id responseObject) {
//        NSData *responseData1 = responseObject;
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",responseDict);
//        if([responseDict[@"code"]integerValue]==0){
//            if(_dataArr.count>0){
//                [_dataArr removeAllObjects];
//            }
//            if(_shangla==YES){
//            }else{
//                if(_fresh==YES){
//                    if (_Array.count>0) {
//                        [_Array removeAllObjects];
//                    }
//                }else{
//                    if (_Array.count>0) {
//                        [_Array removeAllObjects];
//                    }
//                    if(_choseArray.count>0){
//                        [_choseArray removeAllObjects];
//                    }
//
//                }
//
//            }
//            for(NSDictionary * dic in responseDict[@"data"]){
//                [_dataArr addObject:dic];
//            }
//            // _dataArr =  [NSMutableArray arrayWithArray:responseDict[@"data"]];
//            [self creatrData];
//            [self.tableView reloadData];
//        }else{
//            // [XYHUDCore showErrorWithStatus:@"没有更"];
//            [SVProgressHUD dismiss];
//        }
//
//    } failure:^(NSError *error) {
//        [XYHUDCore showErrorWithStatus:@"数据没有请求下来"];
//        // [self.tableView reloadData];
//    }];
    
}
-(void)createData{
    // if(_search.text.length!=0){
//    NSDictionary * dict = @{@"accid":[LJUserSetting sharedManager].username,@"pageNumber":[NSString stringWithFormat:@"%ld",_pageNum],@"keyword":_searchKey};
//    [HttpRequest postWithURL:HTTP_URL(@"/user/getTeamAndFriends") params:dict success:^(id responseObject) {
//        NSData *responseData1 = responseObject;
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableContainers error:nil];
//        //NSLog(@"%@",responseDict);
//        if([responseDict[@"code"]integerValue]==0){
//            [SVProgressHUD dismiss];
//            if(_dataArr.count>0){
//                [_dataArr removeAllObjects];
//            }
//            if(_shangla==YES){
//
//
//            }else{
//                if(_fresh==YES){
//                    if (_Array.count>0) {
//                        [_Array removeAllObjects];
//                    }
//                }else{
//                    if (_Array.count>0) {
//                        [_Array removeAllObjects];
//                    }
//                    if(_choseArray.count>0){
//                        [_choseArray removeAllObjects];
//                    }
//
//                }
//
//            }
//            for(NSDictionary * dict in responseDict[@"data"][@"list"]){
//                searchModel * model = [[searchModel alloc]init];
//                [model setValuesForKeysWithDictionary:dict];
//                selectPeople * selle = [[selectPeople alloc]init];
//                selle.name = [NSString stringWithFormat:@"%@",model.userid];
//                selle.infoNme = model.alias;
//                if(model.isTeam.integerValue==1){
//                    selle.isGroup = YES;
//                }else{
//
//                    selle.isGroup = NO;
//                }
//                [_dataArr addObject:selle];
//            }
//            [self creatrData];
//            [self.tableView reloadData];
//        }else{
//
//            [XYHUDCore showErrorWithStatus:responseDict[@"message"]];
//        }
//        // [_refresh endRefresh];
//    } failure:^(NSError *error) {
//        [XYHUDCore showErrorWithStatus:@"请求失败"];
//        //  [_refresh endRefresh];
//    }];
//
//    // }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}
#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _Array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TKMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    // cell.selectButton.hidden = YES;
    TKSelectPeople * people = [[TKSelectPeople alloc]init];
    people = _Array[indexPath.row];
    //数组中包含当前行号
    NSString*  selectRow  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    if ([self.choseArray  containsObject:selectRow]) {
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateNormal];
    }else{
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"un_select_icon"] forState:UIControlStateNormal];
    }
    // NSLog(@"ppppppp%@",_searchArr);
    // NSLog(@"iiiiiii%@",_Array);
    if ([_searchArr containsObject:people.name]) {
        if(![self.choseArray containsObject:selectRow]){
            [self.choseArray addObject:selectRow];
        }
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateNormal];
    }
    cell.namelABEL.text = people.infoNme;
    cell.INFO.text = people.name;
    if(_isYaoqin==YES||_isreateGroup==YES){
        cell.namelABEL.hidden = NO;
        cell.INFO.hidden = NO;
        cell.mainLbael.hidden = YES;
        if(_isreateGroup == YES||_isLaren == YES){
            cell.INFO.text = people.phone;
        }
        
        if(_isLaren == YES){
            
            cell.namelABEL.hidden = YES;
            cell.INFO.hidden = YES;
            cell.mainLbael.text = people.infoNme;
            cell.mainLbael.hidden = NO;
            
        }
        
    }else{
        cell.namelABEL.hidden = YES;
        cell.INFO.hidden = YES;
        cell.mainLbael.text = people.infoNme;
        cell.mainLbael.hidden = NO;
    }
    cell.delegate = self;
    cell.is = indexPath;
    if(indexPath.section ==1){
        TKInvitationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"yaoqingCell"];
        cell.headImage.backgroundColor = [UIColor colorWithRed:42/255.0 green:177.0/255.0 blue:234/255.0 alpha:1];
        cell.yaoqingLabel.textColor = [UIColor colorWithRed:42/255.0 green:177.0/255.0 blue:234/255.0 alpha:1];
        cell.headImage.layer.cornerRadius = 25;
        cell.clipsToBounds = YES;
        return cell;
    }
    return cell;
}

- (void)messageTableViewCell:(TKMessageTableViewCell *)aCell selectToPeople:(NSIndexPath *)number{
    // NSLog(@"%d",number);
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString*  selectRow  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    TKSelectPeople * people = _Array[indexPath.row];
    //判断数组中有没有被选中行的行号,
    if ([self.choseArray containsObject:selectRow]) {
        [self.choseArray removeObject:selectRow];
        [self.searchArr removeObject:people.name];
    }else{
        [self.choseArray addObject:selectRow];
        [self.searchArr addObject:people.name];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已选%ld",self.searchArr.count]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 2)];
    chooseCountLabel.attributedText = str;
    
    NSLog(@"你选中了第%ld",(long)indexPath.row);
    //cell刷新
    NSIndexPath *index=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 40.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(0, 8, 100, 21)];
    label.textColor = [UIColor darkGrayColor];
    if(_isYaoqin==NO){
        label.text = @"   常用联系人";
    }else{
        label.text = @"   常用联系人";
        if(_isLaren==NO){
            label.text = @"   常用联系人(发送按标准短信收费)";
        }
    }
    return label;
    
}

-(void)allSele:(UIButton*)btn{
    
    _button.selected = !_button.selected;
    if(_button.selected == YES){
        [_choseArray removeAllObjects];
        for(int i = 0;i<_Array.count;i++){
            TKSelectPeople * people = _Array[i];
            [_choseArray addObject:[NSString stringWithFormat:@"%d",i]];
            if(![_searchArr containsObject:people.name]){
                [self.searchArr addObject:people.name];
            }
        }
        [_button setImage:[UIImage imageNamed:@"选中-钩"] forState:UIControlStateNormal];
    }else{
        [_choseArray removeAllObjects];
        for(int i = 0;i<_Array.count;i++){
            TKSelectPeople * people = _Array[i];
            [self.searchArr removeObject:people.name];
        }
        [_button setImage:[UIImage imageNamed:@"未选择空"] forState:UIControlStateNormal];
    }
    NSLog(@"%@",_choseArray);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已选%ld",self.searchArr.count]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 2)];
    chooseCountLabel.attributedText = str;
    
    //[_choseArray removeAllObjects];
    [self.tableView reloadData];
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
