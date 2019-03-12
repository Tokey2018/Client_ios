//
//  XYFuncModel.h
//  FUGenealogySDK
//
//  Created by 杨卢银 on 16/8/29.
//  Copyright © 2016年 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYFuncModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
