//
//  AuthorsorderListViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorsorderListViewController.h"
#import "HWDownSelectedView.h"
#import "AuthorWaitTableViewCell.h"
#import "AuthorConfirmViewController.h"
#import "AlreadyPayOrderViewController.h"
#import "MoneyBackViewController.h"
#import "ChatViewController.h"
#import "AuthorDetailViewController.h"

@interface AuthorsorderListViewController ()<UITableViewDelegate,UITableViewDataSource,HWDownSelectedViewDelegate,AuthorWaitTableViewCellDelegate>{
    NSMutableArray *dataAry;
    NSUInteger page;
    NSMutableDictionary *heightDic;
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) YMRefresh *ymRefresh;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, weak) HWDownSelectedView *downView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) CFAbsoluteTime start;
@property (nonatomic, copy) NSArray *typeAry;
@end

@implementation AuthorsorderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataAry = [NSMutableArray array];
    heightDic = [NSMutableDictionary dictionary];
//    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    page = 1;
    if (_status.length == 0) {
            _status = @"";
    }

    [self configNavView];
    _start = CFAbsoluteTimeGetCurrent();
//    [self getData];
    
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:SHOULDREFRESH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-Space);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-SafeAreaHeight-Space);
//    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        page = 1;
//        [self getData];
//    }];
//    _mainTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        page++;
//        [self getData];
//    }];
    
    _ymRefresh = [[YMRefresh alloc] init];
    __weak AuthorsorderListViewController *weakSelf = self;
    [_ymRefresh gifModelRefresh:_mainTableView refreshType:RefreshTypeDouble firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        self->page = 1;
        [self getData];
        
    } upDropBlock:^{
        
        if ([weakSelf.mainTableView.mj_footer isRefreshing]) {
            self->page++;
            [self getData];
        }
    }];
    
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
//    down.listArray = @[@"全部",@"待接单", @"已接单",@"已支付",@"待评价", @"退款"];
    [self.view addSubview:down];
    //    down.frame = CGRectMake(kWidth-100-Space, SafeAreaTopHeight-10, 100, 40);
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
    }];
    down.delegate = self;
    
    self.downView = down;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataAry.count;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    AuthorOrdersModel *order = [AuthorOrdersModel orderInfoWithDict:dataAry[indexPath.section]];
    
    
    switch ([order.status integerValue]) {
//            待接
        case 0:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellWait];
            cell.tag = indexPath.section;
            cell.order = order;
            
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            NSInteger rest = [[dataAry[indexPath.section] objectForKey:@"rest_time"] integerValue];
            NSInteger second = rest - round(CFAbsoluteTimeGetCurrent()-_start);
            [cell setConfigWithSecond:second];
            cell.delegate = self;
            return cell;
        }
            break;
            //            已接
        case 1:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellYet];
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.orderYet = order;
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            return cell;
        }
            break;
            //            已支付
        case 2:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellPayback];
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.orderPay = order;
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            return cell;
        }
            break;
            //            已完成
        case 3:
        case 4:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellCancel];
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.orderFinish = order;
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
           
            return cell;
        }
            break;
            //            已取消
        case 5:
        case 6:
        case 7:
        case 8:
        case 14:
        case 12:
        case 13:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellWait];
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.orderCancel = order;
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            return cell;
        }
            break;
            
        case 9:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellPayback];
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.orderPayBack = order;
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            NSInteger rest = [[dataAry[indexPath.section] objectForKey:@"rest_time"] integerValue];
//            NSInteger second = rest - round(CFAbsoluteTimeGetCurrent()-_start);
            [cell setConfigWithSecondPay:rest];
            return cell;
        }
            break;
//            拒绝退款
        case 10:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellPayback];
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.orderPayBackReject = order;
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            return cell;
        }
            break;
//            退款成功
        case 11:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellPayback];
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.orderPayBackFinish = order;
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            return cell;
        }
            break;
//            已被其他人服务
        case 15:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellWait];
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.orderchooseOther = order;
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            return cell;
        }
            break;
        default:
        {
            AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellPayback];
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.orderPayBackAllow = order;
            heightDic[@(indexPath.section)] = @(cell.cellHeight);
            return cell;
        }
            break;
    }
    
    return nil;
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [heightDic[@(indexPath.section)] doubleValue];
}

