//
//  ValueCardsPayViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/11/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ValueCardsPayViewController.h"
#import "GroupPayPageTableViewCell.h"
#import "PayStyleViewController.h"
#import "FamousGoodsTableViewCell.h"

@interface ValueCardsPayViewController ()<UITableViewDataSource,UITableViewDelegate,GroupPayPageTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (copy, nonatomic) NSDictionary *dataDic;
@property (copy, nonatomic) NSString *couponStr;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

/**
 购买数量
 */
@property (assign, nonatomic) NSUInteger count;

/**
 小计
 */
@property (assign, nonatomic) double price;
/**
 最后价格
 */
@property (assign, nonatomic) double finalPrice;

@end

@implementation ValueCardsPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
    
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
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }
    
    if (section == 1) {
        
//        什么都不能用
        if (self.type == 1) {
            return 0;
        }
        
        return 2;
        
    }
    
    
    if (section == 2) {
        
        if (self.type == 1) {
            return 1;
        }
        
        return 3;
        
    }
    
    return 1;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 80;
        }
        
    }
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0 ) {
            
            FamousGoodsTableViewCell *cell = [FamousGoodsTableViewCell famousGoodsTableViewCellDetailOrder];
            cell.goodsO = [AuthorGoods authorGoodsWithDict:self.dataDic];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            return cell;
            
        }
        
        
        if (indexPath.row == 1 ) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellThree];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.countLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)_count];
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
        
//        会员卡
        if (indexPath.row == 0) {
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellSix];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.stateLab.text = self.couponStr;
            return cell;
            
        }
        
//        优惠券
        if (indexPath.row == 1) {
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellFour];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.stateLab.text = self.couponStr;
            return cell;
            
        }
        
    }else if (indexPath.section == 2){
        
//
        if (indexPath.row == 0) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.rightLab.textColor = FontColor;
            cell.titleLab.text = @"订单金额";
            cell.rightLab.text = [NSString stringWithFormat:@"¥%.2f",_price];
            return cell;
            
        }
        
        if (indexPath.row == 1) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.rightLab.textColor = MainColor;
            cell.titleLab.text = @"会员卡";
            cell.rightLab.text = @"";
            return cell;
            
        }
        
        if (indexPath.row == 2) {
            
            GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.rightLab.textColor = MainColor;
            cell.titleLab.text = @"优惠券";
            cell.rightLab.text = @"";
            return cell;
            
        }
        
    }
    
    
    GroupPayPageTableViewCell *cell = [GroupPayPageTableViewCell groupPayPageTableViewCellOne];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.rightLab.textColor = LightFontColor;
    cell.titleLab.text = @"您绑定的手机号码";
    cell.rightLab.text = [NSString stringWithFormat:@"%@",self.dataDic[@"phone"]];
    return cell;
    
    
    
}

- (void)getData{
    
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":_ID,@"shop_id":_shopID}];
    
    [YYNet POST:AddShopOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.dataDic = dic[@"data"];
        
        self.price = [self.dataDic[@"price"] doubleValue];
        self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",self->_price];
        self.count = 1;
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
    
//   购买数量
    _count++;
    
//   商品单价
    self.price = [self.dataDic[@"price"] doubleValue];
//    优惠券减
//    会员卡余额
//  最后支付价格
    _price = _count*_price;
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",self->_price];
    [self.mainTableView reloadData];
    
}
#pragma mark- 减
- (void)decrese{
    
    if (_count == 1) {
        return;
    }
    _count --;
    self.price = [self.dataDic[@"price"] doubleValue];
    _price = _count*_price;
   self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",self->_price];
    [self.mainTableView reloadData];
    
}

#pragma mark- 支付
- (IBAction)payAction:(UIButton *)sender {
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":_ID,@"shop_id":_shopID,@"num":@(self.count)}];
    
    [YYNet POST:AddOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
            payVC.ordernumber = [dic[@"data"] objectForKey:@"order_number"];
            payVC.price = [dic[@"data"] objectForKey:@"price"];
            
            payVC.notifyUrlAli = AliPetCardNotifyUrl;
            payVC.notifyUrlWeixin = WXPetCardNotifyUrl;
            
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
