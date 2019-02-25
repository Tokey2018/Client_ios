//
//  TKWebViewController.m
//  tokeys-iOS
//
//  Created by 杨卢银 on 2019/2/25.
//  Copyright © 2019 杨卢银. All rights reserved.
//

#import "TKWebViewController.h"

@interface TKWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_url) {
        NSURL *r = [NSURL URLWithString:_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:r];
        [_webView loadRequest:request];
    }
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
