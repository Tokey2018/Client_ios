//
//  TKParentClassScrollViewController.h
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/4.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKParentClassScrollViewDelegate <NSObject>

-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView;

@end

@interface TKParentClassScrollViewController : UIViewController
    
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, weak  )id<TKParentClassScrollViewDelegate>delegate;

@end

