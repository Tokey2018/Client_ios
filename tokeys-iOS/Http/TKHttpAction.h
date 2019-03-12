//
//  TKHttpAction.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKHttpResposeModel.h"

#define HTTP_URL(_url_) [NSString stringWithFormat:@"http://47.92.154.180:8995%@", _url_]

typedef NS_ENUM (NSInteger, TKHttpMethod)   {
    
    TKHttpMethodGET = 0,
    
    TKHttpMethodPOST = 1,
    
    TKHttpMethodPUT = 2,
    
    TKHttpMethodDELETE = 3
    
};

@interface TKHttpAction : NSObject

-(NSString *)getURL:(NSString *)add_url;

-(void)request:(NSString*)urlString method:(TKHttpMethod)method params:(id)params showHUD:(BOOL)showHUD resposeBlock:(void(^)(id responseObject,NSError *error))block;

-(void)tokeys_request:(NSString*)urlString method:(TKHttpMethod)method params:(id)params showHUD:(BOOL)showHUD resposeBlock:(void(^)(TKHttpResposeModel *response,NSString *aMessage))block;

@end

