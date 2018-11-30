//
//  AlredyOrderListViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AlredyOrderListViewController.h"
#import "NormalContentLabel.h"
#import "TYTextContainer.h"
#import "AlertView.h"
#import "AlreadyOrderTableViewCell.h"
#import "MyYetOrders.h"
#import "PayStyleViewController.h"
#import "AuthorDetailViewController.h"
#import "ChatViewController.h"

@interface AlredyOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,AlertViewDelegate,AlreadyOrderTableViewCellDelegate>{
    NormalContentLabel *_contentAttributedLabel;//自身内容
    TYTextContainer * textContainer;
    AlertView *alert;
    UIView *bgTapView;
    NSMutableArray *dataAry;
    NSUInteger page;
    MyYetOrders *modelOrder;
    NSMutableDictionary *heightDic;
    NSArray *tagAry;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *orderNumBg;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UIView *introBg;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *rangeLan;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation AlredyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    page = 1;
    dataAry = [NSMutableArray array];
    heightDic = [NSMutableDictionary dictionary];
    
    self.tabBarController.tabBar.hidden = YES;
    
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
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    //    订单
    [_orderNumBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(Space);
    }];
    
    [_orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.orderNumBg.mas_top).offset(0);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        page++;
        [self getData];
    }];
    [_mainTableView.mj_header beginRefreshing];
}
- (void)getData{
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"page":@(page)}];
    
    [YYNet POST:MyYetOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *temp = dict[@"data"];
        self->modelOrder = [MyYetOrders myYetOrdersWithDict:temp];
        
        if (self->page == 1) {
            self->_priceLab.text = self->modelOrder.price;
            self->_rangeLan.text = [NSString stringWithFormat:@"服务区域：%@",self->modelOrder.area];
            self->_tagLab.text = self->modelOrder.service_type;
            self->_orderNum.text = [NSString stringWithFormat:@"%@",self->modelOrder.order_number];
            [self calculateHegihtAndAttributedString:self->modelOrder.content];
            [self changeFrame];
        
            [self->dataAry setArray:temp[@"author_list"]];
            
        }else{
            [self->dataAry addObjectsFromArray:temp[@"author_list"]];
        }
        
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        
    } faild:^(id responseObject) {
        
        
    }];
}


#pragma mark- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataAry.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [heightDic[@(indexPath.section)] doubleValue];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Space;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 44;
    }
    
    return 0.00001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 43)];
        lab.backgroundColor = [UIColor whiteColor];
        lab.text = modelOrder.receiving_num;
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = MJRefreshColor(51, 51, 51);
        [v addSubview:lab];
        return v;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AlreadyOrderTableViewCell *cell = [AlreadyOrderTableViewCell alreadyOrderTableViewCell];
    cell.tag = indexPath.section;
    cell.order = [MainOrderStatusAlready mainOrderStatusWithDict:dataAry[indexPath.section]];
    heightDic[@(indexPath.section)] = @(cell.cellHeight);
    
    cell.delegate = self;
    return cell;
    
}

- (void)changeFrame{
    
    _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space, 54, kWidth-Space*2, textContainer.textHeight)];
    
    if (textContainer.textHeight > 46) {
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space, 54, kWidth-Space*2, 46)];
    }
    
    _contentAttributedLabel.text = modelOrder.content;
    
    _introBg.frame = CGRectMake(0, 45+SafeAreaHeight+Space, kWidth, 100+CGRectGetHeight(_contentAttributedLabel.frame));
    [self.introBg addSubview:_contentAttributedLabel];
    
    _mainTableView.frame = CGRectMake(0, CGRectGetMaxY(self.introBg.frame)+Space, kWidth, kHeight - CGRectGetMaxY(self.introBg.frame)-Space);
    
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.introBg.mas_top).offset(Space*2);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.top.mas_equalTo(self.introBg.mas_top).offset(Space*2);
    }];
    
    [_rangeLan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(24);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.introBg.mas_bottom).offset(-15);
    }];
    
}

- (IBAction)cancelOrderAction:(UIButton *)sender {
    
    bgTapView = [[UIView alloc]initWithFrame:self.view.bounds];
    bgTapView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:bgTapView];
    
    AlertView *alertView = [AlertView alertViewWithFrame:CGRectMake(Space, kHeight-131-20, kWidth-Space*2, 131)];
    alertView.delegate = self;
    alert = alertView;
    [self.view addSubview:alertView];
    
}

#pragma 计算高度
-(void)calculateHegihtAndAttributedString:(NSString *)content
{
    textContainer = [[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing=6;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:14];
    textContainer.text = content;
    textContainer.textColor = MJRefreshColor(51, 51, 51);
    
    textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2];
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
        [self cancelNet];
    }
}

- (void)cancelNet{
    
    if (!modelOrder.ID) {
        return;
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"custom_id":modelOrder.ID,@"type":@"1"}];
    
    [YYNet POST:CancelOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        if ([dict[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已取消！" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } faild:^(id responseObject) {
        
        
        
    }];
}
- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 支付
- (void)didClickPayOrder:(NSInteger)index{
    
    NSString *orderNum = [dataAry[index] objectForKey:@"order_number"];
    NSString *price = [dataAry[index] objectForKey:@"price"];
    
    PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
    payVC.ordernumber = orderNum;
    payVC.price = price;
    payVC.notifyUrlAli = AliNotifyUrl;
    payVC.notifyUrlWeixin = WXNotifyUrl;
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}

- (void)didClickMessageBtn:(NSUInteger)index {
    
    NSString *uuid = [dataAry[index] objectForKey:@"author_uuid"];
    NSString *name = [dataAry[index] objectForKey:@"nickname"];
    
    ChatViewController *chatvc = [[ChatViewController alloc]init];
    chatvc.targetId = uuid;
    chatvc.conversationTitle = name;
    chatvc.conversationType = ConversationType_PRIVATE;
    [self.navigationController pushViewController:chatvc animated:YES];
    
}


- (void)didClickIcon:(NSInteger)index{
    NSString *uuid = [dataAry[index] objectForKey:@"author_uuid"];
    AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
    detailVc.ID = uuid;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}


@end
