//
//  TKDocumentModel.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TKDocumentModel : NSObject

@property (nonatomic,copy)NSString * isDir;//是否目录文件(0表示目录，1表示文件)
@property (nonatomic,copy)NSString * fname;//文件名称
@property (nonatomic,copy)NSString * filePath;//下载地址
@property (nonatomic,copy)NSString * fid;//文件id

@end

