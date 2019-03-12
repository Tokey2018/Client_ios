//
//  TKDoctorInfoViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKDoctorInfoViewController.h"
#import "TKUserAction.h"
#import "TKDocHeaderTableViewCell.h"
#import "TKChatInfoViewController.h"
#import "TKContactsAction.h"

@interface TKDoctorInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    NSString * string;
    TKXGModel * xmodel;
    UIButton * button;
}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation TKDoctorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生详情";
    string =@"";
    self.view.backgroundColor = backcolor;
    [self createData];
    // Do any additional setup after loading the view.
}

-(void)createData{
    
    
    [TKUserAction userInfo:[TKUserSetting sharedManager].username otherUid:self.model.uid respose:^(TKXGModel *xgModel, NSString *aMessage) {
        if (xgModel!=nil) {
            self->xmodel = xgModel;
            [self createUI];
        }
    }];
    
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UINavBar_Height, screen_width, screen_height-UINavBar_Height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TKDocHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"docHeadCell"];
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
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        
        TKDocHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"docHeadCell"];
        cell.docName.text = xmodel.nick;
        [cell.headImage tk_setImageWithURL:HTTP_URL(xmodel.userImg) placeholderImage:[UIImage imageNamed:@"User"]];
        return cell;
    }else if(indexPath.row==4){
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(xmodel.sickSkill!=nil){
            cell.textLabel.numberOfLines = 0;
            string = xmodel.sickSkill;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"擅长: %@",xmodel.sickSkill]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,3)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
            cell.textLabel.attributedText =str;
        }else{
            cell.textLabel.text = @"擅长暂无";
        }
        return cell;
    }else if(indexPath.row==1){
        //  NSLog(@"%@",xmodel.aname);
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        //cell.textLabel.text = @"医院:和第三代";
        if(xmodel.office!=nil){
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"医院: %@",xmodel.office]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,3)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
            cell.textLabel.attributedText =str;
        }else{
            cell.textLabel.text = @"医院暂无";
        }
        
        return cell;
        
    }else if(indexPath.row==2){
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        //cell.textLabel.text = @"医院:和第三代";
        if(xmodel.dname!=nil){
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"科室: %@",xmodel.dname]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,3)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
            cell.textLabel.attributedText =str;
        }else{
            
            cell.textLabel.text = @"科室暂无";
            
        }
        
        return cell;
        
        
    }else {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(xmodel.aname!=nil){
            //cell.textLabel.text = @"医院:和第三代";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"职称: %@",xmodel.aname]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,3)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
            cell.textLabel.attributedText =str;
        }else{
            cell.textLabel.text = @"职称暂无";
        }
        
        return cell;
        
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        return 80.0;
    }else if(indexPath.row==4){
        CGSize size;
        size = [string boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;
        return size.height+30;
        
    }else{
        return 44.0;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 60)];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 10, screen_width-40, 40);
    [button setBackgroundColor:blcolor];
    [button setTitle:xmodel.isFriend.integerValue==1?@"聊天":@"加为好友" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [button setTintColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 4;
    [footview addSubview:button];
    return footview;
}

-(void)addFriend{
    
    if(xmodel.isFriend.integerValue==1){
        TKChatInfoViewController * chatInfo = [[TKChatInfoViewController alloc]init];
        chatInfo.userID = xmodel.accid;
        chatInfo.nameStr = xmodel.nick;
        NIMSession *session = [NIMSession session:xmodel.accid type:NIMSessionTypeP2P];
        chatInfo.session = session;
        [self.navigationController pushViewController:chatInfo animated:YES];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否添加%@为好友",xmodel.realName]delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 60.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
//    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
//    [parms setValue:[TKUserSetting sharedManager].username forKey:@"accid"];
//    [parms setValue:xmodel.accid forKey:@"faccid"];
//    [HttpRequest newPostWithURL:HTTP_URL(imperson_addOneFriend) params:parms andNeedHub:YES success:^(id responseObject) {
//        [XYHUDCore showSuccessWithStatus:@"添加该好友成功!"];
//        [button setBackgroundColor:[UIColor grayColor]];
//        button.userInteractionEnabled = NO;
//    } failure:^(NSError *error) {
//
//    }];
    [TKContactsAction addOneFriend:[TKUserSetting sharedManager].username faccid:xmodel.accid respose:^(BOOL aSuccess, NSString *aMessage) {
        if (aSuccess) {
            [XYHUDCore showSuccessWithStatus:@"添加该好友成功!"];
            [button setBackgroundColor:[UIColor grayColor]];
            button.userInteractionEnabled = NO;
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
