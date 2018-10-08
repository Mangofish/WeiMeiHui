//
//  MyOrderListViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "MyOrderListTableViewCell.h"
#import "MyWaitOrderViewController.h"
#import "WaitCommentViewController.h"
#import "AlredyOrderListViewController.h"
#import "AlreadyPayViewController.h"
#import "HWDownSelectedView.h"

@interface MyOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,HWDownSelectedViewDelegate>{
    NSMutableArray *dataAry;
    NSUInteger page;
    NSMutableDictionary *heightDic;
    NSString *status;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, weak) HWDownSelectedView *downView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataAry = [NSMutableArray array];
    heightDic = [NSMutableDictionary dictionary];
    self.tabBarController.tabBar.hidden = YES;
    page = 1;
    status = @"";
    [self configNavView];
     [self getData];
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:SHOULDREFRESH];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-SafeAreaHeight-Space);
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self->page++;
        [self getData];
    }];
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
    down.listArray = @[@"全部",@"待接单", @"已接单",@"已支付",@"待评价", @"退款"];
    [self.view addSubview:down];
//    down.frame = CGRectMake(kWidth-100-Space, SafeAreaTopHeight-10, 100, 40);
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    down.delegate = self;
    
    self.downView = down;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataAry.count;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MyOrderListTableViewCell *cell = [MyOrderListTableViewCell myOrderListTableViewCell];
    
    cell.order = [MyOrderList myOrderListWithDict:dataAry[indexPath.section]];
    heightDic[@(indexPath.section)] = @(cell.cellHeight);
    return cell;
    
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
    
    NSString *url = [PublicMethods dataTojsonString:@{@"status":status,@"uuid":uuid,@"page":@(page)}];
    
    [YYNet POST:MineOrder paramters:@{@"json":url} success:^(id responseObject) {
        
       NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        if (self->page ==1 ) {
            
            [self->dataAry setArray:dict[@"data"]];
            
        }else{
            [self->dataAry addObjectsFromArray:dict[@"data"]];
        }
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger state = [[dataAry[indexPath.section] objectForKey:@"status"] integerValue];
    
    switch (state) {
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
            waitVc.orderID = [dataAry[indexPath.section] objectForKey:@"order_id"];
            waitVc.ID = [dataAry[indexPath.section] objectForKey:@"id"];
            waitVc.titleStr = @"已支付";
            waitVc.statusLab.text = @"已支付";
            [self.navigationController pushViewController:waitVc animated:YES];
        }
            break;
//            待评价
        case 3:
        {
            WaitCommentViewController *waitVc = [[WaitCommentViewController alloc]init];
            waitVc.ID = [dataAry[indexPath.section] objectForKey:@"order_id"];
            [self.navigationController pushViewController:waitVc animated:YES];
        }
            break;
//            退款中
        case 9:
        {
            AlreadyPayViewController *waitVc = [[AlreadyPayViewController alloc]init];
            waitVc.orderID = [dataAry[indexPath.section] objectForKey:@"order_id"];
            waitVc.ID = [dataAry[indexPath.section] objectForKey:@"id"];
            waitVc.titleStr = @"退款中";
            waitVc.statusLab.text = @"等待手艺人确认";
            waitVc.statusLab.textColor = MainColor;
            [self.navigationController pushViewController:waitVc animated:YES];
        }
            break;
//            退款驳回
        case 10:
        {
            AlreadyPayViewController *waitVc = [[AlreadyPayViewController alloc]init];
            waitVc.orderID = [dataAry[indexPath.section] objectForKey:@"order_id"];
            waitVc.ID = [dataAry[indexPath.section] objectForKey:@"id"];
            waitVc.titleStr = @"订单详情";
            waitVc.statustr= @"退款驳回";
            waitVc.statusLab.textColor = MainColor;
            [self.navigationController pushViewController:waitVc animated:YES];
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
    
    status = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    page = 1;
    [self getData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainTableView.mj_header beginRefreshing];
    
}
@end
