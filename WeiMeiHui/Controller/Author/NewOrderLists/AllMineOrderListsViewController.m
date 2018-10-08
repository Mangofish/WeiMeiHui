//
//  AllMineOrderListsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AllMineOrderListsViewController.h"
#import "ThreeTypeOrderTableViewCell.h"
#import "HWDownSelectedView.h"

#import "MyWaitOrderViewController.h"
#import "WaitCommentViewController.h"
#import "AlredyOrderListViewController.h"
#import "AlreadyPayViewController.h"

#import "GroupWaitingForPayViewController.h"
#import "OrderWaitUseViewController.h"
#import "OrderWaitCommentsViewController.h"
#import "OrderCompletedViewController.h"
#import "OrderMoneyBackViewController.h"
#import "GroupPayOutdateViewController.h"
#import "WeiOrderWaitUseViewController.h"
#import "WeiOrderWaitOrMoneyViewController.h"

#import "SecKillOrderDetailViewController.h"

@interface AllMineOrderListsViewController ()<UITableViewDelegate, UITableViewDataSource,HWDownSelectedViewDelegate>
{
    
    NSUInteger page;

}
@property (weak, nonatomic) IBOutlet UIButton *normalOrder;
@property (weak, nonatomic) IBOutlet UIButton *cusOrder;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UIView *selectView;


@property (strong, nonatomic)  NSMutableArray *orderDataAry;
@property (strong, nonatomic)  NSMutableArray *gradeAry;

@property (strong, nonatomic)  HWDownSelectedView *down1;
@property (strong, nonatomic)  YYHud *hud;
@end

@implementation AllMineOrderListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    
}

- (void)configNavView {
    
    if (self.status) {
        
        if ([self.status isEqualToString:@"1"]) {
            
            self.normalOrder.selected = YES;
             self.cusOrder.selected = NO;
            
        }else{
            
            self.cusOrder.selected = YES;
            self.normalOrder.selected = NO;
        }
        
    }else{
        
        self.status = @"1";
        
    }
    
    if (!_type) {
        _type = @"";
    }
    
    
    page = 1;
    self.orderDataAry = [NSMutableArray array];
    self.gradeAry = [NSMutableArray array];
    
    self.tabBarController.tabBar.hidden = YES;
    
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
    
//        [_normalOrder ] = NSTextAlignmentRight;
    
    [_cusOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(kWidth/2-25);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-5);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+45, kWidth, kHeight-SafeAreaHeight-45);
    
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self->page = 1;
            [self getData];
        }];
    
    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self->page ++;
        [self getData];
    }];
    
    
    
        [_mainTableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _selectView.frame  = CGRectMake(0, SafeAreaHeight+1, kWidth, 44);
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
    down.selectedIndex = self.typeIndex;
    [self.view addSubview:down];
    
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/4);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.selectView.mas_top).offset(0);
    }];
    
    down.listArray = @[@"全部",@"待付款",@"待使用", @"待评价",@"退款售后"];
    down.delegate = self;
    down.tag = 1;
    self.down1 = down;
}

