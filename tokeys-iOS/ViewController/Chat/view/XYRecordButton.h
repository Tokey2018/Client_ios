//
//  XYRecordButton.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/6.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XYRecordButton;

@protocol XYRecordButtonMovesDeleagte <NSObject>

-(void)recordButton:(UIButton*)sender touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end

@interface XYRecordButton : UIButton

@property (weak , nonatomic) id <XYRecordButtonMovesDeleagte> delegate;

@end

