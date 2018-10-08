//
//  JoinSingleGroupViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "JoinSingleGroupViewController.h"
#import "GroupPayPageTableViewCell.h"
#import "PayStyleViewController.h"
#import "BaseAlertController.h"

@interface JoinSingleGroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableDictionary *heightDic;
@property (copy, nonatomic) NSDictionary *dataDic;

@property (assign, nonatomic) double price;
@property (assign, nonatomic) double oldPrice;
@property (copy, nonatomic) NSString *orderNumber;
@property (assign, nonatomic) double finalPrice;

@property (copy, nonatomic) NSString *couponStr;
@property (assign, nonatomic) NSUInteger couponIndex;
@property (copy, nonatomic) NSString *coupon_id;
@property (assign, nonatomic) BOOL isuseCoupon;
@end

@implementation JoinSingleGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _coupon_id = @"";
    _orderNumber = @"";
    [self configNavView];
    [self getData];
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
    
    
    _heightDic = [NSMutableDictionary dictionary];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
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
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.titleLab.text = _dataDic[@"goods_name"];
            cell.rightLab.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"org_price"]];
            return cell;
            
        }
        
        //            价钱
        if (indexPath.row == 1 ) {
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellTwo];
            
            
            
            NSString *str1 = [NSString stringWithFormat:@" %@ ",_dataDic[@"name"]];
            
            [cell.leftBtn setTitle:str1 forState:UIControlStateNormal];
            
            [cell.leftBtn setTitle:str1 forState:UIControlStateNormal];
            cell.rightBtn.hidden = YES;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.leftBtn.layer.borderColor = MainColor.CGColor;
            [cell.leftBtn setTitleColor:MainColor forState:UIControlStateNormal];
            
            
            
            return cell;
        }
        
//        小计
        if (indexPath.row == 2 ) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.titleLab.text = @"小计";
            
            cell.rightLab.text = [NSString stringWithFormat:@"¥%.2f",_price];
            cell.rightLab.textColor = MainColor;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
            
        }
    
    }else if (indexPath.section == 1 ){
//        抵用券
        if (indexPath.row == 0) {
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellFour];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.stateLab.text = self.couponStr;
            return cell;
        }else{
            
//            订单总价
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellFive];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.priceLab.text = [NSString stringWithFormat:@"%.2f",_finalPrice];
            
            cell.detailsLab.text = [NSString stringWithFormat:@"（已优惠¥%.2f)",(self.oldPrice - _finalPrice)];
            return cell;
            
        }
        
    }
    
    GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
    
    if (indexPath.row == 0 ) {
        cell.titleLab.text = @"您绑定的手机号码";
    }else{
        cell.titleLab.text = _dataDic[@"phone"];
    }
    
    
    cell.rightLab.hidden = YES;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
    
    
}

- (void)getData{
    
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"common_order_num":_ID}];
    
    [YYNet POST:JoinCoupon paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.dataDic = dic[@"data"];
        
        self.price = [self.dataDic[@"dis_price"] doubleValue];
        self.finalPrice = self.price;
            
        self.oldPrice = [self.dataDic[@"org_price"] doubleValue];
        
        if ([self.dataDic[@"coupon_list"] isKindOfClass:[NSArray class]]) {
            
            NSArray *temp = self.dataDic[@"coupon_list"];
            if (temp.count) {
                self.couponStr = @"未使用优惠券";
            }
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


#pragma mark- 选优惠券
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0 ) {
            
            BaseAlertController *ctrl = [[BaseAlertController alloc]init];
            ctrl.dataAry = self.dataDic[@"coupon_list"];
            
            __block BaseAlertController *cirtBlock  = ctrl;
            
            
            ctrl.selectComplete = ^(NSUInteger index) {
                
                self.couponIndex = index;
                self.isuseCoupon = YES;
                
                NSArray *temp = self.dataDic[@"coupon_list"];
                //                计算改变样式
                double finalDecprice = [PublicMethods couponCaculatePrice:temp[index] beforePrice:self.price];
                
                if (finalDecprice == 0) {
                    
                    //                    提示无可用优惠券
                    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"不满足使用条件" iconImage:[UIImage imageNamed:@"warning"]];
                    toast.toastType = FFToastTypeWarning;
                    toast.toastPosition = FFToastPositionCentreWithFillet;
                    [toast show];
                    self.isuseCoupon = NO;
                    return ;
                }else{
                    
                    NSString *holdPrice = [NSString stringWithFormat:@"%@",temp[self.couponIndex][@"par_value"]];
                    
                    self.couponStr = [NSString stringWithFormat:@"-¥%@",holdPrice];
                    [cirtBlock couponAlertViewshouldDismiss];
                }
                
                self.finalPrice = finalDecprice;
                [self.mainTableView reloadData];
                
            };
            [self presentViewController:ctrl animated:YES completion:nil];
            
        }
        
    }
    
}
#pragma mark- 支付
- (IBAction)payAction:(UIButton *)sender {
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSArray *temp = self.dataDic[@"coupon_list"];
    NSString * is_use_coupon = @"2";
    
    if (_isuseCoupon) {
        _coupon_id = [temp[_couponIndex] objectForKey:@"id"];
        
        is_use_coupon = @"1";
    }else{
        _coupon_id = @"";
       
    }
    
    NSString *modeID = self.dataDic[@"group_mode_id"];;
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"common_order_num":_ID,@"coupon_id":_coupon_id,@"buy_num":@(1),@"is_use_coupon":is_use_coupon,@"price":@(_finalPrice),@"is_use_activity":@"2",@"type":@"1",@"del_order_num":_orderNumber,@"group_mode_id":modeID,@"goods_id":self.goodsID}];
//
    [YYNet POST:GoodsSingleTOPay paramters:@{@"json":url} success:^(id responseObject) {

        NSDictionary *dic = [solveJsonData changeType:responseObject];

        if ([dic[@"success"] boolValue]) {

            PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
            payVC.ordernumber = [dic[@"data"] objectForKey:@"order_num"];
            payVC.price = [dic[@"data"] objectForKey:@"pay_price"];
            payVC.notifyUrlAli = AliGroupSingleNotifyUrl;
            payVC.notifyUrlWeixin = WXGroupSingleNotifyUrl;
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

@end
