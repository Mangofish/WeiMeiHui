//
//  ActivityWebViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ActivityWebViewController.h"
#import <WebKit/WebKit.h>

@interface ActivityWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>{
    
    WKUserContentController* userContentController;
    
}
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ActivityWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置环境
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = userContentController;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100) configuration:configuration];

    //注册方法
//    通过代理调方法，其他的控制器
    
//    WKDelegateController * delegateController = [[WKDelegateController alloc]init];
//    delegateController.delegate = self;
//    [userContentController addScriptMessageHandler:delegateController name:@"sayhello"];
    
  
    
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        
    }];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
}


#pragma mark - WKScriptMessageHandler
//交互
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
 
    NSString *methods = [NSString stringWithFormat:@"%@:", message.body];
    SEL selector = NSSelectorFromString(methods);
    if ([self respondsToSelector:selector]) {
        
    } else {
        NSLog(@"未实行方法：%@", methods);
        
    }
}


@end
