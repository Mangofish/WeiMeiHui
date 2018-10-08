//
//  MyCardsListsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyCardsListsViewController.h"
#import "ShopCardsTableViewCell.h"
#import "ShopCardsDetailsViewController.h"
#import "PayStyleViewController.h"
#import "NextFreeNewViewController.h"

@interface MyCardsListsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic)  NSMutableArray *useDataAry;
@property (copy, nonatomic)  NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *notUseBtn;

@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation MyCardsListsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _useDataAry = [NSMutableArray array];
    self.notUseBtn.selected = YES;
    [self configNavView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getData];
    
}

- (void)configNavView {
    
    self.tabBarController.tabBar.hidden = YES;
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
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
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+44, kWidth, kHeight-SafeAreaHeight-44);
    
    _bannerView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, 44);
    
    [_notUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.centerY.mas_equalTo(self.bannerView.mas_centerY);
    }];
    
    
    [_outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.notUseBtn.mas_right).offset(0);
        make.centerY.mas_equalTo(self.bannerView.mas_centerY);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.bannerView.mas_bottom).offset(2);
        make.centerX.mas_equalTo(self.notUseBtn.mas_centerX);
    }];
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    
    //    [_mainTableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
//    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
//    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid}];
    
    [YYNet POST:MyCardsLists paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self.dataDic = dic[@"data"];
        NSArray *data = @[];
        if ([[dic[@"data"] objectForKey:@"usable_list"] isKindOfClass:[NSArray class]]) {
            data = [dic[@"data"] objectForKey:@"usable_list"];
        }
        if (data.count == 0) {
            self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有卡券"
                                                                        titleStr:@""
                                                                       detailStr:@""];
        }
        [self.useDataAry removeAllObjects];
        
        if (self.notUseBtn.selected) {
             [self.useDataAry addObjectsFromArray: [dic[@"data"] objectForKey:@"usable_list"]];
        }else{
             [self.useDataAry addObjectsFromArray: [dic[@"data"] objectForKey:@"overdue_list"]];
        }
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        
    }];
    
}

- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.useDataAry.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopCardsTableViewCell *cell = [ShopCardsTableViewCell shopCardsTableViewCell];
    cell.card = [ShopCard shopCardWithDict:self.useDataAry[indexPath.section]];
    
    if (self.outBtn.selected) {
        cell.buyBtn.hidden = NO;
    }else{
        cell.buyBtn.hidden = YES;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 210;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
    
}

#pragma - mark - 选择
- (IBAction)leftAction:(UIButton *)sender {
    sender.selected = YES;
    _outBtn.selected = NO;
    [_notUseBtn setTitleColor:MainColor forState:UIControlStateSelected];
    [_outBtn setTitleColor:FontColor forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.center = CGPointMake(sender.center.x,self.lineView.center.y);
    }];
    
    
    if ([[_dataDic objectForKey:@"usable_list"] isKindOfClass:[NSArray class]]) {
        [_useDataAry removeAllObjects];
        [_useDataAry addObjectsFromArray: [_dataDic objectForKey:@"usable_list"]];
    }
    
    if (_useDataAry.count == 0) {
        self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有卡券"
                                                                    titleStr:@""
                                                                   detailStr:@""];
    }
    
    
    [self.mainTableView reloadData];
    
}

- (IBAction)rightAction:(UIButton *)sender {
    sender.selected = YES;
    _notUseBtn.selected = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.center = CGPointMake(sender.center.x,self.lineView.center.y);
    }];
    
    [_notUseBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [_outBtn setTitleColor:MainColor forState:UIControlStateSelected];
    
    if ([[_dataDic objectForKey:@"overdue_list"] isKindOfClass:[NSArray class]]) {
        [_useDataAry removeAllObjects];
        [_useDataAry addObjectsFromArray: [_dataDic objectForKey:@"overdue_list"]];
    }
    if (_useDataAry.count == 0) {
        self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有卡券"
                                                                    titleStr:@""
                                                                   detailStr:@""];
    }
    
    
    [self.mainTableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.notUseBtn.selected) {
        
        ShopCardsDetailsViewController *detailVC = [[ShopCardsDetailsViewController alloc]init];
        detailVC.ID = [self.useDataAry[indexPath.section] objectForKey:@"order_number"];
        detailVC.remainder = [self.useDataAry[indexPath.section] objectForKey:@"remainder"];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else{
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = self.useDataAry[indexPath.section][@"url"];
        [self.navigationController pushViewController:lists animated:YES];
//        购买
//        [self payAction:self.useDataAry[indexPath.row][@"id"]];
    }
    
}

#pragma mark- 支付
- (void)payAction:(NSString *)cardID{
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }else{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":cardID}];
    
    [YYNet POST:CardsBuy paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
            payVC.ordernumber = [dic[@"data"] objectForKey:@"order_number"];
            payVC.price = [dic[@"data"] objectForKey:@"price"];
            
            payVC.notifyUrlAli = AliCardsNotifyUrl;
            payVC.notifyUrlWeixin = WXCardsNotifyUrl;
            
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
