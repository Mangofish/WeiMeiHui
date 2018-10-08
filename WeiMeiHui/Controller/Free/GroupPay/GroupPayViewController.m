//
//  GroupPayViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GroupPayViewController.h"
#import "GroupPayPageTableViewCell.h"
#import "PayStyleViewController.h"
#import "BaseAlertController.h"

@interface GroupPayViewController ()<UITableViewDelegate,UITableViewDataSource,GroupPayPageTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableDictionary *heightDic;
@property (copy, nonatomic) NSDictionary *dataDic;

@property (copy, nonatomic) NSString *coupon_id;
@property (copy, nonatomic) NSString *buy_num;
@property (copy, nonatomic) NSString *group_mode_id;
@property (copy, nonatomic) NSString *activity_id;

@property (copy, nonatomic) NSString *orderNumber;

@property (assign, nonatomic) double price;
@property (assign, nonatomic) double oldPrice;

@property (assign, nonatomic) double finalPrice;
@property (assign, nonatomic) NSUInteger index;
@property (assign, nonatomic) NSUInteger count;
@property (assign, nonatomic) NSUInteger num;//限制数
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (copy, nonatomic) NSString *couponStr;
@property (assign, nonatomic) NSUInteger couponIndex;
@property (assign, nonatomic) BOOL isuseCoupon;
@end

@implementation GroupPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    [self getData];
    _index = 1;
    _count = 1;
    _orderNumber = @"";
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
            cell.titleLab.text = _dataDic[@"goods_name"];
            cell.rightLab.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"org_price"]];
            return cell;
            
        }
        
        //            价钱
        if (indexPath.row == 1 ) {
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellTwo];
            
           
            
            NSArray *temp = _dataDic[@"group_list"];
