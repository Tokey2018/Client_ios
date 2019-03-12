//
//  XYFuncModel.m
//  FUGenealogySDK
//
//  Created by 杨卢银 on 16/8/29.
//  Copyright © 2016年 杨卢银. All rights reserved.
//

#import "XYFuncModel.h"

@implementation XYFuncModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
