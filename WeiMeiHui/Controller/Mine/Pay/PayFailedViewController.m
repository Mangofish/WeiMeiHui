//
//  PayFailedViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PayFailedViewController.h"

@interface PayFailedViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation PayFailedViewController

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
    
    
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)repayAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