//            NSString *str1 = [NSString stringWithFormat:@" %@人拼团¥%@/人 ",[temp[0] objectForKey:@"group_num"],[temp[0] objectForKey:@"group_price"]];
            NSString *str1 = [NSString stringWithFormat:@" %@ ",[temp[0] objectForKey:@"name"]];
            if (temp.count == 2) {
                
//                NSString *str2 = [NSString stringWithFormat:@" %@人拼团¥%@/人 ",[temp[1] objectForKey:@"group_num"],[temp[1] objectForKey:@"group_price"]];
                NSString *str2 =  [NSString stringWithFormat:@" %@ ",[temp[1] objectForKey:@"name"]];
                
                [cell.leftBtn setTitle:str1 forState:UIControlStateNormal];
                [cell.rightBtn setTitle:str2 forState:UIControlStateNormal];
                
                
            }else{
                
                [cell.leftBtn setTitle:str1 forState:UIControlStateNormal];
                cell.rightBtn.hidden = YES;
            }
            
            
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.delegate = self;
            
            if (_index == 1) {
                
                cell.leftBtn.layer.borderColor = MainColor.CGColor;
                [cell.leftBtn setTitleColor:MainColor forState:UIControlStateNormal];
                
                cell.rightBtn.layer.borderColor = LightFontColor.CGColor;
                [cell.rightBtn setTitleColor:LightFontColor forState:UIControlStateNormal];
                
            }else{
                
                cell.leftBtn.layer.borderColor = LightFontColor.CGColor;
                 [cell.leftBtn setTitleColor:LightFontColor forState:UIControlStateNormal];
                
                cell.rightBtn.layer.borderColor = MainColor.CGColor;
                 [cell.rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
                
            }
            
            return cell;
        }
        
        if (indexPath.row == 2 ) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellThree];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.countLab.text = [NSString stringWithFormat:@"%lu",_count];
            cell.delegate = self;
            return cell;
            
        }
        
        if (indexPath.row == 3 ) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.titleLab.text = @"小计";
    
            cell.rightLab.text = [NSString stringWithFormat:@"¥%.2f",_price];
            cell.rightLab.textColor = MainColor;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
        }
        
        
        
    }else if (indexPath.section == 1 ){
        
//        优惠券
        if (indexPath.row == 0) {
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellFour];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.stateLab.text = self.couponStr;
            return cell;
        }else{
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellFive];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.priceLab.text = [NSString stringWithFormat:@"%.2f",_finalPrice];
            
            cell.detailsLab.text = [NSString stringWithFormat:@"（已优惠¥%.2f)",(self.oldPrice*_count - _finalPrice)];
            return cell;
            
        }
        
    
    }
        
        GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
    
    if (indexPath.row == 0 ) {
        cell.titleLab.text = @"您绑定的手机号码";
    }else{
        cell.titleLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"phone"]];
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
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"goods_id":_ID}];
    
    [YYNet POST:GoodsGroupPay paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.dataDic = dic[@"data"];
        
        if ([self.dataDic[@"group_list"] isKindOfClass:[NSArray class]]) {
            
            NSArray *temp = self.dataDic[@"group_list"];
            
            if (temp.count) {
                self.price = [[[self.dataDic[@"group_list"] objectAtIndex:0] objectForKey:@"group_price"] doubleValue];
                
                self.price = self.price*self.count;
                
                self.finalPrice = self.price;
                
                self.num = [[[self.dataDic[@"group_list"] objectAtIndex:0] objectForKey:@"group_num"] integerValue];
                
                self.oldPrice = [self.dataDic[@"org_price"] doubleValue];
                
                self.group_mode_id = [[self.dataDic[@"group_list"] objectAtIndex:0] objectForKey:@"id"];
            }
            
            
        }
        
        if ([self.dataDic[@"coupon_list"] isKindOfClass:[NSArray class]]) {
            
            NSArray *temp = self.dataDic[@"coupon_list"];
            if (temp.count) {
                self.couponStr = @"未使用优惠券";
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

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- 选团购
-(void)didSelectedItemAtIndex:(NSUInteger)index{
    
    _index = index;
    self.num = [[[_dataDic[@"group_list"] objectAtIndex:index-1] objectForKey:@"group_num"] integerValue];
    _group_mode_id = [[_dataDic[@"group_list"] objectAtIndex:index-1] objectForKey:@"id"];
    _price = [[[_dataDic[@"group_list"] objectAtIndex:index-1] objectForKey:@"group_price"] doubleValue];
    
    self.finalPrice = _price;
//    小计价格改变
    _price = _price*_count;
    
//最后价格，需要考虑优惠券
    
    NSArray *temp = self.dataDic[@"coupon_list"];
    
    if (temp.count) {
        
        double finalDecprice = [PublicMethods couponCaculatePrice:temp[_couponIndex] beforePrice:self.price];
        
        if (finalDecprice) {
            
            _price = finalDecprice;
            _finalPrice = _price;
            
            NSString *holdPrice = [NSString stringWithFormat:@"%@",temp[_couponIndex][@"par_value"]];
            
            self.couponStr = [NSString stringWithFormat:@"-¥%@",holdPrice];
            
            
        }else{
            //        改变显示样式
            self.couponStr = @"未使用优惠券";
        }
        
        
    }
    
    
    //    支付价格改变
    NSString *str = [NSString stringWithFormat:@"去支付    %.2f元",_finalPrice];
    [self.payBtn setTitle:str forState:UIControlStateNormal];
   [self.mainTableView reloadData];
    
}

#pragma mark- 加
- (void)plus{
    
    if (_count == _num) {
        return;
    }
    
    _count++;
    
    _price = [[[_dataDic[@"group_list"] objectAtIndex:self.index-1] objectForKey:@"group_price"] doubleValue];
    
    //    小计价格改变
    _price = _price*_count;
    
    _finalPrice = _price;
    
    NSArray *temp = self.dataDic[@"coupon_list"];
    
    if (temp.count) {
        
        double finalDecprice = [PublicMethods couponCaculatePrice:temp[_couponIndex] beforePrice:self.price];
        
        if (finalDecprice) {
            _price = finalDecprice;
            _finalPrice = _price;
            
            NSString *holdPrice = [NSString stringWithFormat:@"%@",temp[_couponIndex][@"par_value"]];
            
            self.couponStr = [NSString stringWithFormat:@"-¥%@",holdPrice];
            
        }else{
            //        改变显示样式
            self.couponStr = @"未使用优惠券";
        }
        
    }
    
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
    
    _price = [[[_dataDic[@"group_list"] objectAtIndex:self.index-1] objectForKey:@"group_price"] doubleValue];
    
    //    小计价格改变
    _price = _price*_count;
    _finalPrice = _price;
    //最后价格，需要考虑优惠券
    
    NSArray *temp = self.dataDic[@"coupon_list"];
    
    if (temp.count) {
        
        double finalDecprice = [PublicMethods couponCaculatePrice:temp[_couponIndex] beforePrice:self.price];
        
        if (finalDecprice) {
            _price = finalDecprice;
            _finalPrice = _price;
            
            
            NSString *holdPrice = [NSString stringWithFormat:@"%@",temp[_couponIndex][@"par_value"]];
            
            self.couponStr = [NSString stringWithFormat:@"-¥%@",holdPrice];
            
            
            
        }else{
            //        改变显示样式
            self.couponStr = @"未使用优惠券";
        }
        
        
    }
    
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
    
    if (_isuseCoupon) {
        _coupon_id = [temp[_couponIndex] objectForKey:@"id"];
        
        is_use_coupon = @"1";
    }else{
        _coupon_id = @"";
      
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"goods_id":_ID,@"coupon_id":_coupon_id,@"buy_num":@(_count),@"group_mode_id":_group_mode_id,@"is_use_coupon":is_use_coupon,@"price":@(_finalPrice),@"del_order_num":_orderNumber}];
    
    [YYNet POST:GoodsGroupTOPay paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
            payVC.ordernumber = [dic[@"data"] objectForKey:@"order_num"];
            payVC.price = [dic[@"data"] objectForKey:@"pay_price"];
            payVC.notifyUrlAli = AliGroupNotifyUrl;
            payVC.notifyUrlWeixin = WXGroupNotifyUrl;
            self.orderNumber = [dic[@"data"] objectForKey:@"order_num"];
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
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0 ) {
            
            if ([self.dataDic[@"coupon_list"] isKindOfClass:[NSArray class]]) {
                
                
                NSArray *temp = self.dataDic[@"coupon_list"];
                if (temp.count ==0) {
                    return;
                }
                
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
    
}

@end
