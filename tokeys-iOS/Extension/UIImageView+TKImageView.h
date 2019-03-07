//
//  UIImageView+TKImageView.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImageView (TKImageView)

- (void)tk_setImageWithURL:(NSString *)imageUrl placeholderImage:(UIImage *)placeholder;

@end

