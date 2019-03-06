//
//  TKRecentChatItemCell.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKRecentChatItemCell.h"

@implementation TKRecentChatItemCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(id)cellWithTableView:(UITableView *)tableView{
    static NSString *cellIndentifier = @"recentChatItemCellID";
    TKRecentChatItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[TKRecentChatItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    UIImageView * imageView = [TokeyViewTools createImageViewWithFrame:CGRectMake(16, 10, 50, 50) andImageName:@"" andBgColor:nil];
    [self addSubview:imageView];
    [TokeyViewTools roundingCorners:UIRectCornerAllCorners cornerRadius:25 with:imageView];
    self.headImg = imageView;
    
    UILabel * titleLabel = [TokeyViewTools createLabelWithFrame:CGRectMake(10+CGRectGetMaxX(imageView.frame), 25, W_In_375(200), 20) andTitle:@"" andTitleFont:FontSize(18) andTitleColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self addSubview:titleLabel];
    self.titleLab = titleLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
