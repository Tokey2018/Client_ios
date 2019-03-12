//
//  TKAddFriendViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKAddFriendViewController.h"
#import "TKDocModel.h"
#import "TKAddFriendTableViewCell.h"
#import "TKDoctorInfoViewController.h"
#import "TKContactsAction.h"

@interface TKAddFriendViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,TKAddFriendTableViewCellDelegate,UIAlertViewDelegate,UIScrollViewDelegate>{
    
    NSInteger pageNum;
    // NSMutableArray * dataArr;
    NSArray *menuData;
}
@property (nonatomic,strong)UITextField * textField;//搜索
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)TKDocModel * dModel;
@end

@implementation TKAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    pageNum = 1;
    self.dataArr = [NSMutableArray array];
    self.view.backgroundColor = backcolor;
    
    //    menuData = @[@{@"title":@"扫一扫",@"icon":@"chat_icon2"},
    //                 @{@"title":@"手机通讯录",@"icon":@"chat_icon4"},
    //                 @{@"title":@"同院同科",@"icon":@"chat_icon1"},
    //                 @{@"title":@"推荐医生",@"icon":@"chat_icon"},];
    
    [self createUI];
    [self createTab];
    
}

-(void)createUI{
    UIView * seachView = [[UIView alloc]init];
    seachView.frame = CGRectMake(0, UINavBar_Height+20, screen_width, 44);
    seachView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:seachView];
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 26, 26)];
    imageview.image = [UIImage imageNamed:@"搜索"];
    [seachView addSubview:imageview];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(45, 9, screen_width-50, 26)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:_textField];
    _textField.placeholder = @"医生姓名/手机号/ID";
    [seachView addSubview:_textField];
}
#pragma mark -- 输入监听
-(void)textFieldDidChange{
    [self loadData];
}

-(void)loadData{
    if(_textField.text.length==0){
        
        [_tableView reloadData];
        
        return;
    }
//    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
//    [parms setValue:_textField.text forKey:@"keyword"];
//    [HttpRequest newGetWithURL:HTTP_URL(imperson_findByKeyword) params:parms andNeedHub:YES success:^(id responseObject) {
//        searchPeopleNewModel * model = [searchPeopleNewModel mj_objectWithKeyValues:responseObject[@"data"]];
//        if(model.user){
//            if(self.dataArr.count>0){
//                [self.dataArr removeAllObjects];
//            }
//            [self.dataArr addObject:model.user];
//            [_tableView reloadData];
//        }
//    } failure:^(NSError *error) {
//
//    }];
    
    [TKContactsAction findByKeyword:_textField.text respose:^(TKSearchPeopleModel *searchModel, NSString *aMessage) {
        if (searchModel ) {
            if(searchModel.user){
                if(self.dataArr.count>0){
                    [self.dataArr removeAllObjects];
                }
                [self.dataArr addObject:searchModel.user];
                [_tableView reloadData];
            }
        }
    }];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
}

#pragma mark -- tableView
-(void)createTab{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,UINavBar_Height+20+44+20, screen_width, screen_height-54-UINavBar_Height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"addFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"addFriCell"];
    if(@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_textField.text.length==0){
        return menuData.count;
    }
    return self.dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_textField.text.length==0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *info = menuData[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:info[@"icon"]];
        cell.textLabel.text = info[@"title"];
        return cell;
    }
    TKAddFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addFriCell"];
    TKDocModel * model = self.dataArr[indexPath.row];
    cell.name.text = model.realName;
    if(!model.office){
        cell.zhicheng.text = @"职称暂无";
    }else{
        cell.zhicheng.text = model.office;
    }
    if(model.dname){
        cell.section.text = model.dname;
    }else{
        cell.section.text = @"部门暂无";
    }
    if(model.aname){
        cell.hospital.text = model.aname;
    }else{
        
        cell.hospital.text = @"医院暂无";
    }
    cell.addFriend.tag = indexPath.row;
    cell.delegate = self;
    [cell.headImage tk_setImageWithURL:model.userImg placeholderImage:[UIImage imageNamed:@"默认头像"]];
    //cell
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_textField.text.length==0){
        return 44;
    }
    return 100.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1.0;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_textField.text.length==0){
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_textField resignFirstResponder];
    TKDoctorInfoViewController * doc = [[TKDoctorInfoViewController alloc]init];
    TKDocModel * model = self.dataArr[indexPath.row];
    doc.model = model;
    [self.navigationController pushViewController:doc animated:YES];
}

#pragma mark - addFriDelegte
-(void)addFriendTableViewCell:(TKAddFriendTableViewCell *)aCell addMyFriend:(NSInteger)num{
    _dModel = self.dataArr[num];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否添加%@为好友",_dModel.realName]delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    
}
#pragma mark -- alertViewdelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self loadAddfri];
            break;
        default:
            break;
    }
    
    
    
}

-(void)loadAddfri{
    
    
    
    [TKContactsAction addOneFriend:[TKUserSetting sharedManager].username faccid:_dModel.accid respose:^(BOOL aSuccess, NSString *aMessage) {
        if (aSuccess) {
            [XYHUDCore showSuccessWithStatus:@"添加该好友成功!"];
            self.textField.text = @"";
            [self.dataArr removeAllObjects];
            [self.tableView reloadData];
        }
    }];
    
   
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
