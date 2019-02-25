//
//  TKHttpAction.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKHttpAction.h"
#import "AFHTTPSessionManager+XY.h"
#import "AFURLSessionManager.h"
#import "AFHTTPSessionManager.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "TKUserSetting.h"


#define HTTP_URL(_url_) [NSString stringWithFormat:@"http://47.92.154.180:8995%@", _url_]

@implementation TKHttpAction

-(NSString *)getURL:(NSString *)add_url{
    
    NSString *url = HTTP_URL(add_url);
    
    return url;
}

-(void)request:(NSString *)urlString method:(TKHttpMethod)method params:(id)params showHUD:(BOOL)showHUD resposeBlock:(void (^)(id, NSError *))block{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status =  [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        [XYHUDCore showErrorWithStatus:@"当前网络未连接"];
        block(nil,[NSError new]);
        return;
    }
    
    // 1.创建请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 12;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:[TKUserSetting sharedManager].token forHTTPHeaderField:@"accessToken"];
    // 2.加载框
    if (showHUD) {
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    
    void (^httpCallBolck)(NSURLSessionDataTask *, id  _Nullable responseObject, NSError *) = ^(NSURLSessionDataTask *task, id  _Nullable responseObject, NSError *error){
        
        //NSLog(@"%@",string);
        if (showHUD) {
            [SVProgressHUD dismiss];
        }
        
        if(responseObject!=nil){
            NSDictionary *responseDict = responseObject;
            if([responseObject isKindOfClass:[NSData class]]){
                NSData *responseData1 = responseObject;
                responseDict =[NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableContainers error:nil];
            }
            NSLog(@"接口%@------%@-------数据------%@",urlString,params,responseDict);
            if([responseDict[@"code"] integerValue]==0){
                
                block(responseDict,nil);
            }else{
                if (showHUD) {
                    [XYHUDCore showErrorWithStatus:responseDict[@"msg"]];
                }
            }
        }else{
            if (showHUD) {
                [XYHUDCore showErrorWithStatus:@"服务器罢工啦,请稍后重试"];
            }
        }
    };
    
    if (method == TKHttpMethodGET) {
        [manager XY_GET:urlString parameters:params progress:^(NSProgress *downloadProgress) {
            //这里可以获取进度
        } respose:httpCallBolck];
    }else if (method == TKHttpMethodPOST){
        [manager XY_POST:urlString parameters:params progress:^(NSProgress *downloadProgress) {
            //这里可以获取进度
        } respose:httpCallBolck];
    }
}

-(void)tokeys_request:(NSString *)urlString method:(TKHttpMethod)method params:(id)params showHUD:(BOOL)showHUD resposeBlock:(void (^)(TKHttpResposeModel *, NSString *))block{
    
    [self request:urlString method:method params:params showHUD:showHUD resposeBlock:^(id responseObject, NSError *error) {
        if (responseObject!=nil) {
            TKHttpResposeModel *model = [[TKHttpResposeModel alloc] initWithDictionary:responseObject];
            if (model!=nil) {
                block(model,model.msg);
            }else{
                block(nil,@"服务器罢工啦,请稍后重试");
            }
        }else{
            block(nil,@"服务器罢工啦,请稍后重试");
        }
    }];
}
@end
