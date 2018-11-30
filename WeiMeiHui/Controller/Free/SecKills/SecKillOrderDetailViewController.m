//
//  SecKillOrderDetailViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SecKillOrderDetailViewController.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "FamousShopTableViewCell.h"
#import "ErCodeOrderTableViewCell.h"
#import "AlertView.h"
#import "PayStyleViewController.h"

@interface SecKillOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,AlertViewDelegate>
{
        
    AlertView *alert;
    UIView *bgTapView;

    NSDictionary *dataDic;
}

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *restTimeLab;
@property (strong, nonatomic)  NSTimer *timer;

@end

@implementation SecKillOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    [self getData];
}

- (void)configNavView {
    
    if ([self.type integerValue] == 3) {
        [_cancelBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        _payBtn.hidden = YES;
        _restTimeLab.hidden = YES;
    }
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    [_restTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.payBtn.mas_top).mas_offset(-Space);
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
    
    if ([self.type integerValue] == 3) {
        return 3;
    }
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 4;
    }
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0 ) {
            
            return kWidth *189/375;
            
        }
        
        if (indexPath.row == 1 ) {
            
            return 60;
            
        }
        
        return 44;
        
    }
    
    if (indexPath.section == 2) {
        
        return 200;
        
    }
    
    return 60;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        
        if (dataDic) {
            cell.order = [GoodsDetail authorGoodsWithDict:dataDic];
        }
        
        cell.status.text = self.status;
        return cell;
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            FamousShopTableViewCell *cell = [FamousShopTableViewCell famousShopTableViewCellExclusive];
            
            if (dataDic) {
                cell.authorExclusive = [ShopAndAuthor shopAuthorWithDict:dataDic];
            }
            
            return cell;
        }
        
        if (indexPath.row == 1) {
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFour];
            
            if (dataDic) {
                cell.killorder = [GoodsDetail authorGoodsWithDict:dataDic];
            }
            
            return cell;
        }
        
        if (indexPath.row == 2) {
            
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOne];
            if (dataDic) {
                cell.goodsDetail = [GoodsDetail authorGoodsWithDict:dataDic];
            }
            return cell;
        }else {
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
            return cell;
        }
        
        
        }else{
            
            ErCodeOrderTableViewCell *cell = [ErCodeOrderTableViewCell erCodeOrderTableViewCellEasy];
            if (dataDic) {
                cell.goodsDetailEasy = [ThreeOrder recentOrderWithDict:dataDic];
            }
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
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:KillOrderDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self->dataDic = dic[@"data"];
        [self setConfigWithSecond: [self->dataDic[@"end_time"] integerValue]];
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        
        
        
    }];
    
}


#pragma  mark - 取消订单
- (void)cancelAction:(UIButton *)sender {
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":dataDic[@"order_number"]}];
    
    [YYNet POST:OrderDetailCancel paramters:@{@"json":url} success:^(id responseObject) {
        
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

- (void)didClickMenuIndex:(NSInteger)index{
    //          移除
    [UIView animateWithDuration:0.3 animations:^{
        self->alert.frame  =  CGRectMake(Space, kHeight, kWidth-Space*2, 131);
        self->bgTapView.hidden  = YES;
    }completion:^(BOOL finished) {
        [self->bgTapView removeFromSuperview];
        [self->alert removeFromSuperview];
    }];
    //          取消订单
    if (index == 1) {
        [self payback];
    }
}

#pragma mark - 申请退款
- (void)applyForMoney:(UIButton *)sender {
    if (!_ID.length) {
        return;
    }
    
    bgTapView = [[UIView alloc]initWithFrame:self.view.bounds];
    bgTapView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    bgTapView.tag = 100;
    [self.view addSubview:bgTapView];
    
    CGSize size = CGSizeMake(100, MAXFLOAT);
    //设置高度宽度的最大限度
    CGRect rect = [@"平台客服会在24小时内与店家沟通进行退款，申请成功后款项将原路退回，是否确认退款？" boundingRectWithSize:size options: NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
    
    AlertView *alertView = [AlertView alertViewWithFrame:CGRectMake(Space, kHeight-rect.size.height-20, kWidth-Space*2, rect.size.height)];
    alertView.delegate = self;
    alert = alertView;
    //    alert.titleLab.frame = CGRectMake(Space, Space, kWidth-Space*2, rect.size.height);
    alert.titleLab.text = @"平台客服会在24小时内与店家沟通进行退款，申请成功后款项将原路退回，是否确认退款？";
    [self.view addSubview:alertView];
    
    
}

- (void)payback{
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":_ID}];
    
    [YYNet POST:GroupUserApply paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        if ([dict[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"error"]];
            toast.toastType = FFToastTypeError;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
            //            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (IBAction)rightAction:(UIButton *)sender {
    
    if ([self.type integerValue] == 0) {
        
        [self cancelAction:nil];
        
    }else{
        
        [self applyForMoney:nil];
        
    }
    
}

- (IBAction)payAcion:(UIButton *)sender {
    
    PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
    payVC.ordernumber = self.ID;
    payVC.price = [dataDic objectForKey:@"sec_price"];
    payVC.notifyUrlAli = AliGroupMuchNotifyUrl;
    payVC.notifyUrlWeixin = WXGroupMuchNotifyUrl;
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}

- (void)setConfigWithSecond:(NSInteger)second {
    
    if (second > 0) {
        self.restTimeLab.text = [self ll_timeWithSecond:second];
    }
    else {
        self.restTimeLab.text = @"剩余支付时间 00:00";
    }
}

//将秒数转换为字符串格式
- (NSString *)ll_timeWithSecond:(NSInteger)second
{
    NSString *time;
    if (second < 60) {
        time = [NSString stringWithFormat:@"剩余支付时间 00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"剩余支付时间 %02ld:%02ld",second/60,second%60];
        }
        else {
            time = [NSString stringWithFormat:@"剩余支付时间 %02ld:%02ld:%02ld",second/3600,(second-second/3600*3600)/60,second%60];
        }
    }
    return time;
    
}
@end