#pragma mark - 下拉列表
- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        _type = @"";
    }else{
        _type = [NSString stringWithFormat:@"%li",indexPath.row];
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
    
        ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCell];
        
        ThreeOrder *order = [ThreeOrder recentOrderWithDict:self.orderDataAry[indexPath.section]];
        
        NSUInteger type = [order.type integerValue];
        //        定制
        if (type == 1) {
            
            switch ([order.status integerValue]) {
                    //              0，未接单1，已接2，已支付3，已扫码，未评价 4，已评价，已完成 5，未接单取消  用户6，已接单取消7，手艺人已接单取消 8，手艺人已支付  取消订单  9 用户已支付 申请退款中 10 ，交易关闭 手艺人驳回 11 ，退款成功 交易关闭 12 ，手艺人已支付 取消退款成功 13，手艺人已支付取消退款失败  14 超时取消（未接单）
                case 0:
                {
                    cell.cusWaitOrder = order;
                }
                    break;
                case 1:
                {
                    cell.cusTakeOrder = order;
                }
                    break;
                case 2:
                {
                    cell.cusPayOrder = order;
                }
                    break;
                case 3:
                {
                    cell.cusCommentOrder = order;
                }
                    break;
                case 4:
                {
                    cell.cusFinishOrder = order;
                }
                    break;
                case 5:
                {
                    cell.cusFinishOrder = order;
                }
                    break;
                case 8://?????
                {
                    cell.cusFinishOrder = order;
                }
                    break;
                case 9:
                case 16:
                {
                    cell.cusMoneyDuringOrder = order;
                }
                    break;
                case 10:
                {
                    cell.cusRefuseOrder = order;
                }
                    break;
                case 11:
                {
                    cell.cusMoneyPayBackOrder = order;
                }
                    break;
                default:
                    break;
            }
            
            
        }else if (type == 2 ){
            //            拼团
            switch ([order.status integerValue]) {
                    //              0 未支付 1 已支付未拼成 2 已拼成 3已支付
                case 0:
                case 7:
                {
                    cell.groupWaitPayOrder = order;
                }
                    break;
                case 1:
                {
                    cell.groupPeopleOrder = order;
                }
                    break;
                case 2:
                case 3:
                {
                    cell.groupUseOrder = order;
                }
                    break;
                case 4:
                {
                    cell.groupCommentOrder = order;
                }
                    break;
                case 5:
                {
                    cell.groupFinishOrder = order;
                }
                    break;
                case 6:
                {
                    cell.groupMoneyPayBackOrder = order;
                }
                    break;
                case 8:
                {
                    cell.groupMoneyDuringOrder = order;
                }
                    break;
                case 9:
                {
                    cell.groupFailOrder = order;
                }
                    break;
                default:
                    break;
            }
            
            
        }else if(type == 3){
            
            //            活动
            switch ([order.status integerValue]) {
                    //              0 未支付 1 已支付未拼成 2 已拼成 3已支付4.已使用5.已评价6.已退款 7 已拼成未支付8,退款中9已过期
                case 0:
                {
                    cell.activityWaitPayOrder = order;
                }
                    break;
                case 3:
                {
                    cell.activityUseOrder = order;
                }
                    break;
                case 4:
                {
                    cell.activityCommentOrder = order;
                }
                    break;
                case 5:
                {
                    cell.activityFinishOrder = order;
                }
                    break;
                case 6:
                {
                    cell.activityMoneyPayBackOrder = order;
                }
                    break;
                case 8:
                {
                    cell.activityMoneyDuringOrder = order;
                }
                    break;
                    
                default:
                    break;
            }
            
        }else{
            
            //            微信
            switch ([order.status integerValue]) {
                    //              0未支付，1已支付，未使用，2已使用，未评价，3已评价，4已过期
                case 0:
                {
                    cell.activityWaitPayOrder = order;
                }
                    break;
                case 1:
                {
                    cell.activityUseOrder = order;
                }
                    break;
                    
                case 2:
                {
                    cell.activityCommentOrder = order;
                }
                    break;
                case 3:
                {
                    cell.activityFinishOrder = order;
                }
                    break;
                case 5:
                {
                    cell.activityMoneyDuringOrder = order;
                }
                    break;
                case 6:
                {
                    cell.activityMoneyPayBackOrder = order;
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        
        return cell;

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 126;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    return 0.00001;
    
}


- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(page),@"type":_type,@"status":self.status}];
    
    _hud = [[YYHud alloc]init];
    [_hud showInView:self.view];
    
    [YYNet POST:MyOrderComplete paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
    
        [self.hud dismiss];
        
        if (self->page == 1) {
            
            NSArray *data = @[];
            if ([dic[@"data"] isKindOfClass:[NSArray class]]) {
                data = dic[@"data"];
                
            }
            if (data.count == 0) {
                self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有订单"
                                                                            titleStr:@""
                                                                           detailStr:@""];
            }
            
            [self.orderDataAry setArray: data];
            
        }else{
            [self.orderDataAry addObjectsFromArray: dic[@"data"]];
        }
        
        
