//
//  AuthorsAllOrderListViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorsAllOrderListViewController.h"
#import "HWDownSelectedView.h"
#import "AuthorWaitTableViewCell.h"
#import "AuthorConfirmViewController.h"
#import "AlreadyPayOrderViewController.h"
#import "MoneyBackViewController.h"
#import "AuthorDetailViewController.h"
#import "NormalAuthorTableViewCell.h"

#import "ActivityOrdersDetailViewController.h"

#import "AuthorConfirmViewController.h"
#import "AlreadyPayOrderViewController.h"
#import "MoneyBackViewController.h"
#import "ChatViewController.h"
#import "AuthorDetailViewController.h"

#import "UserDetailViewController.h"

@interface AuthorsAllOrderListViewController ()<UITableViewDelegate, UITableViewDataSource,HWDownSelectedViewDelegate,AuthorWaitTableViewCellDelegate>
{
    NSUInteger page;
    NSUInteger statusIndex;
    NSUInteger cusStatusIndex;
    NSString *status;
    NSString *path;
    NSMutableDictionary *heightDic;
}
@property (weak, nonatomic) IBOutlet UIButton *normalOrder;
@property (weak, nonatomic) IBOutlet UIButton *cusOrder;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic, assign) CFAbsoluteTime start;

@property (strong, nonatomic)  NSMutableArray *orderDataAry;
@property (strong, nonatomic)  HWDownSelectedView *down1;
@property (nonatomic, copy) NSArray *typeAry;

@end

@implementation AuthorsAllOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarController.tabBar.hidden = YES;
//    1.定制订单，2.普通订单
    
  
        
        if (self.type == 1) {
            
            path = MineAutorOrder;
            self.normalOrder.selected = NO;
            self.cusOrder.selected = YES;
            
        }else{
            path = AuthorOrderG;
            self.type = 2;
            self.cusOrder.selected = NO;
            self.normalOrder.selected = YES;
        }
        
    
    
    page = 1;
//    type = 2;
    heightDic = [NSMutableDictionary dictionary];
    self.orderDataAry = [NSMutableArray array];
    [self configNavView];
}

- (void)configNavView {
    
    status = @"";
    page = 1;
    self.orderDataAry = [NSMutableArray array];
    
    if (_isMain == 1) {
        self.tabBarController.tabBar.hidden = NO;
        self.navigationController.navigationBar.hidden = YES;
         _mainTableView.frame = CGRectMake(0, SafeAreaHeight+45, kWidth, kHeight-SafeAreaHeight-45-48);
        self.backBtn.hidden = YES;
    }else{
         self.tabBarController.tabBar.hidden = YES;
         _mainTableView.frame = CGRectMake(0, SafeAreaHeight+45, kWidth, kHeight-SafeAreaHeight-45);
    }
    
    
    _backView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);
//        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.backView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-5);
    }];
    
    
    [_normalOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(kWidth/2-25);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.view.mas_left).offset(25);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-5);
    }];
    
//    [_normalOrder ] = NSTextAlignmentRight;
    
    [_cusOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(kWidth/2-25);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-5);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
   
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _selectView.frame  = CGRectMake(0, SafeAreaHeight+1, kWidth, 44);
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
//    down.listArray = @[@"全部",@"待付款",@"待使用", @"待评价",@"退款售后"];
    [self.view addSubview:down];
    
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/4);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.top.mas_equalTo(self.selectView.mas_top).offset(0);
    }];
    down.delegate = self;
    down.tag = 1;
    self.down1 = down;
}

