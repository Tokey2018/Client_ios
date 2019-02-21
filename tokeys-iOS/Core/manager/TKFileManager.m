//
//  TKFileManager.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKFileManager.h"

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation TKFileManager

static TKFileManager *__core;

+(TKFileManager *)sharedManager
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        __core = [[TKFileManager alloc]init];
        
    });
    
    return __core;
}
-(NSString*)getPath:(NSString*)p{
    
    NSString *path = [NSString stringWithFormat:@"%@/TKDATA/FILES",PATH_OF_DOCUMENT];
    
    NSArray *sarray = [p componentsSeparatedByString:@"/"];
    NSString *s = p;
    if (sarray && sarray.count>1) {
        for (int i = 0; i < sarray.count-1;i++) {
            path = [NSString stringWithFormat:@"%@/%@",path,sarray[i]];
        }
        s = [sarray lastObject];
    }
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(bo,@"创建目录失败");
    if (bo==YES) {
        
    }
    NSString *returnString = [[path stringByAppendingString:@"/"] stringByAppendingString:s];
    
    XYLog(@"文件位置：%@",returnString);
    
    return returnString;
}
-(NSMutableDictionary*)getDictionary:(NSString*)name{
    NSDictionary *rootDic = [[NSDictionary alloc]initWithContentsOfFile:[self getPath:name]];
    if (!rootDic) {
        rootDic = [NSDictionary dictionary];
        if([rootDic writeToFile:[self getPath:name] atomically:YES]){
            
        }else{
            XYLog(@"写入文件失败！%@",[self getPath:name]);
        }
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:rootDic];
    return dic;
}

-(id)getFileByFileName:(NSString *)fileName{
    NSMutableDictionary *rootdic = [self getDictionary:fileName];
    return rootdic;
}
-(void)saveFile:(id)file key:(NSString*)key fileName:(NSString *)fileName{
    NSMutableDictionary *rootdic = [self getDictionary:fileName];
    [rootdic setObject:file forKey:key];
    [rootdic writeToFile:[self getPath:fileName] atomically:YES];
}

-(void)deleteFileKey:(NSString *)key fileName:(NSString *)fileName{
    if (key==nil) {
        [[NSFileManager defaultManager] removeItemAtPath:[self getPath:fileName] error:nil];
    }else{
        NSMutableDictionary *rootdic = [self getDictionary:fileName];
        [rootdic removeObjectForKey:key];
        [rootdic writeToFile:[self getPath:fileName] atomically:YES];
    }
}

@end
