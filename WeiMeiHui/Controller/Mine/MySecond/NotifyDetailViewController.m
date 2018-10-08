//
//  NotifyDetailViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "NotifyDetailViewController.h"

@interface NotifyDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation NotifyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);
//        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    
    _webView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight-Space);
    
    [_webView loadHTMLString:_content baseURL:nil];
    
    
}

- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
