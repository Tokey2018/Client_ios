//
//  NSString+TKString.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/25.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "NSString+TKString.h"

@implementation NSString (TKString)

//根据字符串的字体和size(此处size设置为字符串宽和MAXFLOAT)返回多行显示时的字符串size
- (CGSize)stringSizeWithFont:(UIFont *)font Size:(CGSize)size {
    
    CGSize resultSize;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7) {
        //段落样式
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        
        //字体大小，换行模式
        NSDictionary *attributes = @{NSFontAttributeName : font , NSParagraphStyleAttributeName : style};
        resultSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    } else {
        //计算正文的高度
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    return resultSize;
}

@end
