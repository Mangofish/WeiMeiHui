//
//  MyCouponListsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyCouponListsViewController.h"
#import "TYAlertController+BlurEffects.h"
#import "UIView+TYAlertView.h"

#import "CouponslistTableViewCell.h"
#import "NextFreeNewViewController.h"
#import "ShopCardsDetailsViewController.h"

#import "DYAdAlertView.h"
#import "ZYInputAlertView.h"
#import "DYAdModel.h"

@interface MyCouponListsViewController ()<UITableViewDelegate, UITableViewDataSource,CouponslistTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic)  NSMutableArray *useDataAry;
@property (copy, nonatomic)  NSDictionary *dataDic;
@property (strong, nonatomic)  NSMutableDictionary *heightDic;

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *notUseBtn;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation MyCouponListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _useDataAry = [NSMutableArray array];
    _heightDic = [NSMutableDictionary dictionary];
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
    
    [_questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+44, kWidth, kHeight-SafeAreaHeight-44);
    
    _bannerView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, 44);
    
    [_notUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/3);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.centerY.mas_equalTo(self.bannerView.mas_centerY);
    }];
    
    [_useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/3);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.notUseBtn.mas_right).offset(0);
        make.centerY.mas_equalTo(self.bannerView.mas_centerY);
    }];
    
    [_outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/3);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.useBtn.mas_right).offset(0);
        make.centerY.mas_equalTo(self.bannerView.mas_centerY);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(43);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.useDataAry.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponslistTableViewCell *cell = [[CouponslistTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.delegate = self;
    cell.tag = indexPath.section;
    CouponDown *coupon = [CouponDown couponWithDict:self.useDataAry[indexPath.section]];
    if ([coupon.status integerValue] == 1) {
        
        cell.coupon = coupon;
        
    }else if ([coupon.status integerValue] == 2) {
        
        cell.losecoupon = coupon;
        
    }else{
        
        cell.outcoupon = coupon;
        
    }
    
    _heightDic[@(indexPath.section)] = @(cell.cellHeight);
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_heightDic[@(indexPath.section)] doubleValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
    
}

- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:MyCouponsLists paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self.dataDic = dic[@"data"];
        NSArray *data = @[];
        if ([[dic[@"data"] objectForKey:@"use_list"] isKindOfClass:[NSArray class]]) {
            data = [dic[@"data"] objectForKey:@"use_list"];
        }
        if (data.count == 0) {
            self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有卡券"
                                                                        titleStr:@""
                                                                       detailStr:@""];
        }
        [self.useDataAry removeAllObjects];
        
        if (self.notUseBtn.selected) {
            [self.useDataAry addObjectsFromArray: [dic[@"data"] objectForKey:@"use_list"]];
        }else if (self.useBtn.selected){
            [self.useDataAry addObjectsFromArray: [dic[@"data"] objectForKey:@"lose_list"]];
        }else{
             [self.useDataAry addObjectsFromArray: [dic[@"data"] objectForKey:@"past_list"]];
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

- (IBAction)erAction:(UIButton *)sender {
    
    //    __weak typeof(self) weakSelf = self;
    
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    alertView.placeholder = @"输入提取码";
    [alertView confirmBtnClickBlock:^(NSString *inputString) {
        
        //        请求网络
        //网络请求
        NSString *uuid = @"";
        if ([PublicMethods isLogIn]) {
            uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        }
        
        NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"cdk_num":inputString}];
        
        [YYNet POST:GetCdkCoupon paramters:@{@"json":url} success:^(id responseObject) {
            
            NSDictionary *dic = [solveJsonData changeType:responseObject];
            
            if ([dic[@"success"] boolValue]) {
                [self.mainTableView.mj_header beginRefreshing];
//                [self getData];
                TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"" message:dic[@"info"]];
                
                [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                    NSLog(@"%@",action.title);
                }]];
                
                TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet transitionAnimation:TYAlertTransitionAnimationFade];
                alertController.backgoundTapDismissEnable = YES;
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else{
                //                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
                //                toast.toastType = FFToastTypeWarning;
                //                toast.toastPosition = FFToastPositionCentreWithFillet;
                //                [toast show];
                
                TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"" message:dic[@"info"]];
                
                [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                    NSLog(@"%@",action.title);
                }]];
                
                TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet transitionAnimation:TYAlertTransitionAnimationFade];
                alertController.backgoundTapDismissEnable = YES;
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            
            
        } faild:^(id responseObject) {
            
        }];
        
        
    }];
    [alertView show];
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger type = [[[self.useDataAry objectAtIndex:indexPath.section] objectForKey:@"type"] integerValue];
    if (type == 2) {
        
        NSString *url = [[self.useDataAry objectAtIndex:indexPath.section] objectForKey:@"url"] ;
        NextFreeNewViewController *adVC = [[NextFreeNewViewController alloc]init];
        adVC.url = url;
        [self.navigationController pushViewController:adVC animated:YES];
        
        
    }
    
    if (type == 3) {
        
//跳转详情页
        ShopCardsDetailsViewController *detailVC = [[ShopCardsDetailsViewController alloc]init];
        detailVC.ID = [self.useDataAry[indexPath.section] objectForKey:@"id"];
        detailVC.coupon_ID = [self.useDataAry[indexPath.section] objectForKey:@"coupon_id"];
        [self.navigationController pushViewController:detailVC animated:YES];
        
        
    }
    
}

