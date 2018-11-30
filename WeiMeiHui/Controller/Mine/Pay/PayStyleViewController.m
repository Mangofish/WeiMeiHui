//
//  PayStyleViewController.m
//  WeiMeiHui
//
//  Created by Mac on 17/5/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "PayStyleViewController.h"
#import "PaySuccessViewController.h"
#import "PayFailedViewController.h"
#import "MyCardsListsViewController.h"

@interface PayStyleViewController ()


@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *priceBg;
@property (weak, nonatomic) IBOutlet UILabel *inforLab;
@property (weak, nonatomic) IBOutlet UIButton *wxImg;
@property (weak, nonatomic) IBOutlet UIButton *aliImg;
@property (weak, nonatomic) IBOutlet UILabel *wxLab;
@property (weak, nonatomic) IBOutlet UILabel *aliLab;
@property (weak, nonatomic) IBOutlet UILabel *wxInfo;
@property (weak, nonatomic) IBOutlet UILabel *aliInfo;

@end

@implementation PayStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _priceLable.text = [NSString stringWithFormat:@"¥%@",_price];
    [self configNavView];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payNotifitionALI:) name:@"payNotifyALI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payNotifition:) name:@"payNotifyWEI" object:nil];
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
    
    _priceBg.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, 44);
   _aliBtn.frame = CGRectMake(0, SafeAreaHeight+1+Space+44, kWidth, 52);
    _wxBtn.frame = CGRectMake(0, SafeAreaHeight+1+Space+44+Space+52, kWidth, 52);
    
    [_inforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.priceBg.mas_centerY);
    }];
    
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.priceBg.mas_centerY);
    }];
    
    [_wxImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wxBtn.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.wxBtn.mas_centerY).offset(0);
    }];
    
    [_wxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(12);
        make.left.mas_equalTo(self.wxImg.mas_right).offset(5);
        make.top.mas_equalTo(self.wxBtn.mas_top).offset(Space);
    }];
    
    [_wxInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(12);
        make.left.mas_equalTo(self.wxImg.mas_right).offset(5);
        make.top.mas_equalTo(self.wxLab.mas_bottom).offset(Space);
    }];
    
    [_aliImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.aliBtn.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.aliBtn.mas_centerY);
    }];
    
    [_aliLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(12);
        make.left.mas_equalTo(self.aliImg.mas_right).offset(5);
        make.top.mas_equalTo(self.aliBtn.mas_top).offset(Space);
    }];
    
    [_aliInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(12);
        make.left.mas_equalTo(self.aliImg.mas_right).offset(5);
        make.top.mas_equalTo(self.aliLab.mas_bottom).offset(Space);
    }];
    
    
}


#pragma mark- 通知回调
- (void)payNotifition:(NSNotification *)info {
    
//    跳转页面
    NSDictionary *dic = info.userInfo;
    
    if ([dic[@"info"] boolValue]) {
        
        if (self.isCard) {
            
            PaySuccessViewController *success = [[PaySuccessViewController alloc]init];
            success.isCard = YES;
            [self.navigationController pushViewController:success animated:YES];
            
            return;
            
        }
        
        PaySuccessViewController *success = [[PaySuccessViewController alloc]init];
        [self.navigationController pushViewController:success animated:YES];
        
    }else{
        
        PayFailedViewController *fail = [[PayFailedViewController alloc]init];
        [self.navigationController pushViewController:fail animated:YES];
        
    }

}

- (void)payNotifitionALI:(NSNotification *)info {
    
    //    跳转页面
    NSDictionary *dic = info.userInfo;
    
    if ([dic[@"resultStatus"] integerValue] == 9000) {
        
        PaySuccessViewController *success = [[PaySuccessViewController alloc]init];
        [self.navigationController pushViewController:success animated:YES];
        
    }else{
        
        PayFailedViewController *fail = [[PayFailedViewController alloc]init];
        [self.navigationController pushViewController:fail animated:YES];
        
    }
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 微信
- (IBAction)wxAction:(UIButton *)sender {
    _wxBtn.selected = !_wxBtn.selected;
      _aliBtn.selected = NO;
    
    if (_ordernumber.length) {
        
        NSString *wxPrice = [NSString stringWithFormat:@"%.0f",[_price doubleValue]*100];
        
        [PublicMethods wxPayActionWithOrderNum:_ordernumber andPrice:wxPrice andNotify:self.notifyUrlWeixin];
            
    }
    
}

#pragma mark- 支付宝
- (IBAction)aliAction:(UIButton *)sender {
    _aliBtn.selected = !_aliBtn.selected;
    _wxBtn.selected =NO;
    
    if (_ordernumber.length) {
        
            [PublicMethods aliPayActionWithOrderNum:_ordernumber andPrice:[_price doubleValue]  andNotify:self.notifyUrlAli];
        
    }
    
}



@end
