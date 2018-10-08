//
//  MoneyBackViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MoneyBackViewController.h"
#import "AuthorWaitTableViewCell.h"
#import "MyReplyTableViewCell.h"

@interface MoneyBackViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *heightDic;
    NSDictionary *dataDic;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end

@implementation MoneyBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    heightDic = [NSMutableDictionary dictionary];
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
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-SafeAreaHeight-Space-44-44);
    
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Space;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [heightDic[@(indexPath.section)] doubleValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellPayback];
        cell.orderPay = [AuthorOrdersModel orderInfoWithDict:dataDic];
        cell.statusPayBack.text = _statusString;
        heightDic[@(indexPath.section)] = @(cell.cellHeight);
        return cell;
        
    }else{
        
        MyReplyTableViewCell *cell = [MyReplyTableViewCell myReplyTableViewCell];
        cell.order = [AuthorOrdersModel orderInfoWithDict:dataDic];
        heightDic[@(indexPath.section)] = @(cell.cellHeight);
        return cell;
        
    }
    
}

- (void)getData{
    
    //网络请求
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":_ID,@"status":_status}];
    
    [YYNet POST:AuthorOrdersDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            self->dataDic = dic[@"data"];
            [self.mainTableView reloadData];
            
        }else{
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
}


- (IBAction)cancel:(UIButton *)sender {
    
    
    
}
#pragma mark -同意
- (IBAction)confirmPay:(UIButton *)sender {
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":_ID,@"custom_id":dataDic[@"custom_id"]}];
    
    [YYNet POST:AuthorAllow paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"success"]];
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

#pragma mark -拒绝
- (IBAction)refusrePay:(UIButton *)sender {
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":_ID,@"custom_id":dataDic[@"custom_id"]}];
    
    [YYNet POST:AuthorRefuse paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已拒绝" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
            
        }else{
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"拒绝失败" iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
        }
        
    } faild:^(id responseObject) {
        
    }];
}

@end
