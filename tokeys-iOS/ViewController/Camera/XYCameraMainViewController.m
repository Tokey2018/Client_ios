//
//  XYCameraMainViewController.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/28.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "XYCameraMainViewController.h"
#import "XYCameraViewController.h"
#import "XYDrugsViewController.h"
#import "WRNavigationBar.h"

@interface XYCameraMainViewController ()<UIScrollViewDelegate>

@property (strong , nonatomic) XYCameraViewController *cameraVC;

@property (strong , nonatomic) XYDrugsViewController  *drugsVC;



@property (weak, nonatomic) IBOutlet UIButton *jiuzhenBT;
@property (weak, nonatomic) IBOutlet UIButton *xiangjiBT;
@property (weak, nonatomic) IBOutlet UIButton *yaopingBT;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) IBOutlet UIButton *changeCameraBT;

@end

@implementation XYCameraMainViewController

-(void)drugs_rightButtonSelect:(id)sender{
    [_drugsVC dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    UIBarButtonItem *leftbarBT = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"camera_x_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(drugs_rightButtonSelect:)];
    self.navigationItem.leftBarButtonItem = leftbarBT;
    
    self.navigationController.navigationBarHidden = YES;
    
    //[self wr_setNavBarBarTintColor:[UIColor clearColor]];
    
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.scrollView.frame = self.view.bounds;
    self.scrollView.delegate = self;
    
    _ButtonView.alpha = 0.5;
    _ButtonView.backgroundColor = [UIColor clearColor];
    
    [_xiangjiBT setBackgroundImage:[UIImage xy_createImageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [_xiangjiBT setBackgroundImage:[UIImage xy_createImageWithColor:blcolor] forState:UIControlStateSelected];
    [_xiangjiBT setRoundView];
    _xiangjiBT.selected = YES;
    
    [_jiuzhenBT setBackgroundImage:[UIImage xy_createImageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [_jiuzhenBT setBackgroundImage:[UIImage xy_createImageWithColor:blcolor] forState:UIControlStateSelected];
    [_jiuzhenBT setRoundView];
    [_yaopingBT setBackgroundImage:[UIImage xy_createImageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [_yaopingBT setBackgroundImage:[UIImage xy_createImageWithColor:blcolor] forState:UIControlStateSelected];
    [_yaopingBT setRoundView];

    [self buildSubView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)buildSubView{
    _cameraVC = [[XYCameraViewController alloc] init];
    _cameraVC.view.frame = _scrollView.bounds;
    _cameraVC.view.y = -20;
    _cameraVC.rootVC = self;
    [_scrollView addSubview:_cameraVC.view];
    
    _drugsVC  = [[XYDrugsViewController alloc] init];
    _drugsVC.view.frame = _scrollView.bounds;
    _drugsVC.view.y = -20;
    _drugsVC.view.x = _scrollView.width;
    _drugsVC.rootVC = self;
    [_scrollView addSubview:_drugsVC.view];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width*2, 0);
    _scrollView.pagingEnabled = YES;
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
- (IBAction)photoCheck:(id)sender {
    [_cameraVC cameraExchange:sender];
}

- (IBAction)backBTCheck:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger tag = self.scrollView.contentOffset.x/self.scrollView.width;
    if (tag==1) {
        _xiangjiBT.selected = NO;
        _yaopingBT.selected = YES;
    }else{
        _xiangjiBT.selected = YES;
        _yaopingBT.selected = NO;
    }
    _changeCameraBT.hidden = !_xiangjiBT.selected;
}
- (IBAction)bottonBTSelect:(UIButton *)sender {
    NSInteger tag = 0;
    if (sender == _xiangjiBT) {
        tag = 0;
    }else if (sender == _yaopingBT) {
        tag = 1;
    }
    if (tag==1) {
        _xiangjiBT.selected = NO;
        _yaopingBT.selected = YES;
    }else{
        _xiangjiBT.selected = YES;
        _yaopingBT.selected = NO;
    }
    _changeCameraBT.hidden = !_xiangjiBT.selected;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width*tag, -20);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)openMenu{
    _ButtonView.hidden = NO;
}
-(void)dismissMenu{
    _ButtonView.hidden = YES;
}
@end