- (void)getData{
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"status":_status,@"uuid":uuid,@"page":@(page)}];
    
    [YYNet POST:MineAutorOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        NSArray *temp = @[];
        if ([[dict[@"data"] objectForKey:@"group_data"] isKindOfClass:[NSArray class]]) {
            temp = [dict[@"data"] objectForKey:@"group_data"];
        }
        
        if (self->page ==1 ) {
            
            [self->dataAry setArray:temp];
            
        }else{
            
            [self->dataAry addObjectsFromArray:temp];
        }
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        [self.mainTableView reloadData];
        
        if ([[dict[@"data"] objectForKey:@"type"] isKindOfClass:[NSArray class]]) {
            self.typeAry = [dict[@"data"] objectForKey:@"type"];
        }
        
        
        NSMutableArray *tempT = [NSMutableArray array];
        
        for (NSDictionary *obj in self.typeAry) {
            [tempT addObject:obj[@"name"]];
        }
        self.downView.listArray = tempT;
        
//        self.downView.listArray =
        
    } faild:^(id responseObject) {
        
        
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger state = [[dataAry[indexPath.section] objectForKey:@"status"] integerValue];
    
    switch (state) {
            //            待接单
        case 0:
        {
            AuthorConfirmViewController *confirmVC = [[AuthorConfirmViewController alloc]init];
            confirmVC.dataDic = dataAry[indexPath.section];
            [self.navigationController pushViewController:confirmVC animated:YES];
        }
            break;
            //            已接单
        case 1:
        {
            
        }
            break;
            //            已支付
        case 2:
        {
            AlreadyPayOrderViewController *confirmVC = [[AlreadyPayOrderViewController alloc]init];
            confirmVC.ID = [dataAry[indexPath.section] objectForKey:@"id"];
            confirmVC.status = @"2";
            confirmVC.statusString = @"已支付";
            [self.navigationController pushViewController:confirmVC animated:YES];
        }
            break;
            //            待评价
        case 3:
        {
            AlreadyPayOrderViewController *confirmVC = [[AlreadyPayOrderViewController alloc]init];
            confirmVC.ID = [dataAry[indexPath.section] objectForKey:@"id"];
            confirmVC.status = @"3";
            confirmVC.statusString = @"已完成";
            [self.navigationController pushViewController:confirmVC animated:YES];
        }
            break;
//            已完成
        case 4:
        {
            AlreadyPayOrderViewController *confirmVC = [[AlreadyPayOrderViewController alloc]init];
            confirmVC.ID = [dataAry[indexPath.section] objectForKey:@"id"];
            confirmVC.status = @"4";
            confirmVC.statusString = @"已完成";
            [self.navigationController pushViewController:confirmVC animated:YES];
        }
            break;
            //            用户申请退款
        case 9:
        {
            MoneyBackViewController *confirmVC = [[MoneyBackViewController alloc]init];
            confirmVC.ID = [dataAry[indexPath.section] objectForKey:@"id"];
            confirmVC.status = @"9";
            confirmVC.statusString = @"用户申请退款";
            [self.navigationController pushViewController:confirmVC animated:YES];
        }
            break;
            //            退款驳回
        case 10:
        {
            AlreadyPayOrderViewController *confirmVC = [[AlreadyPayOrderViewController alloc]init];
            confirmVC.ID = [dataAry[indexPath.section] objectForKey:@"id"];
            confirmVC.status = @"10";
            confirmVC.statusString = @"退款驳回";
            [self.navigationController pushViewController:confirmVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Space;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        _status= @"";
    }else{
        _status = [NSString stringWithFormat:@"%ld",(long)indexPath.row-1];
    }
    
    page = 1;
    [self getData];
    
}

#pragma mark -删除订单
- (void)didClickDelOrder:(NSInteger)index{
    
    NSString *ID = [dataAry[index] objectForKey:@"id"];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":ID}];
    
    [YYNet POST:AuthorDelOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已删除" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            [self getData];
            
        }else{
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"删除失败" iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
}

#pragma mark -头像
- (void)didClickIcon:(NSInteger)index{
    
    NSString *uuid = [dataAry[index] objectForKey:@"uuid"];
    AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
    detailVc.ID = uuid;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

#pragma mark -私信
- (void)didClickMessageBtn:(NSUInteger)index {
    
    NSString *uuid = [dataAry[index] objectForKey:@"uuid"];
    ChatViewController *chatvc = [[ChatViewController alloc]init];
    chatvc.targetId = uuid;
    chatvc.conversationType = ConversationType_PRIVATE;
    chatvc.conversationTitle = [dataAry[index] objectForKey:@"nickname"];
    [self.navigationController pushViewController:chatvc animated:YES];
    
}
#pragma mark -同意
- (void)didClickAllowOrder:(NSInteger)index{
    
    
    
}
#pragma mark -接单
- (void)didClickTakeOrder:(NSInteger)index{
    
    AuthorConfirmViewController *confirmVC = [[AuthorConfirmViewController alloc]init];
    confirmVC.dataDic = dataAry[index];
    [self.navigationController pushViewController:confirmVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainTableView.mj_header beginRefreshing];
}
@end
