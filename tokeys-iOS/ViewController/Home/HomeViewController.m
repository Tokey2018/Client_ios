//
//  HomeViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2018/12/25.
//  Copyright © 2018 杨卢银. All rights reserved.
//

#import "HomeViewController.h"
#import "WMPageController.h"
#import "MainTouchTableView.h"
#import "MainTouchScrollView.h"
#import "WRNavigationBar.h"
#import <AVFoundation/AVFoundation.h>
#import "TKChatListViewController.h"
#import "TKContactsViewController.h"

@interface HomeViewController ()<UIImagePickerControllerDelegate,WMPageControllerDelegate,WMPageControllerDataSource,UITableViewDelegate,UITableViewDataSource>{
    
    CGPoint center;
    CGFloat headViewHeight;
    CGFloat beginContentY;          //开始滑动的位置
    CGFloat endContentY;            //结束滑动的位置
    CGFloat sectionHeaderHeight;    //section的header高度
    
}
@property(nonatomic ,strong) TKChatListViewController *chatListViewController;
@property(nonatomic ,strong) TKContactsViewController *contactsViewController;

@property(nonatomic ,strong) MainTouchTableView * mainTableView;

@property(nonatomic ,strong) MainTouchScrollView * mainScrollView;

@property(nonatomic ,strong) UIScrollView * parentScrollView;

//@property(nonatomic ,strong) orderTitleView *titleView;

@property(nonatomic ,strong) UIView *headView;//头部图片

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBarAppearence];
    
    
    headViewHeight = UINavBar_Height+W_In_375(1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTitleView];
    [self createButtomView];
    [self createFooterView];
}
- (void)setNavBarAppearence
{
    //    UIColor *textColor = [UIColor colorWithRed:207.00/255.0 green:48.00/255.0 blue:26.00/255.0 alpha:1];
    //    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:redMainColor];
    //    // 设置导航栏标题默认颜色
    //    [WRNavigationBar wr_setDefaultNavBarTitleColor:textColor];
    //    // 统一设置状态栏样式
    //    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
//    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    [self wr_setNavBarShadowImageHidden:YES];
}
-(void)createButtomView{
    
    UIView   * rightView = [TokeyViewTools createViewWithFrame:CGRectMake(0, 0, 70, 30) andBgColor:nil];
    
    UIButton * searchBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(0, 5, 21, 21) andImage:[UIImage imageNamed:@"nav_btn_icon_s"] andSelecter:@selector(searchButon) andTarget:self];
    [rightView addSubview:searchBtn];
    
    UIButton * moreBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(searchBtn.frame)+W_In_375(20), 5, 20, 20) andImage:[UIImage imageNamed:@"nav_btn_icon_set"] andSelecter:@selector(moreBtnCheck) andTarget:self];
    [rightView addSubview:moreBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    UIButton * leftBtn = [TokeyViewTools createButtonWithFrame:CGRectMake(0, 0, 20, 18) andImage:[UIImage imageNamed:@"nav_btn_icon_m"] andSelecter:@selector(myInfoData) andTarget:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    
    
}

-(void)createFooterView{
    UIImageView *footImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-2, screen_height - 49, screen_width+4, 49)];
    //footImageView.image = [UIImage imageNamed:@"bg"];
    footImageView.backgroundColor = rgb(35, 35, 35);
    [self.view addSubview:footImageView];
    
    
    float centerbuttonSize = 70.0;
    UIButton * centerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    centerbutton.frame = CGRectMake((screen_width-centerbuttonSize)/2.0, screen_height-centerbuttonSize, centerbuttonSize, centerbuttonSize);
    centerbutton.layer.cornerRadius = 25;
    centerbutton.clipsToBounds = YES;
    //[centerbutton setBackgroundColor:[UIColor colorWithRed:49/255.0 green:231/255.0 blue:165/255.0 alpha:1]];
    [centerbutton setBackgroundImage:[UIImage imageNamed:@"base"] forState:UIControlStateNormal];
    
    [centerbutton setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [centerbutton addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerbutton];
    
    [centerbutton setRoundView];
    [centerbutton setBorderWidth:10.0 borderColor:footImageView.backgroundColor];
}

//录制视频
-(void)cameraClick:(UIButton *)btn{
    [self setBackNav];
//    NSString *mediaType = AVMediaTypeVideo;
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//        [self.view makeToast:@"没有相机权限,请在手机设置中打开" duration:1 position:CSToastPositionCenter];
//        return;
//    }
//    XYCameraMainViewController * camrra = [[XYCameraMainViewController alloc]init];
//    [self.navigationController pushViewController:camrra animated:YES];
    
}

-(void)createTitleView{
    [self.view addSubview:self.mainTableView];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mainScrollView.bounces = NO;
    //    [self.view addSubview:self.mainScrollView];
    //    [self.mainScrollView addSubview:self.setPageViewControllers];
}

