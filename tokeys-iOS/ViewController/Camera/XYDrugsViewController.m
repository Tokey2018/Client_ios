//
//  XYDrugsViewController.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/28.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "XYDrugsViewController.h"
#import "XYDrugsViewCell.h"
#import "XYDrugsInfoViewController.h"

@interface XYDrugsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;

@end

@implementation XYDrugsViewController

- (void)dismiss{
    _shopButton.hidden = NO;
    _bgImageView.hidden = NO;
    _bgLabel.hidden = NO;
    [self.rootVC openMenu];
    
    
    self.rootVC.navigationController.navigationBarHidden = YES;
    //self.rootVC.title = @"医药";
    self.rootVC.scrollView.scrollEnabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    
    _dataArray = @[@{@"title":@"体检",@"icon":@"d_tj_icon",@"url":@"http://juju.tokeys.com/types/t000011"},
                   @{@"title":@"健康方案",@"icon":@"d_jkfa_icon",@"url":@"http://juju.tokeys.com/types/t000012"},
                   @{@"title":@"药品",@"icon":@"d_yp_icon",@"url":@"http://juju.tokeys.com/types/t000014"},
                   @{@"title":@"医药器材",@"icon":@"d_yyqc_icon",@"url":@"http://juju.tokeys.com/types/t000015"},
                   @{@"title":@"男人专享",@"icon":@"d_nrzx_icon",@"url":@"http://juju.tokeys.com/types/t000016"},
                   @{@"title":@"孕娘VIP特权",@"icon":@"dy_ynvip_icon",@"url":@"http://juju.tokeys.com/types/t000018"}];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = v;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"XYDrugsViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYDrugsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *info = _dataArray[indexPath.row];
    cell.showImage = [UIImage imageNamed:info[@"icon"]];
    cell.showTitle = info[@"title"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *info = _dataArray[indexPath.row];
    NSString *url = info[@"url"];
    NSString *title = info[@"title"];
    
    XYDrugsInfoViewController *vc = [[XYDrugsInfoViewController alloc] init];
    vc.title = title;
    vc.url = url;
    [self.rootVC.navigationController pushViewController:vc animated:YES];
}


- (IBAction)shopButtonSelect:(id)sender {
    _shopButton.hidden = YES;
    _bgImageView.hidden = YES;
    _bgLabel.hidden = YES;
    [self.rootVC dismissMenu];
    self.rootVC.navigationController.navigationBarHidden = NO;
    self.rootVC.title = @"医药";
    self.rootVC.scrollView.scrollEnabled = NO;
    
}
@end
