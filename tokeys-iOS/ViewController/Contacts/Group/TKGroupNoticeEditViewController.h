//
//  TKGroupNoticeEditViewController.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/12.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKGroupNoticeEditViewController;

@protocol TKGroupNoticeEditViewControllerDelegate <NSObject>

-(void)groupNoticeEditViewController:(TKGroupNoticeEditViewController*)aGroupNoticeEditViewControlle sendnotiwith:(NSString *)string;

@end

@interface TKGroupNoticeEditViewController : UIViewController

@property (nonatomic,copy)NSString * groupID;
@property (nonatomic,assign)id<TKGroupNoticeEditViewControllerDelegate>delegate;

@end

