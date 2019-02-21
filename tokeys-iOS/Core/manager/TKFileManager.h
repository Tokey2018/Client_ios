//
//  TKFileManager.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/1/9.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TKFileManager : NSObject

+(TKFileManager *)sharedManager;

-(NSString*)getPath:(NSString*)path;

-(NSMutableDictionary*)getDictionary:(NSString*)name;

-(id)getFileByFileName:(NSString *)fileName;

-(void)saveFile:(id)file key:(NSString*)key fileName:(NSString *)fileName;

-(void)deleteFileKey:(NSString*)key fileName:(NSString *)fileName;


@end

