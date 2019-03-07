//
//  MainSlideViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "MainSlideViewController.h"
#import "HomeViewController.h"
#import "DrawerLeftViewController.h"
#import "TKNavigationController.h"
#import "WRNavigationBar.h"
#import "TKPersonDataViewController.h"

typedef enum State {
    kStateHome,
    kStateMenu
}State;

static const CGFloat viewSlideHorizonRatio = 0.75;
static const CGFloat viewHeightNarrowRatio = 0.80;
static const CGFloat menuStartNarrowRatio  = 0.70;

@interface MainSlideViewController ()<HomeViewControllerDelegate,DrawerLeftViewControllerDelegate>

@property (assign, nonatomic) State   state;              // 状态(Home or Menu)
@property (assign, nonatomic) CGFloat distance;         // 距离左边的边距
@property (assign, nonatomic) CGFloat leftDistance;
@property (assign, nonatomic) CGFloat menuCenterXStart; // menu起始中点的X
@property (assign, nonatomic) CGFloat menuCenterXEnd;   // menu缩放结束中点的X
@property (assign, nonatomic) CGFloat panStartX;        // 拖动开始的x值


@property (strong, nonatomic) HomeViewController        *homeVC;
@property (strong, nonatomic) DrawerLeftViewController  *menuVC;
@property (strong, nonatomic) TKNavigationController    *messageNav;

@property (strong, nonatomic) UIView               *cover;

@property (strong, nonatomic) UIControl            *homeTouchView;

@end

@implementation MainSlideViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    XYLog(@"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    self.state = kStateHome;
    self.distance = 0;
    self.menuCenterXStart = screen_width * menuStartNarrowRatio / 2.0;
    self.menuCenterXEnd = self.view.center.x;
    self.leftDistance = screen_width * viewSlideHorizonRatio;
    
    // 设置遮盖
    self.cover = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.cover.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.cover];
    
    // 设置menu的view
    self.menuVC = [[DrawerLeftViewController alloc] init];
    self.menuVC.delegate = self;
    self.menuVC.view.frame = [[UIScreen mainScreen] bounds];
    self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuStartNarrowRatio, menuStartNarrowRatio);
    self.menuVC.view.center = CGPointMake(self.menuCenterXStart, self.menuVC.view.center.y);
    [self.view addSubview:self.menuVC.view];
    
    
    
    // 添加tabBarController
    //self.tabBarController = [[UITabBarController alloc] init];
    
    self.homeVC = [[HomeViewController alloc] init];
    self.homeVC.view.frame = [[UIScreen mainScreen] bounds];
    self.homeVC.delegate = self;
    
    // 设置控制器的状态，添加手势操作
    self.messageNav = [[TKNavigationController alloc] initWithRootViewController:self.homeVC];
    
    [self.view addSubview:self.messageNav.view];
    
    self.menuVC.delegate = self;
    
    self.messageNav.view.width = screen_width;
}

/**
 *  处理拖动事件
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 当滑动水平X大于75时禁止滑动
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartX = [recognizer locationInView:self.view].x;
    }
    if (self.state == kStateHome && self.panStartX >= 75) {
        return;
    }
    
    CGFloat x = [recognizer translationInView:self.view].x;
    // 禁止在主界面的时候向左滑动
    if (self.state == kStateHome && x < 0) {
        return;
    }
    
    CGFloat dis = self.distance + x;
    // 当手势停止时执行操作
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (dis >= screen_width * viewSlideHorizonRatio / 2.0) {
            [self showMenu];
        } else {
            [self showHome];
        }
        return;
    }
    
    CGFloat proportion = (viewHeightNarrowRatio - 1) * dis / self.leftDistance + 1;
    if (proportion < viewHeightNarrowRatio || proportion > 1) {
        return;
    }
    self.messageNav.view.center = CGPointMake(self.view.center.x + dis, self.view.center.y);
    self.messageNav.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    
    //self.homeVC.leftBtn.alpha = self.cover.alpha = 1 - dis / self.leftDistance;
    
    CGFloat menuProportion = dis * (1 - menuStartNarrowRatio) / self.leftDistance + menuStartNarrowRatio;
    CGFloat menuCenterMove = dis * (self.menuCenterXEnd - self.menuCenterXStart) / self.leftDistance;
    self.menuVC.view.center = CGPointMake(self.menuCenterXStart + menuCenterMove, self.view.center.y);
    self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
}
-(void)touchViewCheck:(UIControl*)sender{
    [_homeTouchView removeFromSuperview];
    [self showHome];
}
/**
 *  展示侧边栏
 */
- (void)showMenu {
    if(_homeTouchView==nil){
        _homeTouchView = [[UIControl alloc] initWithFrame:self.messageNav.view.bounds];
        _homeTouchView.userInteractionEnabled = YES;
        _homeTouchView.backgroundColor = [UIColor clearColor];
        [_homeTouchView addTarget:self action:@selector(touchViewCheck:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.messageNav.view addSubview:_homeTouchView];
    
    self.distance = self.leftDistance;
    self.state = kStateMenu;
    [self doSlide:viewHeightNarrowRatio];
}

/**
 *  展示主界面
 */
- (void)showHome {
    self.distance = 0;
    self.state = kStateHome;
    [self doSlide:1];
}

/**
 *  实施自动滑动
 *
 *  @param proportion 滑动比例
 */
- (void)doSlide:(CGFloat)proportion {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.messageNav.view.center = CGPointMake(self.view.center.x + self.distance, self.view.center.y);
        self.messageNav.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
        
        //self.homeVC.leftBtn.alpha = self.cover.alpha = proportion == 1 ? 1 : 0;
        
        CGFloat menuCenterX;
        CGFloat menuProportion;
        if (proportion == 1) {
            menuCenterX = self.menuCenterXStart;
            menuProportion = menuStartNarrowRatio;
        } else {
            menuCenterX = self.menuCenterXEnd;
            menuProportion = 1;
        }
        self.menuVC.view.center = CGPointMake(menuCenterX, self.view.center.y);
        self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
        
        self.messageNav.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.messageNav.view.layer.shadowOffset = CGSizeMake(-5, 0);
        self.messageNav.view.layer.shadowOpacity = 1.2;
        self.messageNav.view.layer.shadowRadius = 5;
        
    } completion:^(BOOL finished) {
        if (self.state == kStateHome) {
            [self.homeVC wr_setNavBarShadowImageHidden:YES];
        }
    }];
}

#pragma mark - HomeViewController代理方法
- (void)homeViewController:(HomeViewController *)homeVC leftBtnClicked:(id)sender{
    [self showMenu];
}
- (void)homeViewController:(HomeViewController *)homeVC closeBtnClicked:(id)sender{
    [self showHome];
}
#pragma mark DrawerLeftViewContrllerDeleagate
-(void)drawerLeftViewController:(DrawerLeftViewController *)drawerVC appCenterClicked:(id)sender{
    
}
-(void)drawerLeftViewController:(DrawerLeftViewController *)drawerVC userHeaderClicked:(id)sender{
    [self showHome];
    TKPersonDataViewController * person = [[TKPersonDataViewController alloc]init];
    person.isJump = YES;
    [self.messageNav pushViewController:person animated:YES];
}
#pragma mark - WMMenuViewController代理方法
- (void)didSelectItem:(NSString *)title {
}
@end
