//
//  TKSearchViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKSearchViewController.h"
#import "IWSearchBar.h"
#import "TKInvitationTableViewCell.h"
#import "UITableView+PullRefresh.h"
#import "TKContactsAction.h"
#import "TKChatTableViewCell.h"
#import "TKChatInfoViewController.h"

@interface TKSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NIMUserManagerDelegate,NIMLoginManagerDelegate,NIMTeamManagerDelegate>

@property (nonatomic,strong)IWSearchBar * search;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;//数据库

@property (nonatomic,assign)NSInteger pageNum;

@property (nonatomic,assign)BOOL isFresh;//是否未刷新;

@end

@implementation TKSearchViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // self.navigationController.navigationBar.hidden = YES;
    _dataArr = [NSMutableArray array];
    _pageNum = 1;
    
    //托管了用户信息，那就直接加 userManager 的监听
    [[NIMSDK sharedSDK].userManager addDelegate:self];
   
    [[[NIMSDK sharedSDK] teamManager]  addDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[[NIMSDK sharedSDK] userManager]  addDelegate:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTOP];
    [self createTable];
    [self createData];
    // Do any additional setup after loading the view.
}

-(void)dealloc{
    
    _tableView = nil;
    
    
}

- (void)createTOP{
    
    
    
    //title
    _search = [[IWSearchBar alloc]initWithFrame:CGRectMake(30, 25, screen_width-80, 30)];
    _search.backgroundColor=backcolor;
    _search.placeholder = @"输入搜索账号";
    _search.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:_search];
    self.navigationItem.titleView = _search;
    
}

-(void)textFieldDidChange{
    _isFresh = YES;
    [self createData];
}

- (void)backButon{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)createData{
    // if(_search.text.length!=0){'
    
    [TKContactsAction teamAndFriends:[TKUserSetting sharedManager].username pageNumber:_pageNum pageSize:20 keyword:_search.text respose:^(NSArray<TKSearchModel *> *searchModels, NSString *aMessage) {
        if (searchModels && searchModels.count>0) {
          
            if(self.isFresh ==YES){
                if(self.dataArr.count>0){
                    [self.dataArr removeAllObjects];
                }
                
            }
            if (self.dataArr == nil) {
                self.dataArr = [NSMutableArray array];
            }
            [_dataArr addObjectsFromArray:searchModels];
            [self.tableView reloadData];
        }
    }];
    
    
}

- (void)createTable{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height-34) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TKInvitationTableViewCell" bundle:nil] forCellReuseIdentifier:@"yaoqingCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TKChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"chatCell"];
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
    // [self.tableView performSelector:@selector(startPullDownAnimate) withObject:nil afterDelay:0.1];
    
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


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //    [_refresh addHeardRefreshTo:_tableView heardBlock:^{
    //        [weakSelf pushDon];
    //    } footBlok:^{
    //        [weakSelf xialafresh];
    //    }];
    //    [_refresh beginHeardRefresh];
    
}

- (void)pushDon
{
    _isFresh = YES;
    _pageNum = 1;
    [self createData];
}

/**
 *  上啦加载更多
 */
- (void)xialafresh
{_isFresh = NO;
    _pageNum ++;
    [self createData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TKInvitationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"yaoqingCell"];
    TKSearchModel * model = _dataArr[indexPath.row];
    // cell.headImage.hidden = YES;
    cell.yaoqingLabel.text = model.alias;
    cell.seeLabel.hidden = NO;
    cell.headLabel.hidden = NO;
    cell.headImage.hidden = NO;
    [cell.headImage setImage:[UIImage imageNamed:TK_ImgColor]];
    
    
    cell.seeLabel.hidden = YES;
    if (model.alias.length == 0) {
        cell.headLabel.text =@"空";
    }else{
        cell.headLabel.text = [cell.yaoqingLabel.text substringToIndex:1];
    }
    return cell;
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TKChatInfoViewController * chatInfo = [[TKChatInfoViewController alloc]init];
    TKSearchModel * model = _dataArr[indexPath.row];
    if(model.isTeam.integerValue==1){
        NSString * str = [NSString stringWithFormat:@"%@",model.usergid];
        chatInfo.userID = str;
        NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:str];
        NSString * title = [NSString stringWithFormat:@"%@(%zd人)",[team teamName],[team memberNumber]];
        chatInfo.nameStr =title;
        NIMSession *session = [NIMSession session:str type:model.isTeam.integerValue];
        chatInfo.session = session;
        chatInfo.type = 1;
        
    }else{
        chatInfo.userID = model.userid;
        chatInfo.nameStr = model.alias;
        NIMSession *session = [NIMSession session:model.userid type:model.isTeam.integerValue];
        chatInfo.session = session;
    }
    
    [self.navigationController pushViewController:chatInfo animated:YES];
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