#pragma mark - 下拉列表
- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath {
    
   
    status = [NSString stringWithFormat:@"%@",[self.typeAry[indexPath.row] objectForKey:@"id"]];
    
    if (self.type == 1) {
        cusStatusIndex = indexPath.row;
    }else{
        statusIndex = indexPath.row;
    }
    
    page = 1;
    [self.mainTableView.mj_header beginRefreshing];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderDataAry.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 1) {
        
        AuthorOrdersModel *order = [AuthorOrdersModel orderInfoWithDict:self.orderDataAry[indexPath.section]];
        switch ([order.status integerValue]) {
                //            待接
            case 0:
            {
                AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellWait];
                cell.tag = indexPath.section;
                cell.order = order;
                
                heightDic[@(indexPath.section)] = @(cell.cellHeight);
                NSInteger rest = [[self.orderDataAry[indexPath.section] objectForKey:@"rest_time"] integerValue];
//                NSInteger second = rest - round(CFAbsoluteTimeGetCurrent()-_start);
                [cell setConfigWithSecond:rest];
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
                NSInteger rest = [[self.orderDataAry[indexPath.section] objectForKey:@"rest_time"] integerValue];
//                NSInteger second = rest - round(CFAbsoluteTimeGetCurrent()-_start);
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
        
    }else{
        
        
        NormalAuthorTableViewCell *cell = [NormalAuthorTableViewCell normalAuthorTableViewCell];
        cell.author = [AuthorOrdersModel orderInfoWithDict:self.orderDataAry[indexPath.section]];
        heightDic[@(indexPath.section)] = @(134);
        return cell;
    }
    
  
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [heightDic[@(indexPath.section)] doubleValue];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 2) {
        
        NSUInteger isActivity = [[[self.orderDataAry objectAtIndex:indexPath.section] objectForKey:@"type"] integerValue];
//        活动
        if (isActivity == 3) {
            
            ActivityOrdersDetailViewController *acVC = [[ActivityOrdersDetailViewController alloc]init];
            acVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
            acVC.type = isActivity;
            acVC.titleStr = @"活动订单";
            acVC.path = AuthorOrderDetailG;
            [self.navigationController pushViewController:acVC animated:YES];
            
        }else{
            
            ActivityOrdersDetailViewController *acVC = [[ActivityOrdersDetailViewController alloc]init];
            acVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
            acVC.type = isActivity;
            acVC.titleStr = @"普通订单";
            acVC.path = AuthorOrderDetailG;
            [self.navigationController pushViewController:acVC animated:YES];
            
            
        }
        
    }else{
        
        
            
            NSUInteger state = [[_orderDataAry[indexPath.section] objectForKey:@"status"] integerValue];
            
            switch (state) {
                    //            待接单
                case 0:
                {
                    AuthorConfirmViewController *confirmVC = [[AuthorConfirmViewController alloc]init];
                    confirmVC.dataDic = _orderDataAry[indexPath.section];
                    [self.navigationController pushViewController:confirmVC animated:YES];
                }
                    break;
                    //            已接单
                case 1:
                {
                    AlreadyPayOrderViewController *confirmVC = [[AlreadyPayOrderViewController alloc]init];
                    confirmVC.ID = [_orderDataAry[indexPath.section] objectForKey:@"id"];
                    confirmVC.status = @"1";
                    confirmVC.statusString = @"已接单";
                    [self.navigationController pushViewController:confirmVC animated:YES];
                }
                    break;
                    //            已支付
                case 2:
                {
                    AlreadyPayOrderViewController *confirmVC = [[AlreadyPayOrderViewController alloc]init];
                    confirmVC.ID = [_orderDataAry[indexPath.section] objectForKey:@"id"];
                    confirmVC.status = @"2";
                    confirmVC.statusString = @"已支付";
                    [self.navigationController pushViewController:confirmVC animated:YES];
                }
                    break;
                    //            待评价
                case 3:
                {
                    AlreadyPayOrderViewController *confirmVC = [[AlreadyPayOrderViewController alloc]init];
                    confirmVC.ID = [_orderDataAry[indexPath.section] objectForKey:@"id"];
                    confirmVC.status = @"3";
                    confirmVC.statusString = @"已完成";
                    [self.navigationController pushViewController:confirmVC animated:YES];
                }
                    break;
                    //            已完成
                case 4:
                {
                    AlreadyPayOrderViewController *confirmVC = [[AlreadyPayOrderViewController alloc]init];
                    confirmVC.ID = [_orderDataAry[indexPath.section] objectForKey:@"id"];
                    confirmVC.status = @"4";
                    confirmVC.statusString = @"已完成";
                    [self.navigationController pushViewController:confirmVC animated:YES];
                }
                    break;
                    //            用户申请退款
                case 9:
                {
                    MoneyBackViewController *confirmVC = [[MoneyBackViewController alloc]init];
                    confirmVC.ID = [_orderDataAry[indexPath.section] objectForKey:@"id"];
                    confirmVC.status = @"9";
                    confirmVC.statusString = @"用户申请退款";
                    [self.navigationController pushViewController:confirmVC animated:YES];
                }
                    break;
                    //            退款驳回
                case 10:
                {
                    AlreadyPayOrderViewController *confirmVC = [[AlreadyPayOrderViewController alloc]init];
                    confirmVC.ID = [_orderDataAry[indexPath.section] objectForKey:@"id"];
                    confirmVC.status = @"10";
                    confirmVC.statusString = @"退款驳回";
                    [self.navigationController pushViewController:confirmVC animated:YES];
                }
                    break;
                default:
                    break;
            }
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
    
//    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(page),@"type":type,@"status":status}];
    
    NSString *url;
    
//    定制
    if (self.type == 1) {
        
        url = [PublicMethods dataTojsonString:@{@"status":status,@"uuid":uuid,@"page":@(page)}];
        
    }else{
//        普通
        url = [PublicMethods dataTojsonString:@{@"type":status,@"uuid":uuid,@"page":@(page)}];
        
    }
    

    [YYNet POST:path paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        NSArray *temp = @[];
        
        
        if ([[dict[@"data"] objectForKey:@"type"] isKindOfClass:[NSArray class]]) {
            self.typeAry = [dict[@"data"] objectForKey:@"type"];
        }
        
        
        NSMutableArray *tempT = [NSMutableArray array];
        
        for (NSDictionary *obj in self.typeAry) {
            [tempT addObject:obj[@"name"]];
        }
        
        //    定制
        if (self.type == 1) {
            
           self.down1.selectedIndex = self->cusStatusIndex;
            
        }else{
            //        普通
           self.down1.selectedIndex = self->statusIndex;
            
        }
        
        
        self.down1.listArray = tempT;
        
        if (self.type == 1) {
            
//            self.down1.hidden = YES;
            if ([[dict[@"data"] objectForKey:@"group_data"] isKindOfClass:[NSArray class]]) {
                
                temp = [dict[@"data"] objectForKey:@"group_data"];
                
            }else{
                [self.orderDataAry removeAllObjects];
                [self.mainTableView.mj_header endRefreshing];
                [self.mainTableView.mj_footer endRefreshing];
                
                [self.mainTableView reloadData];
                return ;
            }
            
            if (self->page ==1 ) {
                
                NSArray *data = @[];
                if ([[dict[@"data"] objectForKey:@"group_data"] isKindOfClass:[NSArray class]]) {
                    data =  [dict[@"data"] objectForKey:@"group_data"];
                }
                if (data.count == 0) {
                    self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有订单"
                                                                                titleStr:@""
                                                                               detailStr:@""];
                }
                
                self.orderDataAry =  [dict[@"data"] objectForKey:@"group_data"];
                
            }else{
                
                [self.orderDataAry addObjectsFromArray:temp];
            }
            
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            
            [self.mainTableView reloadData];
            
        
        }else{
            
            self.down1.hidden = NO;
            if ([[dict[@"data"] objectForKey:@"group_data"] isKindOfClass:[NSArray class]]) {
                temp = [dict[@"data"] objectForKey:@"group_data"];
            }else{
                
                [self.orderDataAry removeAllObjects];
                [self.mainTableView.mj_header endRefreshing];
                [self.mainTableView.mj_footer endRefreshing];
                
                [self.mainTableView reloadData];
                return;
            }
            
            if (self->page ==1 ) {
                
                NSArray *data = @[];
                if ([[dict[@"data"] objectForKey:@"group_data"] isKindOfClass:[NSArray class]]) {
                    data = [dict[@"data"] objectForKey:@"group_data"];
                }
                if (data.count == 0) {
                    self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有订单"
                                                                                titleStr:@""
                                                                               detailStr:@""];
                }
                
                self.orderDataAry = [dict[@"data"] objectForKey:@"group_data"];
                
            }else{
                
                [self.orderDataAry addObjectsFromArray:temp];
            }
            
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            
            [self.mainTableView reloadData];
            
        }
        
        
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)leftOrder:(UIButton *)sender {
    self.type = 2;
    self.normalOrder.selected = YES;
    self.cusOrder.selected = NO;
    path = AuthorOrderG;
    status = @"";
    page = 1;
    [self.mainTableView.mj_header beginRefreshing];
}

