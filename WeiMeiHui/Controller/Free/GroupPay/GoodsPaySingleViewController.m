//
//  GoodsPaySingleViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GoodsPaySingleViewController.h"
#import "GroupPayPageTableViewCell.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "PayStyleViewController.h"
#import "BaseAlertController.h"

@interface GoodsPaySingleViewController ()<UITableViewDelegate,UITableViewDataSource,GroupPayPageTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableDictionary *heightDic;
@property (copy, nonatomic) NSDictionary *dataDic;

@property (copy, nonatomic) NSString *coupon_id;
@property (copy, nonatomic) NSString *modeid;
@property (copy, nonatomic) NSString *buy_num;

@property (copy, nonatomic) NSString *activity_id;

@property (assign, nonatomic) double price;
@property (assign, nonatomic) double oldPrice;

@property (assign, nonatomic) double finalPrice;
@property (assign, nonatomic) NSUInteger index;
@property (assign, nonatomic) NSUInteger count;
@property (assign, nonatomic) NSUInteger num;//限制数
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (copy, nonatomic) NSString *orderNumber;

@property (assign, nonatomic) BOOL isuseCoupon;
@property (copy, nonatomic) NSString *couponStr;
@property (assign, nonatomic) NSUInteger couponIndex;
@end

@implementation GoodsPaySingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    [self getData];
    _index = 1;
    _count = 1;
    _orderNumber  = @"";
    _isuseCoupon = NO;
    _type = @"";
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
    
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }
    
    if (section == 1) {
        
        if ([_dataDic[@"is_activity"] integerValue] == 1) {
            
            return 1;
            
        }else{
            return 0;
            
        }
        
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
        
        
        if (indexPath.row == 1 ) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellThree];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.countLab.text = [NSString stringWithFormat:@"%lu",_count];
            cell.delegate = self;
            return cell;
            
        }
        
        if (indexPath.row == 2 ) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.titleLab.text = @"小计";
            
            cell.rightLab.text = [NSString stringWithFormat:@"¥%.2f",_price];
            cell.rightLab.textColor = MainColor;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
        }
        
        
        
    }else if (indexPath.section == 1 ){
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOne];
        cell.goodsDetail = [GoodsDetail authorGoodsWithDict:_dataDic];
        return cell;
        
    }else if (indexPath.section == 2){
        
//        优惠券
        if (indexPath.row == 0) {
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellFour];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.stateLab.text = self.couponStr;
            return cell;
        }else{
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellFive];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.priceLab.text = [NSString stringWithFormat:@"¥%.2f",_finalPrice];
            
            cell.detailsLab.text = [NSString stringWithFormat:@"（已优惠¥%.2f)",(self.oldPrice*_count - _finalPrice)];
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
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"goods_id":_ID,@"type":_type}];
    
    [YYNet POST:GoodsGroupPay paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.dataDic = dic[@"data"];

        
        self.oldPrice = [self.dataDic[@"org_price"] doubleValue];
        
        if ([self.isActivity integerValue] == 1) {
            self.price = [self.dataDic[@"activity_price"] doubleValue];
        }else{
            self.price = [self.dataDic[@"dis_price"] doubleValue];
        }
        
        self.finalPrice = self.price;
        
        NSString *str = [NSString stringWithFormat:@"去支付    %.2f元",self.finalPrice];
        [self.payBtn setTitle:str forState:UIControlStateNormal];
        
        if ([self.dataDic[@"coupon_list"] isKindOfClass:[NSArray class]]) {
            
            NSArray *temp = self.dataDic[@"coupon_list"];
            if (temp.count) {
                 self.couponStr = @"不符合优惠券使用规则";
//                self.isuseCoupon = YES;
                
//                自动选择选择优惠券
                double couponPrice = [self chooseCouponAutomatic:self.dataDic[@"coupon_list"] beforePrice:self.finalPrice];
                if (couponPrice != self.finalPrice) {
                    
                    self.couponStr = [NSString stringWithFormat:@"-%.0f",self.price-couponPrice];
                    self.finalPrice = couponPrice;
                    
                }
                
                
            }else{
                self.couponStr = @"暂时无可用优惠券";
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

#pragma mark- 加
- (void)plus{
    
    _count++;
    
    _price = [self.dataDic[@"dis_price"] doubleValue];
    
    
    NSString * restrictNum = @"";
//    是否是活动商品限购
    if ([_isActivity integerValue] == 1) {
        
        restrictNum = self.dataDic[@"restrict_num"];
        _price = [self.dataDic[@"activity_price"] doubleValue];
    }

    
    
//    是否是活动，价格变高
    if ([self.isActivity integerValue] == 1 && restrictNum.length && _count > [restrictNum integerValue]) {
        NSUInteger num = [restrictNum integerValue];
        double disPrice = [self.dataDic[@"dis_price"] doubleValue];
        
        _price = _price*num + disPrice*(_count - num);
        
    }else{
        //    小计价格改变
        _price = _price*_count;
    }
    
    //最后价格，需要考虑优惠券
    _finalPrice = _price;
    
//    if (_isuseCoupon) {
    
        NSArray *temp = self.dataDic[@"coupon_list"];
        
        if (temp.count) {
            
//            double finalDecprice = [PublicMethods couponCaculatePrice:temp[_couponIndex] beforePrice:self.price];
            
            double finalDecprice = [self chooseCouponAutomatic:temp beforePrice:self.price];
            
            if (finalDecprice != self.price) {
                _price = finalDecprice;
                _finalPrice = _price;
                
                NSString *holdPrice = [NSString stringWithFormat:@"%@",temp[_couponIndex][@"par_value"]];
                
                self.couponStr = [NSString stringWithFormat:@"-¥%@",holdPrice];
                
                
            }else{
                
                 self.couponStr = @"不符合优惠券使用规则";
                 self.isuseCoupon = NO;
            }
            
        }else{
            self.couponStr = @"暂无可用优惠券";
             self.isuseCoupon = NO;
        }
        
//    }
    
    
    //    支付价格改变
    NSString *str = [NSString stringWithFormat:@"去支付    %.2f元",_finalPrice];
    [self.payBtn setTitle:str forState:UIControlStateNormal];
    [self.mainTableView reloadData];
}
#pragma mark- 减
- (void)decrese{
    
    if (_count == 1) {
        return;
    }
    _count --;
    
    _price = [self.dataDic[@"dis_price"] doubleValue];
    
    NSString * restrictNum = @"";
    //    是否是活动商品限购
    if ([_isActivity integerValue] == 1) {
        
        restrictNum = self.dataDic[@"restrict_num"];
        _price = [self.dataDic[@"activity_price"] doubleValue];
    }
    
    
    
    //    是否是活动，价格变高
    if ([self.isActivity integerValue] == 1 && restrictNum.length && _count > [restrictNum integerValue]) {
        NSUInteger num = [restrictNum integerValue];
        double disPrice = [self.dataDic[@"dis_price"] doubleValue];
        
        _price = _price*num + disPrice*(_count - num);
        
    }else{
        //    小计价格改变
        _price = _price*_count;
    }

    
    //最后价格，需要考虑优惠券
    _finalPrice = _price;
    
    
//    if (_isuseCoupon) {
    
        NSArray *temp = self.dataDic[@"coupon_list"];
        
        if (temp.count) {
            
//            double finalDecprice = [PublicMethods couponCaculatePrice:temp[_couponIndex] beforePrice:self.price];
            
            double finalDecprice = [self chooseCouponAutomatic:temp beforePrice:self.price];
            
            
            if (finalDecprice != self.price) {
                _price = finalDecprice;
                _finalPrice = _price;
                
                
                NSString *holdPrice = [NSString stringWithFormat:@"%@",temp[_couponIndex][@"par_value"]];
                
                self.couponStr = [NSString stringWithFormat:@"-¥%@",holdPrice];
                
            }else{
                //        改变显示样式
                self.couponStr = @"不符合优惠券使用规则";
                self.isuseCoupon = NO;
            }
            
        }
        
//    }

    
    //    支付价格改变
    NSString *str = [NSString stringWithFormat:@"去支付    %.2f元",_finalPrice];
    [self.payBtn setTitle:str forState:UIControlStateNormal];
    
    [self.mainTableView reloadData];
    
}

#pragma mark- 支付
- (IBAction)payAction:(UIButton *)sender {
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSArray *temp = self.dataDic[@"coupon_list"];
    NSString * is_use_coupon = @"2";
    
    if (_isuseCoupon && temp.count) {
        _coupon_id = [temp[_couponIndex] objectForKey:@"id"];
         _modeid = [temp[_couponIndex] objectForKey:@"coupon_mode_id"];
         is_use_coupon = @"1";
    }else{
        _coupon_id = @"";
        _modeid = @"";
    }
    
    NSString *activity_id = @"";
    if ([self.isActivity integerValue] == 1) {
        
        activity_id = self.dataDic[@"activity_id"];
        
    }
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"goods_id":_ID,@"coupon_id":_coupon_id,@"buy_num":@(_count),@"group_mode_id":@"",@"is_use_coupon":is_use_coupon,@"price":@(_finalPrice),@"is_use_activity":self.isActivity,@"type":@"2",@"del_order_num":_orderNumber,@"activity_id":activity_id}];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0 ) {
            
            if (![self.dataDic[@"coupon_list"] isKindOfClass:[NSArray class]]) {
                return;
            }
            
            BaseAlertController *ctrl = [[BaseAlertController alloc]init];
            ctrl.dataAry = self.dataDic[@"coupon_list"];
            
            __block BaseAlertController *cirtBlock  = ctrl;
            
            
            ctrl.selectComplete = ^(NSUInteger index) {
                
                self.couponIndex = index;
                self.isuseCoupon = YES;
                
                self.price = [self.dataDic[@"dis_price"] doubleValue];
                
                
                NSString * restrictNum = @"";
                //    是否是活动商品限购
                if ([self.isActivity integerValue] == 1) {
                    
                    restrictNum = self.dataDic[@"restrict_num"];
                    self.price = [self.dataDic[@"activity_price"] doubleValue];
                }
                
                
                
                //    是否是活动，价格变高
                if ([self.isActivity integerValue] == 1 && restrictNum.length && self.count > [restrictNum integerValue]) {
                    NSUInteger num = [restrictNum integerValue];
                    double disPrice = [self.dataDic[@"dis_price"] doubleValue];
                    
                    self.price = self.price*num + disPrice*(self.count - num);
                    
                }else{
                    //    小计价格改变
                    self.price = self.price*self.count;
                }
                
                //最后价格，需要考虑优惠券
                self.finalPrice = self.price;
                
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



- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 返回最后优惠价格，如果相等说明没有优惠券可用
-(double)chooseCouponAutomatic:(NSArray *)couponLists beforePrice:(double)beforPrice{
    
    double finalPrice = beforPrice;
    
    for (int i = 0; i<couponLists.count; i++) {
        
        NSDictionary *couponDic = couponLists[i];
        //        门槛金额
        double holdPrice = [couponDic[@"threshold"] doubleValue];
        //         满减金额
        double decPrice = [couponDic[@"par_value"] doubleValue];
        
        if (holdPrice > beforPrice) {
//            _isuseCoupon = NO;
            continue;
        }else{
            
            if (beforPrice-decPrice < finalPrice) {
                finalPrice = beforPrice-decPrice;
                _isuseCoupon = YES;
                _couponIndex = i;
            }
            
        }
        
    }
    
   
    
   
    return finalPrice;
    
}

@end
