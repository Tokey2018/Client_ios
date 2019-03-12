//
//  TKSelectPeople.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TKSelectPeople : NSObject

@property (nonatomic,copy)NSString * name;

@property (nonatomic,copy)NSString * infoNme;

@property (nonatomic,copy)NSString * phone;//电话

@property (nonatomic,assign)BOOL isSele;//无用参数

@property (nonatomic,copy)NSString * img;

@property (nonatomic,assign)BOOL isGroup;//是否为群组

@property (nonatomic,assign)BOOL isWendang;

@end

