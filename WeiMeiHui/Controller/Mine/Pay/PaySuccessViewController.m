//
//  PaySuccessViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "RecentOrderListsViewController.h"
#import "MyCardsListsViewController.h"

@interface PaySuccessViewController ()


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);、
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

- (IBAction)checkOrderAction:(UIButton *)sender {
    
    if (self.isCard) {
        
        MyCardsListsViewController *recentVc= [[MyCardsListsViewController alloc]init];
        [self.navigationController pushViewController:recentVc animated:YES];
        return;
        
    }
    
    
    RecentOrderListsViewController *recentVc= [[RecentOrderListsViewController alloc]init];
    [self.navigationController pushViewController:recentVc animated:YES];
    
}



@end
