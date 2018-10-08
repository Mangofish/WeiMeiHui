//
//  OutdateCouponViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "OutdateCouponViewController.h"

#import "CouponTableViewCell.h"

@interface OutdateCouponViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic)  NSMutableDictionary *heightDic;


@end

@implementation OutdateCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _heightDic = [NSMutableDictionary dictionary];
    [self configNavView];
   
    
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
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight);
    
    //    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [self getData];
    //    }];
    
    //    [_mainTableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (_outDateDataAry.count == 0) {
        self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有卡券"
                                                                    titleStr:@""
                                                                   detailStr:@""];
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.outDateDataAry.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponTableViewCell *cell = [CouponTableViewCell couponTableViewCell];
    cell.couponOut = [Coupon couponWithDict:self.outDateDataAry[indexPath.section]];
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

- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
