//
//  ErResultViewController.m
//  WMH_4.0
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 WMH. All rights reserved.
//

#import "ErResultViewController.h"

@interface ErResultViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webTop;

@end

@implementation ErResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleTop.constant = SafeAreaTopHeight;
    self.backTop.constant = SafeAreaTopHeight;
    self.webTop.constant = SafeAreaHeight;
    
    _webView.delegate = self;
    
    NSString *noBlankString = [_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *instance = [NSURL URLWithString:noBlankString];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:instance];
    
    [_webView loadRequest: req];
   
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}
@end
