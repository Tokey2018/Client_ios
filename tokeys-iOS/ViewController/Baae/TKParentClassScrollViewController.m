//
//  TKParentClassScrollViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/3/4.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKParentClassScrollViewController.h"

@interface TKParentClassScrollViewController ()<UIGestureRecognizerDelegate>

@end

@implementation TKParentClassScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

    
    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY<0) {
        //离开顶部
        if(self.delegate)
        {
            [self.delegate scrollViewLeaveAtTheTop:scrollView];
        }
    }
    _scrollView = scrollView;
}
    
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
