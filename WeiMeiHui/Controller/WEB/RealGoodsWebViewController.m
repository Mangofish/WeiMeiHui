//
//  RealGoodsWebViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/11/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "RealGoodsWebViewController.h"
#import "ValueCardsPayViewController.h"

@interface RealGoodsWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, copy) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RealGoodsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _webView.delegate = self;
    
    _webView.userInteractionEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView.scrollView.bounces = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self getData];
   
    
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
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
        _titleLabel.text = self.name;
    _webView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight-40);
    
    
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 获取数据
- (void)getData{
    
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":self.ID}];
    
    [YYNet POST:PackageDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        self.dataDic = dict[@"data"];
        
        [self.webView loadHTMLString:[dict[@"data"] objectForKey:@"content"] baseURL: nil];
//        self.titleLabel.text = [dict[@"data"] objectForKey:@"content"];
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

#pragma mark - 去支付
- (IBAction)payAction:(UIButton *)sender {
    
    
    ValueCardsPayViewController *valueVC = [[ValueCardsPayViewController alloc]init];
    valueVC.ID = self.ID;
    valueVC.shopID = self.shopID;
    valueVC.type = 1;
    [self.navigationController pushViewController:valueVC animated:YES];
   
    
}

@end
