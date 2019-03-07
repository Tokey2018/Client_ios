//
//  XYRecordButton.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "XYRecordButton.h"

@implementation XYRecordButton
{
    UIButton *_scokeButton;
    UIButton *_closeButton;
    UIView *_bgView;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_delegate) {
        [_delegate recordButton:self touchesMoved:touches withEvent:event];
    }
    //    if (_touchMoved) {
    //        _touchMoved(point);
    //    }
    
    //    if (_scokeButton) {
    //        if (CGRectContainsPoint(_scokeButton.frame, point)) {
    //            _scokeButton.selected = YES;
    //        }else{
    //            _scokeButton.selected = NO;
    //        }
    //    }
}
-(void)setMoves:(UIButton *)scokBT closeBT:(UIButton *)closeBT bg:(UIView *)bg{
    _scokeButton  = scokBT;
    _closeButton  = closeBT;
    _bgView = bg;
}

@end
