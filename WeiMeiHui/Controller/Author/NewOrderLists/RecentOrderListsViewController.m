//
//  RecentOrderListsViewController.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "RecentOrderListsViewController.h"
#import "ThreeTypeOrderTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "AllMineOrderListsViewController.h"

#import "MyWaitOrderViewController.h"
#import "WaitCommentViewController.h"
#import "AlredyOrderListViewController.h"
#import "AlreadyPayViewController.h"

#import "AuthorDetailViewController.h"
#import "GoodsDetailViewController.h"

#import "GroupWaitingForPayViewController.h"
#import "OrderWaitUseViewController.h"
#import "OrderWaitCommentsViewController.h"
#import "OrderCompletedViewController.h"
#import "OrderMoneyBackViewController.h"
#import "GroupPayOutdateViewController.h"
#import "WeiOrderWaitUseViewController.h"
#import "WeiOrderWaitOrMoneyViewController.h"
#import "SecKillOrderDetailViewController.h"
#import "RealGoodsOrderDetailViewController.h"
#import "RealGoodsWaitPayViewController.h"

@interface RecentOrderListsViewController ()<UITableViewDelegate, UITableViewDataSource,ThreeTypeOrderTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (copy, nonatomic)  NSArray *orderDataAry;
@property (copy, nonatomic)  NSArray *authorDataAry;

@end

@implementation RecentOrderListsViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self configNavView];
//    [self getData];
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
    
    [_questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];

//    [_mainTableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (_isMain) {
        
        self.backBtn.hidden = YES;
        self.navigationController.navigationBar.hidden = YES;
        _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1-48);
        
    }else{
        
        self.backBtn.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
        _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return (self.orderDataAry.count +self.authorDataAry.count +1);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section > self.orderDataAry.count) {
        
        ShopAuthor *author = [ShopAuthor shopAuthorWithDict:self.authorDataAry[section - self.orderDataAry.count -1]];
        
        return author.author_goods.count+1;
    }
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
     
        ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellTitle];
        cell.delegate = self;
        return cell;
        
    }
    
    if (indexPath.section <= self.orderDataAry.count) {
        
        ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCell];
        
        ThreeOrder *order = [ThreeOrder recentOrderWithDict:self.orderDataAry[indexPath.section-1]];
        
        NSUInteger type = [order.type integerValue];
