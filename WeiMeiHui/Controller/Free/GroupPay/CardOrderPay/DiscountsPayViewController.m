//
//  DiscountsPayViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/11/20.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "DiscountsPayViewController.h"
#import "FamousShopTitleTableViewCell.h"
#import "GroupPayPageTableViewCell.h"
#import "PayStyleViewController.h"

@interface DiscountsPayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (copy, nonatomic) NSDictionary *dataDic;

@end

@implementation DiscountsPayViewController

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
    
    
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.rowHeight = 44;
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1-49);
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        
        return 3;
        
    }
    
    
    if (section == 2) {
        
        return 3;
        
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
            
            FamousShopTitleTableViewCell *cell = [FamousShopTitleTableViewCell famousShopTitleTableViewCellSingle];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
            
        }
        
    }else if (indexPath.section == 1 ){
        
        //        会员卡
        if (indexPath.row == 0) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellSeven];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
            
        }
        
        //        优惠券
        if (indexPath.row == 1) {
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellEight];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            return cell;
            
        }
        
        //        会员卡
        if (indexPath.row == 2) {
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellNight];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
        }
        
    }else if (indexPath.section == 2){
        
        //
        
        if (indexPath.row == 0) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.rightLab.textColor = MainColor;
            cell.titleLab.text = @"会员卡";
            cell.rightLab.text = @"";
            return cell;
            
        }
        
        if (indexPath.row == 1) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.rightLab.textColor = MainColor;
            cell.titleLab.text = @"优惠券";
            cell.rightLab.text = @"";
            return cell;
            
        }
        
        if (indexPath.row == 2) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.rightLab.textColor = FontColor;
            cell.titleLab.text = @"待支付金额";
            cell.rightLab.text = @"";
            return cell;
            
        }
        
    }else{
        
        if (indexPath.row == 0) {
            
            UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.text = @"";
            cell.textLabel.textColor = FontColor;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            return cell;
            
        }
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellTen];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
        
    }
    
    GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellTen];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 80;
    }
    
    return 44;
    
}


- (void)getData{
    
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"goods_id":_ID,@"type":_type}];
    
    [YYNet POST:GoodsGroupPay paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.dataDic = dic[@"data"];
        
       
        
        
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        
    }];
    
}

#pragma mark- 支付
- (IBAction)payAction:(UIButton *)sender {
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSArray *temp = self.dataDic[@"coupon_list"];
    NSString * is_use_coupon = @"2";
    
    
    NSString *activity_id = @"";
    if ([self.isActivity integerValue] == 1) {
        
        activity_id = self.dataDic[@"activity_id"];
        
    }
    
    
    NSString *url = @"";
    
    [YYNet POST:GoodsSingleTOPay paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
            payVC.ordernumber = [dic[@"data"] objectForKey:@"order_num"];
            payVC.price = [dic[@"data"] objectForKey:@"pay_price"];
            
            payVC.notifyUrlAli = AliGroupNotifyUrl;
            payVC.notifyUrlWeixin = WXGroupNotifyUrl;
            
            [self.navigationController pushViewController:payVC animated:YES];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            return ;
            
        }
        
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
