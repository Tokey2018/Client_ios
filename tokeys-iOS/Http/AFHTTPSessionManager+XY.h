//
//  AFHTTPSessionManager+XY.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/20.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFHTTPSessionManager (XY)

- (nullable NSURLSessionDataTask *)XY_GET:(NSString *)URLString
                               parameters:(nullable id)parameters
                                 progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                                  respose:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError *error))respose;

- (nullable NSURLSessionDataTask *)XY_POST:(NSString *)URLString
                                parameters:(nullable id)parameters
                                  progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                                   respose:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError *error))respose;

@end

