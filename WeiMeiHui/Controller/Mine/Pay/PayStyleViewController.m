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


@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;

@end

@implementation PayStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _priceLable.text = [NSString stringWithFormat:@"¥%@",_price];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payNotifitionALI:) name:@"payNotifyALI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payNotifition:) name:@"payNotifyWEI" object:nil];
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
