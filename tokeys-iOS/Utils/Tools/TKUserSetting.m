//
//  TKUserSetting.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKUserSetting.h"
#import <objc/runtime.h>

#define TKUserDefaults       [NSUserDefaults standardUserDefaults]

@implementation TKUserSetting

/**
 *  单例呼出方法
 */
+ (TKUserSetting*)sharedManager
{
    static TKUserSetting *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance)
        {
            sharedInstance = [[self alloc] init];
            //读取存储数据
            [sharedInstance readWithNSUserDefault];
        }
    });
    return sharedInstance;
}

-(id)init
{
    
    if(self=[super init])
    {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
            NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            if([propertyAttribute hasPrefix:@"T@\"NSString\","]){
                [self setValue:@"" forKey:key];
            }
            if([propertyAttribute hasPrefix:@"Tq,"]){
                [self setValue:[NSNumber numberWithInt:0] forKey:key];
            }
            if([propertyAttribute hasPrefix:@"TB,"]){
                [self setValue:[NSNumber numberWithInt:0] forKey:key];
            }
            //NSLog(@"propertyAttribute %@",propertyAttribute);
            
        }
        free(properties);
    }
    
    return self;
}

/**
 *  从userdefaults中读取设置信息
 */
- (void)readWithNSUserDefault
{
    NSString *strClassName = NSStringFromClass([self class]);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *bundleId = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([TKUserSetting class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        
        NSString *strKey = [NSString stringWithFormat:@"%@-%@-%@",bundleId,strClassName,key];
        
        id obj = [TKUserDefaults objectForKey:strKey];
        if (obj)
        {
            [self setValue:obj forKeyPath:key];
        }
    }
    free(properties);
    [self kvoWithProperties];
}

/**
 *  KVO方式监听值的变化
 */
- (void)kvoWithProperties
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([TKUserSetting class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    free(properties);
}

/**
 *   KVO方式监听值的变化，然后存储到Userdefault
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self writeWithNSUserDefault:keyPath ofObject:[change objectForKey:@"new"]];
}

- (void)writeWithNSUserDefault:(NSString *)key ofObject:(id)obj{
    NSString *strClassName = NSStringFromClass([self class]);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *bundleId = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *strKey = [NSString stringWithFormat:@"%@-%@-%@",bundleId,strClassName,key];
    
    if (obj&&![obj isKindOfClass:NSClassFromString(@"NSNull")])
    {
        [TKUserDefaults setObject:obj forKey:strKey];
    }
    [TKUserDefaults synchronize];
}

//销毁
- (void)dealloc
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([TKUserSetting class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        [self removeObserver:self forKeyPath:key];
        
    }
    free(properties);
    
}

/************业务相关***********/
///清除属性 一般用于登出调用
- (void)UserSettingManagerDestroy{
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count-2; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        if([propertyAttribute hasPrefix:@"T@\"NSString\","]){
            [self setValue:@"" forKey:key];
        }
        if([propertyAttribute hasPrefix:@"Tq,"]){
            [self setValue:[NSNumber numberWithInt:0] forKey:key];
        }
    }
    self.isLogined = NO;
    self.isFistInstall = YES;   //登出了 也不是初次安装
    free(properties);
    
}



@end