- (void)close{
    
    [_mainTableView.mj_header beginRefreshing];
    
//    [self getData];
}

- (IBAction)notuseAction:(UIButton *)sender {
    
    [_notUseBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [_useBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [_outBtn setTitleColor:FontColor forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.center = CGPointMake(self.notUseBtn.center.x, self.lineView.frame.origin.y);
    }];
    
    
    if ([[_dataDic objectForKey:@"use_list"] isKindOfClass:[NSArray class]]) {
        [_useDataAry removeAllObjects];
        [_useDataAry addObjectsFromArray: [_dataDic objectForKey:@"use_list"]];
    }
    if (_useDataAry.count == 0) {
        self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有卡券"
                                                                    titleStr:@""
                                                                   detailStr:@""];
    }
    
    
    [self.mainTableView reloadData];
    
}

- (IBAction)useAction:(UIButton *)sender {
    
    [_useBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [_notUseBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [_outBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.center = CGPointMake(self.useBtn.center.x, self.lineView.frame.origin.y);
    }];
    
    
    if ([[_dataDic objectForKey:@"lose_list"] isKindOfClass:[NSArray class]]) {
        [_useDataAry removeAllObjects];
        [_useDataAry addObjectsFromArray: [_dataDic objectForKey:@"lose_list"]];
    }
    if (_useDataAry.count == 0) {
        self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有卡券"
                                                                    titleStr:@""
                                                                   detailStr:@""];
    }
    
    
    [self.mainTableView reloadData];
}

- (IBAction)outAction:(UIButton *)sender {
    
    [_outBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [_useBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [_notUseBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.center = CGPointMake(self.outBtn.center.x, self.lineView.frame.origin.y);
    }];
    
    if ([[_dataDic objectForKey:@"past_list"] isKindOfClass:[NSArray class]]) {
        [_useDataAry removeAllObjects];
        [_useDataAry addObjectsFromArray: [_dataDic objectForKey:@"past_list"]];
    }
    if (_useDataAry.count == 0) {
        self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有卡券"
                                                                    titleStr:@""
                                                                   detailStr:@""];
    }
    
    
    [self.mainTableView reloadData];
    
}

- (void)infoAction:(UIButton *)sender{
    
    NSDictionary *temp = [self.useDataAry objectAtIndex:sender.tag];
    
    if ([[temp objectForKey:@"isDown"] boolValue]) {
        
         [temp setValue:@(NO) forKey:@"isDown"];
        
    }else{
         [temp setValue:@(YES) forKey:@"isDown"];
    }
    
    [self.useDataAry replaceObjectAtIndex:sender.tag withObject:temp];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    [self.mainTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationFade)];
    
}

- (void)useCouponAction:(UIButton *)sender{
    
    NSUInteger type = [[[self.useDataAry objectAtIndex:sender.tag] objectForKey:@"type"] integerValue];
    if (type == 2) {
        
        NSString *url = [[self.useDataAry objectAtIndex:sender.tag] objectForKey:@"url"] ;
        NextFreeNewViewController *adVC = [[NextFreeNewViewController alloc]init];
        adVC.url = url;
        [self.navigationController pushViewController:adVC animated:YES];
        
        
    }
    
    if (type == 3) {
        
        //跳转详情页
        ShopCardsDetailsViewController *detailVC = [[ShopCardsDetailsViewController alloc]init];
        detailVC.ID = [self.useDataAry[sender.tag] objectForKey:@"id"];
        detailVC.coupon_ID = [self.useDataAry[sender.tag] objectForKey:@"coupon_id"];
        [self.navigationController pushViewController:detailVC animated:YES];
        
        
    }
    
    
}
@end
