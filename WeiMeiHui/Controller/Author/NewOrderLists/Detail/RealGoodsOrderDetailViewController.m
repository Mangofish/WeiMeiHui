//
//  RealGoodsOrderDetailViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/11/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "RealGoodsOrderDetailViewController.h"
#import "ThreeTypeOrderTableViewCell.h"
#import "NextFreeNewViewController.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "PayStyleViewController.h"

@interface RealGoodsOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ThreeTypeOrderTableViewCellDelegate>{
    
    NSDictionary *dataDic;
    
}

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation RealGoodsOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-44);
    //
    
    self.mainTableView.delegate  =self;
    self.mainTableView.dataSource = self;
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!dataDic) {
        return 0;
    }
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section > 1) {
        
        if (indexPath.row == 0 ) {
            
            return 88;
            
        }
        
        return 49;
        
    }
    
    return 60;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (section == 1) {
        
       return 44;
    }
    
    
    return Space;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
   
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
//    if (section == 1) {
//        
//       
//            ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellFooterPay];
//            cell.delegate = self;
//            return cell;
//    }
    
    return nil;
}

#pragma mark - 查看帮助
- (void)checkAllAction{
    
    NSString *url = dataDic[@"refund_help"];
    NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
    lists.url = url;
    [self.navigationController pushViewController:lists animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        cell.order = [GoodsDetail authorGoodsWithDict:dataDic];
        cell.status.text = @"待支付";
        return cell;
        
    }else{
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        cell.realorder = [GoodsDetail authorGoodsWithDict:dataDic];
        return cell;
        
    }
    
    
}

- (void)getData{
    
    //网络请求
    //    NSString *uuid = @"";
    //    if ([PublicMethods isLogIn]) {
    //        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    //    }
    
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_number":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:RealOrderDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self->dataDic = dic[@"data"];
        
     
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        
        
        
    }];
    
}




#pragma  mark - 去支付
- (IBAction)payAction:(UIButton *)sender {
    
    PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
    payVC.ordernumber = [dataDic objectForKey:@"order_number"];
    payVC.price = [dataDic objectForKey:@"price"];

        payVC.notifyUrlAli = AliPetCardNotifyUrl;
        payVC.notifyUrlWeixin = WXPetCardNotifyUrl;
    
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}


#pragma  mark - 取消订单/电话
- (IBAction)cancelAction:(UIButton *)sender {
    
//    if ([self.type integerValue] == 5 || [self.type integerValue] == 6) {
//
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",dataDic[@"tel"]]]]];
//        [self.view addSubview:callWebview];
//
//        return;
//
//    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_number":dataDic[@"order_number"]}];
    
    [YYNet POST:RealOrderCancel paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已取消" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
            
        }else{
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

@end
