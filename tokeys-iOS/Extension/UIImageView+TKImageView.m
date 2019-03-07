//
//  UIImageView+TKImageView.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "UIImageView+TKImageView.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (TKImageView)
- (void)tk_setImageWithURL:(NSString *)imageUrl placeholderImage:(UIImage *)placeholder {
    if (imageUrl!=nil) {
        
        NSURL *url =  [NSURL URLWithString:imageUrl];
        
        [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
    }
}
@end
