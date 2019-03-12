//
//  TKGroupNoticeViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/12.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKGroupNoticeViewController.h"
#import "TKGroupNoticeEditViewController.h"
#import "TKGroupNotiTableViewCell.h"
#import "TKGroupNotiModel.h"
#import "TKTeamAction.h"

@interface TKGroupNoticeViewController ()<TKGroupNoticeEditViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UILabel * label;
@property (nonatomic,copy)NSString * groupnoti;//群公告
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation TKGroupNoticeViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群公告";
    self.dataArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRightItem];
    [self createText];
    [self createData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(freshNoti) name:@"freshNoti" object:nil];
    // Do any additional setup after loading the view.
}

-(void)freshNoti{
    
    if (self.dataArr.count>0) {
        [self.dataArr removeAllObjects];
    }
    
    [self createData];
}
#pragma mark - 添加右边按钮
-(void)addRightItem{
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(0, 0, 40, 30);
    [releaseButton setTitle:@"新建" forState:normal];
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseButton.layer.cornerRadius = 3;
    [releaseButton setBackgroundColor:blcolor];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
}

-(void)createText{
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, screen_width, 200)];
    _label.numberOfLines = 0;
    _label.text = @"没有公告内容!";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:_label];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UINavBar_Height, screen_width, screen_height-UINavBar_Height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TKGroupNotiTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupNotiID"];
    if (@available(iOS 11.0, *)){
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

-(void)releaseInfo{
    
    if([[TKUserSetting sharedManager].username isEqualToString:_groupowner]){
        
        TKGroupNoticeEditViewController * xiu = [[TKGroupNoticeEditViewController alloc]init];
        xiu.groupID = _groupID;
        xiu.delegate = self;
        [self.navigationController pushViewController:xiu animated:YES];
    }else{
        
        UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你不是群主" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [aler show];
        
    }
    
}

-(void)sendnotiwith:(NSString *)string{
    
    _label.text = string;
    
}

-(void)createData{
    
    
    [TKTeamAction noticeList:self.groupID respose:^(NSArray<TKGroupNotiModel *> *notiModels, NSString *aMessage) {
        if(notiModels!=nil){
            [self.dataArr addObjectsFromArray:notiModels];
            if(self.dataArr.count>0){
                
                self.label.hidden = YES;
                self.tableView.hidden = NO;
            }else{
                
                self.label.hidden = NO;
                self.tableView.hidden = YES;
                
            }
            [self.tableView reloadData];
        }else{
            
            [XYHUDCore showErrorWithStatus:aMessage];
        }
    }];
    
    
}

#pragma mark ----------tableDelegate---------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArr.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TKGroupNotiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"groupNotiID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    TKGroupNotiModel * model = self.dataArr[indexPath.section];
    
    [cell loadDatafrom:model];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TKGroupNotiModel * model = self.dataArr[indexPath.section];
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;
    return 140.0+size.height-50;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
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