- (IBAction)rightOrder:(UIButton *)sender {
    
    self.type = 1;
    self.normalOrder.selected = NO;
    self.cusOrder.selected = YES;
    
    status = @"";
    path = MineAutorOrder;
    page = 1;
    [self.mainTableView.mj_header beginRefreshing];
}

#pragma mark -删除订单
- (void)didClickDelOrder:(NSInteger)index{
    
    NSString *ID = [self.orderDataAry[index] objectForKey:@"id"];
    
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
    
    
//    NSUInteger level = [[self.orderDataAry[index] objectForKey:@"level"] integerValue];
    
//    1 商家 2 手艺人 3用户
    
//    if (level == 3) {
    
        NSString *uuid = [self.orderDataAry[index] objectForKey:@"uuid"];
        UserDetailViewController *weiVC  = [[UserDetailViewController alloc]init];
        weiVC.ID = uuid;
        [self.navigationController pushViewController:weiVC animated:YES];
        
//    }else{
//
//        NSString *uuid = [self.orderDataAry[index] objectForKey:@"uuid"];
//        AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
//        detailVc.ID = uuid;
//        [self.navigationController pushViewController:detailVc animated:YES];
//
//    }
    
    
}

#pragma mark -私信
- (void)didClickMessageBtn:(NSUInteger)index {
    
    NSString *uuid = [self.orderDataAry[index] objectForKey:@"uuid"];
    ChatViewController *chatvc = [[ChatViewController alloc]init];
    chatvc.targetId = uuid;
    chatvc.conversationType = ConversationType_PRIVATE;
    chatvc.conversationTitle = [self.orderDataAry[index] objectForKey:@"nickname"];
    [self.navigationController pushViewController:chatvc animated:YES];
    
}
#pragma mark -同意
- (void)didClickAllowOrder:(NSInteger)index{
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [_mainTableView.mj_header beginRefreshing];
    
}
@end
