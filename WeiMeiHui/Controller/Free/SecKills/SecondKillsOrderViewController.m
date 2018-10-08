//
//  SecondKillsOrderViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SecondKillsOrderViewController.h"
#import "PayStyleViewController.h"
#import "GroupPayPageTableViewCell.h"

@interface SecondKillsOrderViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (copy, nonatomic) NSDictionary *dataDic;

@end

@implementation SecondKillsOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.secPrice = [self.sec_price doubleValue];
    self.price = [self.org_price doubleValue];
    
    [self configNavView];
    
    
    
//    [self getData];
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
    
    
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.rowHeight = 44;
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-SafeAreaHeight-Space-49);
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 4;
    }
    
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return Space;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0 ) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.titleLab.text = self.name;
            cell.rightLab.text = [NSString stringWithFormat:@"¥%.2f",self.price];
            return cell;
            
        }
    
        if (indexPath.row == 1 ) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.titleLab.text = @"购买数量";
            cell.rightLab.text = @"1";
            return cell;
            
        }
        
        if (indexPath.row == 2 ) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.titleLab.text = @"小计";
            
            cell.rightLab.text = [NSString stringWithFormat:@"¥%.2f",self.secPrice];
            cell.rightLab.textColor = MainColor;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
            
        }else{
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellFive];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.priceLab.text = [NSString stringWithFormat:@"¥%.2f",self.price];
            
            cell.detailsLab.text = [NSString stringWithFormat:@"（已优惠¥%.2f)",(self.price - self.secPrice)];
            return cell;
            
        }
        
    }else{
        
        GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
        
        if (indexPath.row == 0 ) {
            cell.titleLab.text = @"您绑定的手机号码";
        }else{
            
            cell.titleLab.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"phone"];
            
        }
    
        cell.rightLab.hidden = YES;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
        
    }
        
    
}

- (void)getData{
    
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":self.ID,@"uuid":uuid,@"num":@"1",@"sec_price":@(self.secPrice),@"activity_id":self.activity_id,@"session_id":self.session_id}];
    
    [YYNet POST:KilladdOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.dataDic = dic[@"data"];
        
        if ([dic[@"success"] boolValue]) {
            
            PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
            payVC.ordernumber = [dic[@"data"] objectForKey:@"order_num"];
            payVC.price = [dic[@"data"] objectForKey:@"pay_price"];
            
        
            payVC.notifyUrlAli = AliGroupMuchNotifyUrl;
            payVC.notifyUrlWeixin = WXGroupMuchNotifyUrl;
            
            [self.navigationController pushViewController:payVC animated:YES];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            return ;
            
        }
       
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        
    }];
    
}

- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 支付
- (IBAction)payAction:(UIButton *)sender {
    
    [self getData];
    
}


@end
