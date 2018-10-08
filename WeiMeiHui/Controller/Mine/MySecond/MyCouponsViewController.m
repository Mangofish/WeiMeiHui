//
//  MyCouponsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyCouponsViewController.h"
#import "CouponTableViewCell.h"
#import "ThreeTypeOrderTableViewCell.h"
#import "OutdateCouponViewController.h"
#import "DYAdAlertView.h"
#import "ZYInputAlertView.h"
#import "DYAdModel.h"


#import "TYAlertController+BlurEffects.h"
#import "UIView+TYAlertView.h"

@interface MyCouponsViewController ()<UITableViewDelegate, UITableViewDataSource,ThreeTypeOrderTableViewCellDelegate,DYAdAlertDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (copy, nonatomic)  NSArray *useDataAry;
@property (copy, nonatomic)  NSArray *outDateDataAry;
@property (strong, nonatomic)  NSMutableDictionary *heightDic;
@end

@implementation MyCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _heightDic = [NSMutableDictionary dictionary];
    [self configNavView];
//    [self getData];
    
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
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight-44);
    
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
        }];
    
        [_mainTableView.mj_header beginRefreshing];
    
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
    
    CouponTableViewCell *cell = [CouponTableViewCell couponTableViewCell];
    cell.couponList = [Coupon couponWithDict:self.useDataAry[indexPath.section]];
    _heightDic[@(indexPath.section)] = @(cell.cellHeight);
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_heightDic[@(indexPath.section)] doubleValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == self.useDataAry.count-1) {
        return 44;
    }
    return 0.000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == self.useDataAry.count-1) {
        
        ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellFooterT];
        cell.delegate = self;
        return cell;
        
    }
    
    return nil;
    
}

- (void)selectMoreAction{
    
    OutdateCouponViewController *outVC = [[OutdateCouponViewController alloc]init];
    outVC.outDateDataAry= self.outDateDataAry;
    
    [self.navigationController pushViewController:outVC animated:YES];
    
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
    
    [YYNet POST:MyCouponList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        NSArray *data = @[];
        if ([[dic[@"data"] objectForKey:@"use_list"] isKindOfClass:[NSArray class]]) {
            data = [dic[@"data"] objectForKey:@"use_list"];
        }
        if (data.count == 0) {
            self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有卡券"
                                                                        titleStr:@""
                                                                       detailStr:@""];
        }
        
        self.useDataAry = [dic[@"data"] objectForKey:@"use_list"];
        self.outDateDataAry = [dic[@"data"] objectForKey:@"lose_list"];
        
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
    
    if ([[self.useDataAry[indexPath.section] objectForKey:@"coupon_mode_id"] integerValue] == 3) {
        
        NSMutableArray *arr = [NSMutableArray array];
        DYAdModel *adModel  = [[DYAdModel alloc]init];
        adModel.imgStr      = [NSString stringWithFormat:@"%@",[self.useDataAry[indexPath.section] objectForKey:@"QrCode"]];
        [arr addObject:adModel];
        
         [DYAdAlertView  showInView:self.view theDelegate:self theADInfo:arr placeHolderImage:@"test2"];
        
    }
    
}

- (void)close{
    
    [_mainTableView.mj_header beginRefreshing];
    
}

@end