//        定制
        if (type == 1) {
            
            switch ([order.status integerValue]) {
//              0，未接单1，已接2，已支付3，已扫码，未评价 4，已评价，已完成5，未接单取消  用户6，已接单取消7，手艺人已接单取消 8，手艺人已支付  取消订单  9 用户已支付 申请退款中 10 ，交易关闭 手艺人驳回 11 ，退款成功 交易关闭 12 ，手艺人已支付 取消退款成功 13，手艺人已支付取消退款失败  14 超时取消（未接单）
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
            
            
        }else if (type == 2){
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
                case 2:
                {
                    cell.activityCommentOrder = order;
                }
                    break;
                case 1:
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
            
        }else if(type == 4){
            
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
            
        }else{
//            实物商品
            switch ([order.status integerValue]) {
                    //              0未支付，1已支付，未使用，2已使用，未评价，3已评价，4已过期
                case 3:
                {
                    cell.realWaitPayOrder = order;
                }
                    break;
                case 1:
                {
                    cell.realUseOrder = order;
                }
                    break;
                    
                case 2:
                {
                    cell.realAlreadyUse = order;
                }
                    break;
                default:
                    break;
            }
            
            
        }
        
        
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            
            ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            
            if (cell == nil) {
                cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            }
            
            cell.author = [ShopAuthor shopAuthorWithDict:self.authorDataAry[indexPath.section - self.orderDataAry.count-1]];
            return cell;
        }else{
            
            ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            if (cell == nil) {
                cell = [ALLAuthorsTableViewCell allAuthorsTableViewCellSecond];
            }
            
            ShopAuthor *author = [ShopAuthor shopAuthorWithDict:self.authorDataAry[indexPath.section - self.orderDataAry.count -1]];
            cell.goods = [AuthorGoods authorGoodsWithDict:author.author_goods[indexPath.row-1]];
            return cell;
            
        }
        
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    if (indexPath.section == 0) {
        return 93;
    }
    
    if (indexPath.section > self.orderDataAry.count && self.authorDataAry.count) {
        
        if (indexPath.row == 0) {
            return 88;
        }
        
        return 49;
    }
    
    return 126;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1&& self.orderDataAry.count) {
        return 44;
    }
    
    if (section == self.orderDataAry.count +1 && self.authorDataAry.count) {
        return 44;
    }
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == self.orderDataAry.count && self.orderDataAry.count > 8) {
        return 44;
    }
    
    if ( section == self.orderDataAry.count && self.orderDataAry.count<8 && self.authorDataAry.count != 0) {
        return Space;
    }
    
    return 0.00001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == self.orderDataAry.count && self.orderDataAry.count >= 8) {
        ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellFooter];
        cell.delegate = self;
        return cell;
    }
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellHeader];
        
        return cell;
    }
    
    if (section == self.orderDataAry.count +1) {
        
        ThreeTypeOrderTableViewCell *cell = [ThreeTypeOrderTableViewCell threeTypeOrderTableViewCellHeaderAuthor];
        
        return cell;
    }
    
    return nil;
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
    
    [YYNet POST:RecentMyOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
       
        if ([[dic[@"data"] objectForKey:@"order_list"] isKindOfClass:[NSArray class]]) {
            self.orderDataAry = [dic[@"data"] objectForKey:@"order_list"];
        }
        
        
        if ([[dic[@"data"] objectForKey:@"author_data"] isKindOfClass:[NSArray class]]) {
            self.authorDataAry = [dic[@"data"] objectForKey:@"author_data"];
        }
        
    
        [self.mainTableView.mj_header endRefreshing];
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        AllMineOrderListsViewController *orderVC = [[AllMineOrderListsViewController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }else{
        
        if (indexPath.section <= self.orderDataAry.count) {
            
            ThreeOrder *order = [ThreeOrder recentOrderWithDict:self.orderDataAry[indexPath.section-1]];
            
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
                        waitVc.orderID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_id"];
                        waitVc.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"id"];
                        waitVc.titleStr = @"已支付";
                        waitVc.statusLab.text = @"已支付";
                        waitVc.btnStatus = 2;
                        [self.navigationController pushViewController:waitVc animated:YES];
                    }
                        break;
                        //            待评价
                    case 3:
                    {
                        WaitCommentViewController *waitVc = [[WaitCommentViewController alloc]init];
                        waitVc.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_id"];
                        [self.navigationController pushViewController:waitVc animated:YES];
                    }
                        break;
                        //            退款中
                    case 9:
                    case 16:
                    {
                        AlreadyPayViewController *waitVc = [[AlreadyPayViewController alloc]init];
                        waitVc.orderID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_id"];
                        waitVc.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"id"];
                        waitVc.titleStr= @"退款中";
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
                        waitVc.orderID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_id"];
                        waitVc.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"id"];
                        waitVc.titleStr = @"订单详情";
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
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
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
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 2:
                    {
                        OrderWaitUseViewController *grVC = [[OrderWaitUseViewController alloc]init];
                        grVC.status = @"待使用";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 3:
                    {
                        OrderWaitUseViewController *grVC = [[OrderWaitUseViewController alloc]init];
                        grVC.status = @"待使用";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 4:
                    {
                        OrderWaitCommentsViewController *grVC = [[OrderWaitCommentsViewController alloc]init];
                        grVC.status = @"待评价";
                        grVC.titleStr = @"待评价";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 5:
                    {
                        
                        OrderCompletedViewController *grVC = [[OrderCompletedViewController alloc]init];
                        grVC.status = @"已完成";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                    case 6:
                    {
                        OrderMoneyBackViewController *grVC = [[OrderMoneyBackViewController alloc]init];
                        grVC.status = @"退款完成";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 8:
                    {
                        OrderMoneyBackViewController *grVC = [[OrderMoneyBackViewController alloc]init];
                        grVC.status = @"退款中";
                        grVC.titleStr = @"微美惠拼团购";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 9:
                    {
//                        直接购买
                        if ([order.is_pay integerValue] == 1) {
                            
                        }else{
                            
                            GroupPayOutdateViewController *grVC = [[GroupPayOutdateViewController alloc]init];
                            grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                            [self.navigationController pushViewController:grVC animated:NO];
                            
                        }
                        
                    }
                        break;
                    default:
                        break;
                }
                
                
            }else if (type == 4 ){
                //            微信
                NSString *type = @"4";
               
                
                switch ([order.status integerValue]) {
                        
//                     0未支付，1待使用，2待评价，3已完成，4已过期   5退款中 6退款完成
                    case 0:
                    {
                        
                        WeiOrderWaitOrMoneyViewController *grVC = [[WeiOrderWaitOrMoneyViewController alloc]init];
                        grVC.status = @"待付款";
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        grVC.titleStr = @"订单详情";
                        grVC.type = @"0";
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                    case 5:
                    {
                        
                        WeiOrderWaitOrMoneyViewController *grVC = [[WeiOrderWaitOrMoneyViewController alloc]init];
                        grVC.status = @"退款中";
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        grVC.titleStr = @"订单详情";
                        grVC.type = @"5";
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                    case 6:
                    {
                        
                        WeiOrderWaitOrMoneyViewController *grVC = [[WeiOrderWaitOrMoneyViewController alloc]init];
                        grVC.status = @"退款完成";
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        grVC.titleStr = @"订单详情";
                        grVC.type = @"6";
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                   
                    case 1:
                    {
                        WeiOrderWaitUseViewController *grVC = [[WeiOrderWaitUseViewController alloc]init];
                        grVC.status = @"待使用";
                        grVC.titleStr = @"订单详情";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                    
                    case 2:
                    {
                        OrderWaitCommentsViewController *grVC = [[OrderWaitCommentsViewController alloc]init];
                        grVC.status = @"待评价";
                        grVC.titleStr = @"待评价";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 3:
                    {
                        
                        OrderCompletedViewController *grVC = [[OrderCompletedViewController alloc]init];
                        grVC.status = @"已完成";
                        grVC.titleStr = @"订单详情";
                        grVC.type = type;
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                        break;
                    
                    case 9:
                    {
                        //                        直接购买
                        if ([order.is_pay integerValue] == 1) {
                            
                        }else{
                            
                            GroupPayOutdateViewController *grVC = [[GroupPayOutdateViewController alloc]init];
                            grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                            [self.navigationController pushViewController:grVC animated:NO];
                            
                        }
                        
                    }
                        break;
                    default:
                        break;
                }
                
                
            }else if (type == 5 ){
//实物商品
                switch ([order.status integerValue]) {
                        
//                       1 待使用 2已使用 3 代付款
                    case 3:
                    {
                        
                        RealGoodsOrderDetailViewController *grVC = [[RealGoodsOrderDetailViewController alloc]init];
                       
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        
                        [self.navigationController pushViewController:grVC animated:YES];
                        
                    }
                    break;
                    case 1:
                    {
                        
                        RealGoodsWaitPayViewController *grVC = [[RealGoodsWaitPayViewController alloc]init];
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                        
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
                            grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                            grVC.type = @"0";
                            [self.navigationController pushViewController:grVC animated:YES];
                            
                            break;
                            
                        }
                        
                        GroupWaitingForPayViewController *grVC = [[GroupWaitingForPayViewController alloc]init];
                        grVC.status = @"待付款";
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
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
                            grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                            grVC.type = @"3";
                            [self.navigationController pushViewController:grVC animated:YES];
                            
                            break;
                            
                        }
                        
                        OrderWaitUseViewController *grVC = [[OrderWaitUseViewController alloc]init];
                        grVC.status = @"待使用";
                        grVC.titleStr = @"新用户一元剪发";
                        grVC.type = @"3";
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 4:
                    {
                        OrderWaitCommentsViewController *grVC = [[OrderWaitCommentsViewController alloc]init];
                        grVC.status = @"待评价";
                        grVC.titleStr = @"待评价";
                        grVC.type = @"5";
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
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
                        grVC.titleStr = @"已完成";
                        grVC.type = @"3";
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 6:
                    {
                        
                        if ([order.is_secKill integerValue] == 1 ) {
                            
                            break;
                            
                        }
                        
                        OrderMoneyBackViewController *grVC = [[OrderMoneyBackViewController alloc]init];
                        grVC.status = @"退款完成";
                        grVC.titleStr = @"新用户一元剪发";
                        grVC.type = @"3";
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                    case 8:
                    {
                        OrderMoneyBackViewController *grVC = [[OrderMoneyBackViewController alloc]init];
                        grVC.status = @"退款中";
                        grVC.titleStr = @"新用户一元剪发";
                        grVC.type = @"3";
                        grVC.ID = [self.orderDataAry[indexPath.section-1] objectForKey:@"order_number"];
                        [self.navigationController pushViewController:grVC animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            
            
        }else{
            
            if (indexPath.row == 0 ) {
                
                NSString *uuid = [self.authorDataAry[indexPath.section - self.orderDataAry.count-1] objectForKey:@"author_uuid"];
                AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
                detailVc.ID = uuid;
                [self.navigationController pushViewController:detailVc animated:YES];
                
            }else{
                
                NSArray *temp = [self.authorDataAry[indexPath.section - self.orderDataAry.count-1] objectForKey:@"author_goods"];
                
                NSString *uuid = [temp[indexPath.row-1] objectForKey:@"id"];
                GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
                detailVc.ID = uuid;
                detailVc.isGroup = [[temp[indexPath.row-1] objectForKey:@"is_group"] integerValue];
                [self.navigationController pushViewController:detailVc animated:YES];
                
            }
            
        }
        
    }
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_isMain) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    [self.mainTableView.mj_header beginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    if (_isMain) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    if (_isMain) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
}

- (void)checkAllAction{
    AllMineOrderListsViewController *orderVC = [[AllMineOrderListsViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

- (void)checkStates:(NSUInteger)index{
    
    AllMineOrderListsViewController *orderVC = [[AllMineOrderListsViewController alloc]init];
    
    
        orderVC.type = [NSString stringWithFormat:@"%lu",(unsigned long)index+1];
        orderVC.typeIndex = index+1;
    
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

@end
