//
//  IWSearchBar.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/7.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "IWSearchBar.h"

@implementation IWSearchBar

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景
        ///self.background = [UIImage resizedImageWithName:@"searchbar_textfield_background"];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // 左边的放大镜图标
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
        iconView.frame=CGRectMake(5, (frame.size.height-22)/2, 25, 22);
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.leftView = iconView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // 字体
        self.font = [UIFont systemFontOfSize:15];
        
        // 右边的清除按钮
        self.clearButtonMode = UITextFieldViewModeAlways;
        
        
        
        // 设置键盘右下角按钮的样式
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
        
        self.borderStyle=UITextBorderStyleRoundedRect;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置左边图标的frame
    self.leftView.frame = CGRectMake(5, (self.frame.size.height-22/25.0*15)/2, 15, 22/25.0*15);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(CGRectGetMaxX(self.leftView.frame)+10, 0, self.frame.size.width-35, self.frame.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(CGRectGetMaxX(self.leftView.frame)+5, 0, self.frame.size.width-35, self.frame.size.height);
}

@end