//        if ([[dic[@"data"] objectForKey:@"author_grade"] isKindOfClass:[NSArray class]]) {
//
//            [self.gradeAry setArray:[dic[@"data"] objectForKey:@"author_grade"]];
//
//
//            NSMutableArray *temp = [NSMutableArray array];
//
//            for (NSDictionary *obj in self.gradeAry) {
//                [temp addObject:obj[@"name"]];
//            }
//
//            self.down1.selectedIndex = self->gradeIndex;
//            self.down1.listArray = temp;
//        }
        
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        [self.hud dismiss];
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
            
            ThreeOrder *order = [ThreeOrder recentOrderWithDict:self.orderDataAry[indexPath.section]];
            
            NSUInteger type = [order.type integerValue];
            //        定制
            //              0，未接单1，已接2，已支付3，已扫码，未评价 4，已评价，已完成5，未接单取消  用户6，已接单取消7，手艺人已接单取消 8，手艺人已支付  取消订单  9 用户已支付 申请退款中 10 ，交易关闭 手艺人驳回 11 ，退款成功 交易关闭 12 ，手艺人已支付 取消退款成功 13，手艺人已支付取消退款失败  14 超时取消（未接单）
            if (type == 1) {
                
                switch ([order.status integerValue]) {
                        //            待接单
                    case 0:
                    {
                        MyWaitOrderViewController *waitVc = [[MyWaitOrderViewController alloc]init];
                        [self.navigationController pushViewController:waitVc animated:YES];
                    }
                        break;
                        //            已接单
                    case 1:
                    {
                        AlredyOrderListViewController *waitVc = [[AlredyOrderListViewController alloc]init];
                        [self.navigationController pushViewController:waitVc animated:YES];
                    }
                        break;
                        //            已支付
                    case 2:
                    {
                        AlreadyPayViewController *waitVc = [[AlreadyPayViewController alloc]init];
                        waitVc.orderID = [self.orderDataAry[indexPath.section] objectForKey:@"order_id"];
                        waitVc.ID = [self.orderDataAry[indexPath.section] objectForKey:@"id"];
                        waitVc.titleLab.text = @"已支付";
                        waitVc.statusLab.text = @"已支付";
                        waitVc.btnStatus = 2;
                        [self.navigationController pushViewController:waitVc animated:YES];
                    }
                        break;
                        //            待评价
                    case 3:
                    {
                        WaitCommentViewController *waitVc = [[WaitCommentViewController alloc]init];
                        waitVc.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_id"];
                        [self.navigationController pushViewController:waitVc animated:YES];
                    }
                        break;
                        //            退款中
                    case 9:
                    case 16:
                    {
                        AlreadyPayViewController *waitVc = [[AlreadyPayViewController alloc]init];
                        waitVc.orderID = [self.orderDataAry[indexPath.section] objectForKey:@"order_id"];
                        waitVc.ID = [self.orderDataAry[indexPath.section] objectForKey:@"id"];
                        waitVc.titleStr = @"退款中";
                        waitVc.statusLab.text = @"等待手艺人确认";
                        waitVc.statusLab.textColor = MainColor;
                        waitVc.btnStatus = 9;
                        [self.navigationController pushViewController:waitVc animated:YES];
                    }
                        break;
                        //            退款驳回
                    case 10:
                    {
                        AlreadyPayViewController *waitVc = [[AlreadyPayViewController alloc]init];
                        waitVc.orderID = [self.orderDataAry[indexPath.section] objectForKey:@"order_id"];
                        waitVc.ID = [self.orderDataAry[indexPath.section] objectForKey:@"id"];
                        waitVc.titleStr = @"订单详情";
                        waitVc.infoStr = @"手艺人拒绝您的退款申请，您的订单仍可以正常使用。如需继续退款请点击屏幕右上角联系客服";
                        waitVc.statustr= @"退款驳回";
                        waitVc.statusLab.textColor = MainColor;
                        waitVc.btnStatus = 10;
                        [self.navigationController pushViewController:waitVc animated:YES];
                    }
                        break;
                    default:
                        break;
                }
                
                
            }else if (type == 2 ){
                //            拼团
                NSString *type = @"2";
                if ([order.is_pay integerValue] == 1) {
                    
                    type = @"1";
                    
                }
                
                switch ([order.status integerValue]) {
                        
                        //              0 未支付 1 已支付未拼成 2 已拼成 3已支付（单个商品非拼多多）4.已使用5.已评价6.已退款 7 已拼成未支付8,退款中9已过期）
                    case 0:
                    case 7:
                    {
                        
                        GroupWaitingForPayViewController *grVC = [[GroupWaitingForPayViewController alloc]init];
                        grVC.status = @"待付款";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                    case 1:
                    {
                        GroupWaitingForPayViewController *grVC = [[GroupWaitingForPayViewController alloc]init];
                        grVC.status = @"待拼成";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 2:
                    {
                        OrderWaitUseViewController *grVC = [[OrderWaitUseViewController alloc]init];
                        grVC.status = @"待使用";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 3:
                    {
                        OrderWaitUseViewController *grVC = [[OrderWaitUseViewController alloc]init];
                        grVC.status = @"待使用";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 4:
                    {
                        OrderWaitCommentsViewController *grVC = [[OrderWaitCommentsViewController alloc]init];
                        grVC.status = @"待评价";
                        grVC.titleStr = @"待评价";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 5:
                    {
                        
                        OrderCompletedViewController *grVC = [[OrderCompletedViewController alloc]init];
                        grVC.status = @"已完成";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                    case 6:
                    {
                        OrderMoneyBackViewController *grVC = [[OrderMoneyBackViewController alloc]init];
                        grVC.status = @"退款完成";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 8:
                    {
                        OrderMoneyBackViewController *grVC = [[OrderMoneyBackViewController alloc]init];
                        grVC.status = @"退款中";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 9:
                    {
                        //                        直接购买
                        if ([order.is_pay integerValue] == 1) {
                            
                        }else{
                            
                            GroupPayOutdateViewController *grVC = [[GroupPayOutdateViewController alloc]init];
                            grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                            [self.navigationController pushViewController:grVC animated:NO];
                            
                        }
                        
                    }
                        break;
                    default:
                        break;
                }
                
                
            }else if (type == 4 ){
                //            微信

                
                
                switch ([order.status integerValue]) {
                        
                        //              0 未支付 1 已支付未拼成 2 已拼成 3已支付（单个商品非拼多多）4.已使用5.已评价6.已退款 7 已拼成未支付8,退款中9已过期）
                    case 0:
                    {
                        
                        WeiOrderWaitOrMoneyViewController *grVC = [[WeiOrderWaitOrMoneyViewController alloc]init];
                        grVC.status = @"待付款";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        grVC.titleStr = @"订单详情";
                        grVC.type = @"0";
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                    case 5:
                    {
                        
                        WeiOrderWaitOrMoneyViewController *grVC = [[WeiOrderWaitOrMoneyViewController alloc]init];
                        grVC.status = @"退款中";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        grVC.titleStr = @"订单详情";
                        grVC.type = @"5";
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                    case 6:
                    {
                        
                        WeiOrderWaitOrMoneyViewController *grVC = [[WeiOrderWaitOrMoneyViewController alloc]init];
                        grVC.status = @"退款完成";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        grVC.titleStr = @"订单详情";
                        grVC.type = @"6";
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                        
                    case 1:
                    {
                        OrderWaitUseViewController *grVC = [[OrderWaitUseViewController alloc]init];
                        grVC.status = @"待使用";
                        grVC.titleStr = @"订单详情";
                        grVC.type = @"4";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                        
                    case 2:
                    {
                        OrderWaitCommentsViewController *grVC = [[OrderWaitCommentsViewController alloc]init];
                        grVC.status = @"待评价";
                        grVC.titleStr = @"待评价";
                        grVC.type = @"4";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 3:
                    {
                        
                        OrderCompletedViewController *grVC = [[OrderCompletedViewController alloc]init];
                        grVC.status = @"已完成";
                        grVC.titleStr = @"订单详情";
                        grVC.type = @"4";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                        
                    case 9:
                    {
                        //                        直接购买
                        if ([order.is_pay integerValue] == 1) {
                            
                        }else{
                            
                            GroupPayOutdateViewController *grVC = [[GroupPayOutdateViewController alloc]init];
                            grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                            [self.navigationController pushViewController:grVC animated:NO];
                            
                        }
                        
                    }
                        break;
                    default:
                        break;
                }
                
            }else{
                
                //            活动
                switch ([order.status integerValue]) {
                        //              0 未支付  3已支付4.已使用5.已评价6.已退款 7 已拼成未支付8,退款中9已过期
                    case 0:
                    {
                        
                        if ([order.is_secKill integerValue] == 1 ) {
                            
                            SecKillOrderDetailViewController *grVC = [[SecKillOrderDetailViewController alloc]init];
                            grVC.status = @"待支付";
                            grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                            grVC.type = @"0";
                            [self.navigationController pushViewController:grVC animated:YES];
                            
                            break;
                            
                        }
                        
                        GroupWaitingForPayViewController *grVC = [[GroupWaitingForPayViewController alloc]init];
                        grVC.status = @"待付款";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        grVC.titleStr = @"新用户一元剪发";
                        grVC.type = @"3";
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 3:
                    {
                        
                        if ([order.is_secKill integerValue] == 1 ) {
                            
                            SecKillOrderDetailViewController *grVC = [[SecKillOrderDetailViewController alloc]init];
                            grVC.status = @"待使用";
                            grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                            grVC.type = @"3";
                            [self.navigationController pushViewController:grVC animated:YES];
                            
                            break;
                            
                        }
                        
                        
                        OrderWaitUseViewController *grVC = [[OrderWaitUseViewController alloc]init];
                        grVC.status = @"待使用";
                        grVC.titleStr = @"新用户一元剪发";
                        grVC.type = @"3";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 4:
                    {
                        OrderWaitCommentsViewController *grVC = [[OrderWaitCommentsViewController alloc]init];
                        grVC.status = @"待评价";
                        grVC.titleStr = @"待评价";
                        grVC.type = @"3";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 5:
                    {
                        if ([order.is_secKill integerValue] == 1 ) {
                            
                            OrderCompletedViewController *grVC = [[OrderCompletedViewController alloc]init];
                            grVC.status = @"已完成";
                            grVC.titleStr = @"已完成";
                            grVC.type = @"5";
                            grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                            [self.navigationController pushViewController:grVC animated:YES];
                            
                            break;
                            
                        }
                        
                        OrderCompletedViewController *grVC = [[OrderCompletedViewController alloc]init];
                        grVC.status = @"已完成";
                        grVC.titleStr = @"新用户一元剪发";
                        grVC.type = @"3";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 6:
                    {
                        OrderMoneyBackViewController *grVC = [[OrderMoneyBackViewController alloc]init];
                        grVC.status = @"退款完成";
                        grVC.titleStr = @"新用户一元剪发";
                        grVC.type = @"3";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 8:
                    {
                        OrderMoneyBackViewController *grVC = [[OrderMoneyBackViewController alloc]init];
                        grVC.status = @"退款中";
                        grVC.titleStr = @"新用户一元剪发";
                        grVC.type = @"3";
                        grVC.ID = [self.orderDataAry[indexPath.section] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
    

    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftOrder:(UIButton *)sender {
    
    self.normalOrder.selected = YES;
    self.cusOrder.selected = NO;
    [self.down1 close];
    
    self.status = @"1";
    page = 1;
    [self.mainTableView.mj_header beginRefreshing];
}

- (IBAction)rightOrder:(UIButton *)sender {
    
    self.normalOrder.selected = NO;
    self.cusOrder.selected = YES;
    [self.down1 close];
    
     self.status = @"2";
    page = 1;
    [self.mainTableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.mainTableView.mj_header beginRefreshing];
    
}

#pragma mark -删除订单
- (void)didClickDelOrder:(NSInteger)index{
    
    NSString *ID = [_orderDataAry[index] objectForKey:@"id"];
    
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
    
//    NSString *uuid = [dataAry[index] objectForKey:@"uuid"];
//    AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
//    detailVc.ID = uuid;
//    [self.navigationController pushViewController:detailVc animated:YES];
    
}

#pragma mark -私信
- (void)didClickMessageBtn:(NSUInteger)index {
    
//    NSString *uuid = [dataAry[index] objectForKey:@"uuid"];
//    ChatViewController *chatvc = [[ChatViewController alloc]init];
//    chatvc.targetId = uuid;
//    chatvc.conversationTitle = [dataAry[index] objectForKey:@"nickname"];
//    [self.navigationController pushViewController:chatvc animated:YES];
    
}
#pragma mark -同意
- (void)didClickAllowOrder:(NSInteger)index{
    
    
    
}
#pragma mark -接单
- (void)didClickTakeOrder:(NSInteger)index{
    
//    AuthorConfirmViewController *confirmVC = [[AuthorConfirmViewController alloc]init];
//    confirmVC.dataDic = dataAry[index];
//    [self.navigationController pushViewController:confirmVC animated:YES];
    
}

@end
