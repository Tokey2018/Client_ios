//
//  TKInviteViewController.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKInviteViewController : UIViewController

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSString * titleStr;
@property (nonatomic,assign)BOOL isVideo;//是否是分享视频
@property (nonatomic,copy)NSString * pathStr;
@property (nonatomic,assign)BOOL isYaoqin;//是否是邀请好友
@property (nonatomic,assign)BOOL isLaren;
@property (nonatomic,assign)BOOL isShare;//是否分享
@property (nonatomic,copy)NSString * urlString;//分享地址
@property (nonatomic,copy)NSString * groupID;
@property (nonatomic,assign)NSInteger groupNum;//区分是否需要群信息;
@property (nonatomic,assign)BOOL isreateGroup;
@property (nonatomic,copy)NSString *nameTitle;//文档分享标题
@property (nonatomic,copy)NSString *time;//文档分享时间
@property (nonatomic,assign)BOOL isBaochun;//
@property (nonatomic,strong)NSMutableArray * picDataArr;

@end