#pragma scrollDelegate
-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    //离开顶部 主View 可以滑动
    self.parentScrollView.scrollEnabled = YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取滚动视图y值的偏移量
    CGFloat tabOffsetY = [self.mainTableView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    NSLog(@"%f",self.mainTableView.contentOffset.y);
    if (self.mainTableView.contentOffset.y <= 0) {
        
        self.mainTableView.bounces = NO;
        
        NSLog(@"禁止下拉");
    }else if (self.mainTableView.contentOffset.y >= 0){
        self.mainTableView.bounces = YES;
        NSLog(@"允许上拉");
        
    }
    
    if (offsetY>=tabOffsetY){
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.parentScrollView.scrollEnabled = YES;
    }else{
        
    }
    
    /**
     * 处理头部视图
     */
    CGFloat yOffset  = scrollView.contentOffset.y;
    if(yOffset < -headViewHeight) {
        
        CGRect f =  self.headView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        f.origin.y= yOffset;
        
        //改变头部视图的fram
        self.headView.frame= f;
        //  CGRect avatarF = CGRectMake(f.size.width/2-40, (f.size.height-headViewHeight)+56, 80, 80);
        // _avatarImage.frame = avatarF;
        // _countentLabel.frame = CGRectMake((f.size.width-Main_Screen_Width)/2+40, (f.size.height-headViewHeight)+172, Main_Screen_Width-80, 36);
    }
    if(offsetY<0){
        CGFloat y = - offsetY - 44;
        if(y>20){
            y = 20;
        }
        
        XYLog(@"=========%.2f****%.2f",offsetY,y);
        CGRect rect = self.navigationController.navigationBar.frame;
        rect.origin.y = y;
        self.navigationController.navigationBar.frame = rect;
      
    }else{
        XYLog(@"<<<<<%.2f",offsetY);
        CGFloat y   = -68;
        CGRect rect = self.navigationController.navigationBar.frame;
        rect.origin.y = y;
        self.navigationController.navigationBar.frame = rect;
    }
}
-(void)showMenu{
//    if (self.popView==nil) {
//        //@{@"title":@"添加好友" , @"iconName":@"tjhy_icon"
//        NSArray *dictArr = @[@{@"title":@"创建群聊", @"iconName":@"cjql_icon"}];
//
//        self.popView = [XYPopView popViewWithFuncDicts:dictArr];
//        self.popView.x = self.view.width-20-150;
//        __weak typeof (self) weakSelf = self;
//
//        self.popView.menuSelectBlock = ^(NSInteger index){
//
//            XYLog(@"<----------------------------->%ld", index);
//            [weakSelf.popView dismissFromKeyWindow];
//            if (index == 0) {
//                qunmingViewController * invite = [[qunmingViewController alloc]init];
//                invite.arr = [[XYDataCore sharedDataCore] getUserAllFriend];
//                [weakSelf.navigationController pushViewController:invite animated:YES];
//            }
//            if (index == 1) {
//                addFriViewController *addvc = [[addFriViewController alloc] init];
//                [weakSelf.navigationController pushViewController:addvc animated:YES];
//            }
//
//
//        };
//    }
//    self.popView.x = self.view.width-20-150;
//    if (self.popView.isShow) {
//        return;
//    }
//    [self.popView showInView:self.view];
}
#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return screen_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}


#pragma mark -- setter/getter

-(UIView *)setPageViewControllers
{
    WMPageController *pageController = [self p_defaultController];
    pageController.title = @"Line";
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeSelected = 15;
    
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    
    TKChatListViewController *oneTable = [[TKChatListViewController alloc] init];
    //oneTable.delegate =self;
    _chatListViewController = oneTable;

    TKContactsViewController *twoTable = [[TKContactsViewController alloc] init];
    //twoTable.delegate = self;
    _contactsViewController = twoTable;
    
    NSArray *viewControllers = @[TKChatListViewController.class,TKContactsViewController.class];
    //WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:@[@"聊天",@"联系人"]];
    //[pageVC setViewFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //pageVC.view.frame =CGRectMake(0, 0, screen_width, screen_height);
    
    WMPageController *pageVC = [[WMPageController alloc] init];
    pageVC.dataSource = self;
    pageVC.delegate = self;
    pageVC.titleColorSelected = redMainColor;
    pageVC.titleColorNormal = rgb(101, 101, 101);
    pageVC.menuItemWidth = 85;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    
//    pageVC.m = [UIColor whiteColor];
    
    return pageVC;
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    XYLog(@"%@",viewController);
}

-(UIView *)headView
{
    if (_headView == nil)
    {
        _headView= [[UIView alloc]initWithFrame:CGRectMake(0, -headViewHeight,screen_width,headViewHeight)];
        _headView.backgroundColor = [UIColor redColor];
    }
    return _headView;
}

-(MainTouchTableView *)mainTableView
{
    if (_mainTableView == nil)
    {
        _mainTableView= [[MainTouchTableView alloc]initWithFrame:CGRectMake(0,0,screen_width,screen_height)];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.backgroundColor = [UIColor whiteColor];
    }
    return _mainTableView;
}
-(UIScrollView *)mainScrollView{
    if(!_mainScrollView){
        _mainScrollView = [[MainTouchScrollView alloc] initWithFrame:CGRectMake(0,0,screen_width,screen_height)];
        _mainScrollView.delegate = self;
    }
    _mainScrollView.contentSize = CGSizeMake(screen_width, screen_width);
    return _mainScrollView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.delegate){
        [self.delegate homeViewController:self closeBtnClicked:nil];
    }
}
//资料
- (void)myInfoData{
    //    [self setBackNav];
    //    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    if(self.delegate){
        [self.delegate homeViewController:self leftBtnClicked:nil];
    }
}
//搜索
- (void)searchButon{
    //    [self setBackNav];
    //    /*
    //    searchViewController * sear = [[searchViewController alloc]init];
    //    [self.navigationController pushViewController:sear animated:YES];
    //    */
    //    [self showMenu];
    
//    SearchViewController * sear = [[SearchViewController alloc]init];
//    [self.navigationController pushViewController:sear animated:YES];
}
-(void)moreBtnCheck{
    [self setBackNav];
    [self showMenu];
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
#pragma mark WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index==0) {
        return _chatListViewController;
    }
    return _contactsViewController;
}
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    if (index==0) {
        return @"会话";
    }
    return @"联系人";
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    CGFloat menuViewHeight = 44;
    CGFloat height = screen_height - menuViewHeight - 64;
    return CGRectMake(0, menuViewHeight, screen_width, height);
}
-(CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, 0, screen_width, 44);
}
@end
