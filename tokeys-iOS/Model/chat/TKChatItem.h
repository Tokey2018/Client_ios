//
//  TKChatItem.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TKChatItem : NSObject

@property (nonatomic,assign)BOOL isByself;//是否为自定义消息
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, copy) NSString* content;//文本内容
@property (nonatomic,strong)UIImage * image;//图片
@property (nonatomic,assign)BOOL isVideo;//是否为视屏
@property (nonatomic,copy)NSString * videoUrl;//视频地址
@property (nonatomic,strong)NIMMessage * message;
@property (nonatomic,copy)NSString *sendName;//发送消息者昵称

@end

