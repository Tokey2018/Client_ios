//
//  TKHttpAction.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKHttpResposeModel.h"

@interface TKHttpAction : NSObject

-(NSString *)getURL:(NSString *)add_url;

-(void)request:(NSString*)urlString params:(id)params showHUD:(BOOL)showHUD resposeBlock:(void(^)(id responseObject,NSError *error))block;

-(void)tokeys_request:(NSString*)urlString params:(id)params showHUD:(BOOL)showHUD resposeBlock:(void(^)(TKHttpResposeModel *response,NSString *aMessage))block;

@end

