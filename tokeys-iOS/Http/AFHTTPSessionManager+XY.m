//
//  AFHTTPSessionManager+XY.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "AFHTTPSessionManager+XY.h"

@implementation AFHTTPSessionManager (XY)

-(NSURLSessionDataTask *)XY_GET:(NSString *)URLString
                     parameters:(id)parameters
                       progress:(void (^)(NSProgress *))downloadProgress
                        respose:(void (^)(NSURLSessionDataTask *, id _Nullable, NSError *))respose{
    
    NSURLSessionDataTask *dataTask = [self xy_dataTaskWithHTTPMethod:@"GET"
                                                           URLString:URLString
                                                          parameters:parameters
                                                      uploadProgress:nil
                                                    downloadProgress:downloadProgress
                                                             respose:respose];
    
    [dataTask resume];
    
    return dataTask;
}


-(NSURLSessionDataTask *)XY_POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress respose:(void (^)(NSURLSessionDataTask *, id _Nullable, NSError *))respose{
    
    NSURLSessionDataTask *dataTask = [self xy_dataTaskWithHTTPMethod:@"POST"
                                                           URLString:URLString
                                                          parameters:parameters
                                                      uploadProgress:nil
                                                    downloadProgress:downloadProgress
                                                             respose:respose];
    
    [dataTask resume];
    
    return dataTask;
}



- (NSURLSessionDataTask *)xy_dataTaskWithHTTPMethod:(NSString *)method
                                          URLString:(NSString *)URLString
                                         parameters:(id)parameters
                                     uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                   downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                            respose:(void (^)(NSURLSessionDataTask *, id,NSError *))respose
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (respose) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                respose(nil,nil, serializationError);
            });
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (respose) {
                                   respose(dataTask, responseObject, error);
                               }
                           } else {
                               if (respose) {
                                   respose(dataTask, responseObject,nil);
                               }
                           }
                       }];
    
    return dataTask;
}

@end
